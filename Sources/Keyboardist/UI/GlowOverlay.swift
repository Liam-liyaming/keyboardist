import AppKit
import QuartzCore

/// 呈现层：屏幕底部的辉光。
///
/// v0.3 起不再是「每块屏一个窗口」，而是**跟着你正在打字的那个窗口走**：
///   * 横向范围 = 该 App 窗口的宽度（分屏时只覆盖你打字的那一半）
///   * 所在屏幕 = 该窗口所在的屏幕（多显示器时只亮那块）
///   * 换 App / 挪窗口时平滑过渡
final class GlowOverlay {
    var isEnabled = true {
        didSet {
            if isEnabled { start() } else { stop() }
        }
    }

    /// 目标变了（换了 App 或换了屏），给菜单栏用
    var onTargetChange: ((String) -> Void)?

    private var window: NSWindow?
    private var view: GlowView?
    private var currentFrame: CGRect = .zero
    private var currentScreen: NSScreen?

    private let stripHeight: CGFloat = 220

    // MARK: - 启停

    func start() {
        ensureWindow()
        updateTarget(animated: false)
    }

    func stop() {
        window?.orderOut(nil)
        window = nil
        view = nil
        currentFrame = .zero
        currentScreen = nil
    }

    private func ensureWindow() {
        guard window == nil else { return }

        let frame = NSRect(x: 0, y: 0, width: 800, height: stripHeight)
        let glowView = GlowView(frame: NSRect(origin: .zero, size: frame.size))
        let w = NSWindow(contentRect: frame,
                         styleMask: [.borderless],
                         backing: .buffered,
                         defer: false)
        w.contentView = glowView
        w.isOpaque = false
        w.backgroundColor = .clear
        w.hasShadow = false
        w.ignoresMouseEvents = true
        w.isMovableByWindowBackground = false
        w.isReleasedWhenClosed = false
        w.level = .screenSaver
        w.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        w.ignoresMouseEvents = true

        window = w
        view = glowView
        w.orderFrontRegardless()
    }

    // MARK: - 跟随目标

    func updateTarget(animated: Bool = true) {
        guard isEnabled, let window else { return }
        guard let target = ActiveWindow.glowTarget(height: stripHeight) else { return }

        onTargetChange?(target.appName)

        let sameScreen = currentScreen?.frame == target.screen.frame
        let newFrame = target.frame
        guard newFrame != currentFrame else { return }

        currentFrame = newFrame
        currentScreen = target.screen

        // 跨屏不做动画，避免窗口在屏幕之间「飞过去」
        if animated && sameScreen {
            NSAnimationContext.runAnimationGroup { ctx in
                ctx.duration = 0.28
                ctx.timingFunction = CAMediaTimingFunction(name: .easeOut)
                window.animator().setFrame(newFrame, display: true)
            }
        } else {
            window.setFrame(newFrame, display: true)
        }
        window.orderFrontRegardless()
    }

    // MARK: - 击键

    func spark(keyCode: Int64, speed: Double) {
        guard isEnabled, let view else { return }
        view.addSpark(keyCode: keyCode, speed: speed)
    }
}

/// 单个画布：底部光带 + 击键涟漪。
final class GlowView: NSView {
    private struct Spark {
        let x: CGFloat
        let born: CFTimeInterval
        let strength: CGFloat
        let hue: CGFloat
    }

    private var sparks: [Spark] = []
    private var timer: Timer?
    private var lastActivity: CFTimeInterval = 0

    private let life: CFTimeInterval = 1.15
    private let maxSparks = 40

    override var isOpaque: Bool { false }
    override func hitTest(_ point: NSPoint) -> NSView? { nil }

    func addSpark(keyCode: Int64, speed: Double) {
        let normalized = KeyLayout.normalizedX(for: keyCode) ?? 0.5
        let clamped = max(0, min(1, speed))

        let spark = Spark(
            x: CGFloat(normalized) * bounds.width,
            born: CACurrentMediaTime(),
            strength: CGFloat(0.32 + 0.68 * clamped),
            hue: CGFloat(KeyLayout.hue(forSpeed: clamped))
        )
        sparks.append(spark)
        if sparks.count > maxSparks {
            sparks.removeFirst(sparks.count - maxSparks)
        }
        lastActivity = spark.born
        ensureTimer()
    }

    private func ensureTimer() {
        guard timer == nil else { return }
        let t = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.frameTick()
        }
        RunLoop.current.add(t, forMode: .common)
        timer = t
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func frameTick() {
        let now = CACurrentMediaTime()
        sparks.removeAll { now - $0.born > life }
        needsDisplay = true

        if sparks.isEmpty && now - lastActivity > 2.0 {
            stopTimer()
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        ctx.clear(bounds)

        let now = CACurrentMediaTime()
        let idle = now - lastActivity

        let ambient = max(0, 1 - idle / 1.6)
        if ambient > 0.005 {
            drawAmbient(ctx, intensity: CGFloat(ambient))
        }

        ctx.saveGState()
        ctx.setBlendMode(.plusLighter)

        for spark in sparks {
            let age = now - spark.born
            let progress = min(1, age / life)
            let fade = pow(1 - progress, 2.1)
            let alpha = CGFloat(fade) * spark.strength
            let radius = 70 + CGFloat(progress) * 190
            drawGlow(ctx, x: spark.x, hue: spark.hue, alpha: alpha, radius: radius)
        }

        ctx.restoreGState()
    }

    private func drawAmbient(_ ctx: CGContext, intensity: CGFloat) {
        let bottom = NSColor(hue: 0.55, saturation: 0.55, brightness: 1.0, alpha: 0.16 * intensity)
        let top = bottom.withAlphaComponent(0)
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [top.cgColor, bottom.cgColor] as CFArray,
            locations: [0, 1]
        ) else { return }

        ctx.saveGState()
        ctx.setBlendMode(.plusLighter)
        ctx.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: bounds.height * 0.24),
            end: CGPoint(x: 0, y: 0),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        )
        ctx.restoreGState()
    }

    private func drawGlow(_ ctx: CGContext, x: CGFloat, hue: CGFloat, alpha: CGFloat, radius: CGFloat) {
        let core = NSColor(hue: hue, saturation: 0.9, brightness: 1.0, alpha: alpha)
        let edge = core.withAlphaComponent(0)
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [core.cgColor, edge.cgColor] as CFArray,
            locations: [0, 1]
        ) else { return }

        ctx.drawRadialGradient(
            gradient,
            startCenter: CGPoint(x: x, y: 0),
            startRadius: 0,
            endCenter: CGPoint(x: x, y: 0),
            endRadius: radius,
            options: []
        )
    }
}
