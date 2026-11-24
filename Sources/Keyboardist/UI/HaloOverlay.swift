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
    private var view: HaloView?
    private var timer: Timer?

    private var startAt: CFTimeInterval = -1
    private var lastEnd: CFTimeInterval = -1

    private let duration: CFTimeInterval = 1.15
    private let cooldown: CFTimeInterval = 0.15
    private let easeK: Double = 6.0          // 9 = 规格原值，App 里略缓

    /// 只在动画期间显示窗口，跑完立刻隐藏，避免常驻耗电
    func trigger() {
        let now = CACurrentMediaTime()
        guard now > lastEnd + cooldown else { return }

        startAt = now
        lastEnd = now + duration

        ensureWindow()
        window?.orderFrontRegardless()
        startTimer()
    }

    // MARK: - 窗口

    private func ensureWindow() {
        guard window == nil else { return }
        guard let screen = ActiveWindow.glowTarget(height: 0)?.screen ?? NSScreen.main else { return }

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

        let v = HaloView(frame: NSRect(origin: .zero, size: frame.size))
        w.contentView = v

        window = w
        view = v
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
        let now = CACurrentMediaTime()
        let t = (now - startAt) / duration

        if t >= 1 {
            timer?.invalidate()
            timer = nil
            view?.progress = 1
            view?.needsDisplay = true
            window?.orderOut(nil)
            return
        }
        view?.easeK = easeK
        view?.progress = t
        view?.needsDisplay = true
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
