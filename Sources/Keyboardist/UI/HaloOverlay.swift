import AppKit

/// 回车冲击波 · App 版
///
/// 与网页版的差别：这里拿不到别的 App 的像素，所以只做「发光」部分——
/// 四色环（第 4 层）。透镜、色散、边缘折射需要底层内容，在系统级覆盖层上做不到，
/// 除非申请屏幕录制权限，而那会破坏「只申请辅助功能」的承诺。
///
/// 色环公式来自 RedSkill《冲击波光环》第 013 期：
///   x = (dist - R) / ringWidth
///   第 i 环中心 i-1.5，高斯权重 exp(-((x-c)/0.8)^2)
///   alpha = strength * exp(-1.1 * (x/2)^2)
///   R = startR + growth * (1 - 2^(-k t)) / (1 - 2^(-k))
final class HaloOverlay {
    private var window: NSWindow?
    private var ringView: HaloView?
    private var metalView: HaloMetalView?
    private var timer: Timer?

    private var lastEnd: CFTimeInterval = -1

    private let duration: CFTimeInterval = 1.15
    private let cooldown: CFTimeInterval = 0.15
    private let easeK: Double = 6.0

    /// 按下回车时调用：先抓一帧，再用 Metal 把六层画出来。
    /// 抓帧失败（没有屏幕录制权限）就退回只有色环的降级版。
    func trigger() {
        let now = CACurrentMediaTime()
        guard now > lastEnd + cooldown else { return }
        guard let screen = ActiveWindow.glowTarget(height: 0)?.screen ?? NSScreen.main else { return }

        // 抓帧本身要几十毫秒，把闸门的结束时间往后推
        lastEnd = now + duration + 0.4

        Task {
            let image = await ScreenShot.capture(screen: screen)
            await MainActor.run {
                self.present(screen: screen, image: image)
            }
        }
    }

    private func present(screen: NSScreen, image: CGImage?) {
        teardown()

        let frame = screen.frame
        let w = NSWindow(contentRect: frame,
                         styleMask: [.borderless],
                         backing: .buffered,
                         defer: false,
                         screen: screen)
        w.isOpaque = false
        w.backgroundColor = .clear
        w.hasShadow = false
        w.ignoresMouseEvents = true
        w.isReleasedWhenClosed = false
        w.level = .screenSaver
        w.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]

        if let image, let mv = HaloMetalView(frame: NSRect(origin: .zero, size: frame.size), image: image) {
            mv.start()
            w.contentView = mv
            metalView = mv
        } else {
            let v = HaloView(frame: NSRect(origin: .zero, size: frame.size))
            v.easeK = easeK
            v.progress = 0
            w.contentView = v
            ringView = v
        }

        window = w
        w.orderFrontRegardless()
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        let t = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.current.add(t, forMode: .common)
        timer = t
    }

    private func tick() {
        if let mv = metalView {
            mv.renderFrame()
            if mv.isFinished { teardown() }
            return
        }
        if let rv = ringView {
            let t = CACurrentMediaTime()
            // 降级版没有独立的起始时间，用闸门的结束时间倒推
            let elapsed = duration - (lastEnd - 0.4 - t)
            let progress = min(1, max(0, elapsed / duration))
            rv.progress = progress
            rv.needsDisplay = true
            if progress >= 1 { teardown() }
        }
    }

    private func teardown() {
        timer?.invalidate()
        timer = nil
        window?.orderOut(nil)
        window = nil
        ringView = nil
        metalView = nil
    }
}

/// 四色环。整屏只有一个径向渐变，每帧重算 40 个色标。
final class HaloView: NSView {
    var progress: Double = 1
    var easeK: Double = 6

    private let palette: [(Double, Double, Double)] = [
        (80, 140, 255), (160, 110, 255), (255, 110, 180), (255, 190, 140),
    ]

    override var isOpaque: Bool { false }
    override func hitTest(_ point: NSPoint) -> NSView? { nil }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        ctx.clear(bounds)

        let t = min(1, max(0, progress))
        guard t < 1 else { return }

        let H = bounds.height
        let startR = H * 0.97
        let growth = H * 1.28
        let ease = (1 - pow(2, -easeK * t)) / (1 - pow(2, -easeK))
        let R = startR + growth * ease

        let strength = min(1, t / 0.03) * (1 - pow(t, 2.2))
        guard strength > 0.002 else { return }

        let ringW = H * 0.115
        let span = 2.2
        let stops = 44

        var colors: [CGColor] = []
        var locations: [CGFloat] = []
        for i in 0...stops {
            let x = -span + 2 * span * Double(i) / Double(stops)
            var r = 0.0, g = 0.0, b = 0.0, sum = 0.0
            for k in 0..<4 {
                let c = Double(k) - 1.5
                let w = exp(-pow((x - c) / 0.8, 2))
                r += palette[k].0 * w
                g += palette[k].1 * w
                b += palette[k].2 * w
                sum += w
            }
            sum = max(sum, 1e-5)
            var alpha = strength * exp(-1.1 * pow(x / 2, 2)) * 0.5
            if i == 0 || i == stops { alpha = 0 }   // 两端归零，否则整屏泛色
            colors.append(CGColor(red: r / sum / 255, green: g / sum / 255, blue: b / sum / 255, alpha: alpha))
            locations.append(CGFloat(i) / CGFloat(stops))
        }

        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: locations) else { return }

        // 圆心在屏幕下方约一个屏高处，所以看到的是一道从底边升起的弧
        let center = CGPoint(x: bounds.midX, y: -H * 0.97)
        let inner = max(1, R - span * ringW)
        let outer = R + span * ringW

        ctx.saveGState()
        ctx.setBlendMode(.plusLighter)
        ctx.drawRadialGradient(gradient,
                               startCenter: center, startRadius: inner,
                               endCenter: center, endRadius: outer,
                               options: [])
        ctx.restoreGState()
    }
}
