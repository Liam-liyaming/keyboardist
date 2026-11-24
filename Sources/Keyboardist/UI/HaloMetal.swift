let haloShaderSource = """
        #include <metal_stdlib>
        using namespace metal;

        struct U {
            float2 res;
            float2 center;
            float4 c0, c1, c2, c3;
            float t, startR, growth, ringW, reduce, pad0, pad1, pad2;
            float push;
        };

        struct VOut { float4 pos [[position]]; };

        vertex VOut v_main(uint vid [[vertex_id]]) {
            float2 p[3] = { float2(-1.0, -1.0), float2(3.0, -1.0), float2(-1.0, 3.0) };
            VOut o; o.pos = float4(p[vid], 0.0, 1.0); return o;
        }

        float ease(float t, float k) {
            return (1.0 - pow(2.0, -k * t)) / (1.0 - pow(2.0, -k));
        }

        fragment float4 f_main(VOut in [[stage_in]],
                               constant U &u [[buffer(0)]],
                               texture2d<float> tex [[texture(0)]],
                               texture2d<float> lmask [[texture(1)]]) {
            constexpr sampler smp(filter::linear, address::clamp_to_edge);

            float2 px = in.pos.xy;
            float2 uv = px / u.res;
            float2 p = px - u.center;
            float d = length(p);

            float t = u.t;
            float R = u.startR + u.growth * ease(t, 6.0);
            float strength = min(1.0, t / 0.03) * (1.0 - pow(t, 2.2));
            float x = (d - R) / u.ringW;

            float w0 = exp(-pow((x + 1.5) / 0.95, 2.0));
            float w1 = exp(-pow((x + 0.5) / 0.95, 2.0));
            float w2 = exp(-pow((x - 0.5) / 0.95, 2.0));
            float w3 = exp(-pow((x - 1.5) / 0.95, 2.0));
            float ws = w0 + w1 + w2 + w3 + 1e-4;
            float3 ring = (u.c0.rgb * w0 + u.c1.rgb * w1 + u.c2.rgb * w2 + u.c3.rgb * w3) / ws;

            float alpha = strength * exp(-0.85 * pow(x / 2.0, 2.0)) * 0.42 * (1.0 - 0.35 * u.reduce);

            float z = x * 0.75;
            float push = u.push * 2.33 * z * exp(-z * z) * strength * (1.0 - 0.9 * u.reduce);
            float2 dir = d > 0.5 ? normalize(p) : float2(0.0);

            float edge = min(min(px.x, u.res.x - px.x), min(px.y, u.res.y - px.y));
            float lensGain = smoothstep(0.0, 56.0, edge);
            float bevel = 22.0 * pow(1.0 - clamp(edge / 60.0, 0.0, 1.0), 2.0) * strength;

            float2 offset = (dir * push * lensGain - dir * bevel) / u.res;

            float3 col;
            col.r = tex.sample(smp, uv - offset * 1.08).r;
            col.g = tex.sample(smp, uv - offset).g;
            col.b = tex.sample(smp, uv - offset * 0.92).b;

            float3 lit = 1.0 - (1.0 - col) * (1.0 - ring * alpha * 1.5);

            // 第二趟：更宽、更淡的同一层光，专门用来消掉「边」
            float alphaWide = strength * exp(-0.85 * pow(x / 2.6, 2.0)) * 0.16 * (1.0 - 0.35 * u.reduce);
            lit = 1.0 - (1.0 - lit) * (1.0 - ring * alphaWide);

            // 第 6 层：线条反光。在「弯折后」的位置取样，反光会跟着线走
            float gm = lmask.sample(smp, uv - offset).r;
            float glint = strength * exp(-1.4 * pow(x / 2.0, 2.0)) * 0.16;
            lit += mix(ring, float3(1.0), 0.2) * gm * glint;

            return float4(lit, 1.0);
        }
"""

import AppKit
import Metal
import MetalKit

/// 冲击波光环 · Metal 版（六层全开）
///
/// 与网页版同一套公式，区别是这里拿到了真实屏幕的一帧：
///   1 快照   ScreenCaptureKit 抓的一帧
///   2 透镜   push = 7 * 2.33 * z * exp(-z²)
///   3 色散   红 1.08 / 蓝 0.92
///   4 四环   高斯权重混合
///   5 边缘   56px 淡出 + 60px bevel
///   6 反光   尚未实现（需要第二张「只有线条」的快照）
final class HaloMetalView: NSView {
    private let device: MTLDevice?
    private var queue: MTLCommandQueue?
    private var pipeline: MTLRenderPipelineState?
    private var texture: MTLTexture?
    private var maskTexture: MTLTexture?
    private var startAt: CFTimeInterval = -1
    private let duration: CFTimeInterval = 1.15

    private var metalLayer: CAMetalLayer? { layer as? CAMetalLayer }

    private struct Uniforms {
        var res: SIMD2<Float> = .zero
        var center: SIMD2<Float> = .zero
        var c0: SIMD4<Float> = .zero
        var c1: SIMD4<Float> = .zero
        var c2: SIMD4<Float> = .zero
        var c3: SIMD4<Float> = .zero
        var t: Float = 0
        var startR: Float = 0
        var growth: Float = 0
        var ringW: Float = 0
        var reduce: Float = 0
        var pad0: Float = 0
        var pad1: Float = 0
        var pad2: Float = 0
        var push: Float = 9.8
    }

    /// 位移强度：由菜单里的「冲击波强度」决定
    var pushScale: Float = 9.8

    init?(frame: NSRect, frame captured: CapturedFrame) {
        device = MTLCreateSystemDefaultDevice()
        guard let device else { return nil }
        super.init(frame: frame)

        let l = CAMetalLayer()
        l.device = device
        l.pixelFormat = .bgra8Unorm
        l.framebufferOnly = false
        l.isOpaque = false
        l.frame = CGRect(origin: .zero, size: frame.size)
        l.contentsScale = NSScreen.main?.backingScaleFactor ?? 2
        self.layer = l
        self.wantsLayer = true

        queue = device.makeCommandQueue()
        buildPipeline()
        loadTexture(captured.image)
        loadMask(captured.mask)

        // 着色器编译失败就不要返回这个视图，让调用方退回色环版
        if pipeline == nil || texture == nil { return nil }
    }

    required init?(coder: NSCoder) { fatalError("unsupported") }

    override var isOpaque: Bool { false }
    override func hitTest(_ point: NSPoint) -> NSView? { nil }

    // MARK: - 着色器

    private func buildPipeline() {
        guard let device else { return }

        let source = haloShaderSource


        do {
            let library = try device.makeLibrary(source: source, options: nil)
            let desc = MTLRenderPipelineDescriptor()
            desc.vertexFunction = library.makeFunction(name: "v_main")
            desc.fragmentFunction = library.makeFunction(name: "f_main")
            desc.colorAttachments[0].pixelFormat = .bgra8Unorm
            pipeline = try device.makeRenderPipelineState(descriptor: desc)
        } catch {
            HaloOverlay.log("pipeline failed: \(error)")
            pipeline = nil
        }
    }

    private func loadMask(_ mask: LineMask.Mask?) {
        guard let device, let mask else { return }
        let desc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .r8Unorm,
                                                           width: mask.width,
                                                           height: mask.height,
                                                           mipmapped: false)
        desc.usage = .shaderRead
        guard let t = device.makeTexture(descriptor: desc) else { return }
        t.replace(region: MTLRegionMake2D(0, 0, mask.width, mask.height),
                  mipmapLevel: 0,
                  withBytes: mask.pixels,
                  bytesPerRow: mask.width)
        maskTexture = t
    }

    private func loadTexture(_ image: CGImage) {
        guard let device else { return }
        let loader = MTKTextureLoader(device: device)
        texture = try? loader.newTexture(cgImage: image, options: [
            .SRGB: false,
            .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
        ])
    }

    // MARK: - 渲染

    func start() {
        startAt = CACurrentMediaTime()
    }

    var isFinished: Bool {
        startAt > 0 && CACurrentMediaTime() - startAt >= duration
    }

    func renderFrame() {
        guard startAt > 0,
              let metalLayer,
              let drawable = metalLayer.nextDrawable(),
              let pipeline,
              let queue,
              let texture
        else { return }

        let t = Float(min(1, (CACurrentMediaTime() - startAt) / duration))
        let scale = Float(metalLayer.contentsScale)
        let w = Float(bounds.width) * scale
        let h = Float(bounds.height) * scale

        var u = Uniforms()
        u.res = SIMD2(w, h)
        let colX = Float(KeyLayout.normalizedX(for: 36) ?? 0.82)
        u.center = SIMD2(w * colX, h * 1.97)       // 起点对齐回车键的横向位置
        u.c0 = SIMD4(80 / 255, 140 / 255, 255 / 255, 1)
        u.c1 = SIMD4(160 / 255, 110 / 255, 255 / 255, 1)
        u.c2 = SIMD4(255 / 255, 110 / 255, 180 / 255, 1)
        u.c3 = SIMD4(255 / 255, 190 / 255, 140 / 255, 1)
        u.t = t
        u.startR = h * 0.97
        u.growth = h * 1.28
        u.ringW = h * 0.115
        u.reduce = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion ? 1 : 0
        u.push = pushScale

        let pass = MTLRenderPassDescriptor()
        pass.colorAttachments[0].texture = drawable.texture
        pass.colorAttachments[0].loadAction = .clear
        pass.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        pass.colorAttachments[0].storeAction = .store

        guard let cb = queue.makeCommandBuffer(),
              let enc = cb.makeRenderCommandEncoder(descriptor: pass) else { return }

        enc.setRenderPipelineState(pipeline)
        enc.setFragmentTexture(texture, index: 0)
        enc.setFragmentTexture(maskTexture, index: 1)
        enc.setFragmentBytes(&u, length: MemoryLayout<Uniforms>.stride, index: 0)
        enc.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        enc.endEncoding()
        cb.present(drawable)
        cb.commit()
    }
}
