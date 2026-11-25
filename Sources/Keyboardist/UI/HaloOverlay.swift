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
/// 无边框窗口默认会被 AppKit 约束在主屏可见区域内。
/// 冲击波要盖在外接屏/笔记本屏的完整区域上（坐标可能是负的），必须取消这个约束。
final class HaloWindow: NSWindow {
    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        frameRect
    }
}

final class HaloOverlay {
    private var window: NSWindow?
    private var ringView: HaloView?
    private var metalView: HaloMetalView?
    private var timer: Timer?

    private var isRunning = false
    private var pendingCapture: Task<CapturedFrame?, Never>?
    private var pendingScreen: NSScreen?
    private var pendingAt: CFTimeInterval = 0
    private var fallbackStart: CFTimeInterval = -1

    /// 每次触发的诊断日志：写 ~/Library/Application Support/Keyboardist/halo.log
    static func log(_ text: String) {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Keyboardist", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent("halo.log")
        let line = "\(Date().formatted(date: .omitted, time: .standard))  \(text)\n"
        if let data = line.data(using: .utf8) {
            if let handle = try? FileHandle(forWritingTo: url) {
                handle.seekToEndOfFile()
                handle.write(data)
                try? handle.close()
            } else {
                try? data.write(to: url)
            }
        }
    }

    private let duration: CFTimeInterval = 1.15
    private let cooldown: CFTimeInterval = 0.15
    private let easeK: Double = 6.0

    /// 三档预设：位移、亮度、时长一起变，才看得出区别
    struct Preset {
        let key: String
        let push: Float        // 位移倍数
        let alpha: Float       // 亮度倍数
        let duration: CFTimeInterval
    }

    static let presets: [Preset] = [
        Preset(key: "light",  push: 0.55, alpha: 0.88, duration: 1.00),
        Preset(key: "medium", push: 1.00, alpha: 1.00, duration: 1.15),
        Preset(key: "heavy",  push: 1.70, alpha: 1.14, duration: 1.35),
    ]

    static var preset: Preset {
        get {
            let key = UserDefaults.standard.string(forKey: "haloPreset") ?? "medium"
            return presets.first { $0.key == key } ?? presets[1]
        }
        set { UserDefaults.standard.set(newValue.key, forKey: "haloPreset") }
    }

    /// 按下回车时调用：先抓一帧，再用 Metal 把六层画出来。
    /// 抓帧失败（没有屏幕录制权限）就退回只有色环的降级版。
    /// 回车按下的瞬间就开抓，和「判是不是真提交」并行，
    /// 这样截帧的 50~160ms 被判定窗口盖住，不用叠加。
    func prepare() {
        guard !isRunning else { return }
        let target = ActiveWindow.caretScreen()
        pendingScreen = target.screen
        pendingAt = CACurrentMediaTime()
        pendingCapture = Task { await ScreenShot.capture(screen: target.screen) }
    }

    /// 判定为「真的提交」后调用：用已经抓好（或正在抓）的那一帧出光。
    func commit() {
        guard !isRunning, let screen = pendingScreen, let task = pendingCapture else { return }
        isRunning = true
        pendingCapture = nil

        Task {
            let frame = await task.value
            await MainActor.run {
                self.present(screen: screen, frame: frame)
            }
        }
    }

    func trigger() {
        // 只挡「动画真的还在跑」这一种情况。
        // 早先用「上次结束 + 0.4 + 冷却」做闸门，等于每次触发后约 1.7 秒内的回车全被吞掉，
        // 聊天里连发两条就是必现。
        guard !isRunning else {
            HaloOverlay.log("trigger skipped: still running")
            return
        }
        let target = ActiveWindow.caretScreen()
        let screen = target.screen

        isRunning = true
        HaloOverlay.log("trigger  screen=\(screen.localizedName) via=\(target.source)  screen-rec=\(ScreenShot.hasPermission())")

        Task {
            let image = await ScreenShot.capture(screen: screen)
            await MainActor.run {
                self.present(screen: screen, frame: image)
            }
        }
    }

    private func present(screen: NSScreen, frame captured: CapturedFrame?) {
        // 窗口和 Metal 视图常驻复用：每次只换纹理，省掉建窗口/建设备的几十毫秒
        if let existing = window, let mv = metalView, existing.frame == screen.frame, let captured {
            window?.orderFrontRegardless()
            mv.update(with: captured)
            let p = HaloOverlay.preset
            mv.pushScale = p.push * 11
            mv.alphaScale = p.alpha
            mv.duration = p.duration
            mv.restart()
            startTimer()
            HaloOverlay.log(String(format: "latency %.0f ms (回车→出光, 复用窗口)", (CACurrentMediaTime() - pendingAt) * 1000))
            return
        }

        teardown(release: true)

        let frame = screen.frame
        let w = HaloWindow(contentRect: frame,
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

        HaloOverlay.log("captured=\(captured != nil)  size=\(captured.map { "\($0.image.width)x\($0.image.height)" } ?? "-")  mask=\(captured?.mask != nil)")

        if let captured, let mv = HaloMetalView(frame: NSRect(origin: .zero, size: frame.size), frame: captured) {
            HaloOverlay.log("metal path")
            let p = HaloOverlay.preset
            mv.pushScale = p.push * 11
            mv.alphaScale = p.alpha
            mv.duration = p.duration
            mv.start()
            w.contentView = mv
            metalView = mv
        } else {
            HaloOverlay.log("fallback: rings only")
            let v = HaloView(frame: NSRect(origin: .zero, size: frame.size))
            v.easeK = easeK
            fallbackStart = CACurrentMediaTime()
            v.progress = 0
            w.contentView = v
            ringView = v
        }

        w.setFrame(frame, display: true)
        window = w
        w.orderFrontRegardless()
        HaloOverlay.log(String(format: "latency %.0f ms (回车→出光)", (CACurrentMediaTime() - pendingAt) * 1000))
        HaloOverlay.log("window frame=\(Int(w.frame.minX)),\(Int(w.frame.minY)) \(Int(w.frame.width))x\(Int(w.frame.height))  want=\(Int(frame.minX)),\(Int(frame.minY)) \(Int(frame.width))x\(Int(frame.height))")
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
            if mv.isFinished { teardown(release: false) }
            return
        }
        if let rv = ringView {
            let progress = min(1, max(0, (CACurrentMediaTime() - fallbackStart) / duration))
            rv.progress = progress
            rv.needsDisplay = true
            if progress >= 1 { teardown(release: false) }
        }
    }

    private func teardown(release: Bool = false) {
        timer?.invalidate()
        timer = nil
        window?.orderOut(nil)
        if release {
            window = nil
            ringView = nil
            metalView = nil
        }
        isRunning = false
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
                let w = exp(-pow((x - c) / 0.95, 2))
                r += palette[k].0 * w
                g += palette[k].1 * w
                b += palette[k].2 * w
                sum += w
            }
            sum = max(sum, 1e-5)
            var alpha = strength * exp(-0.85 * pow(x / 2, 2)) * 0.46
            if i == 0 || i == stops { alpha = 0 }   // 两端归零，否则整屏泛色
            colors.append(CGColor(red: r / sum / 255, green: g / sum / 255, blue: b / sum / 255, alpha: alpha))
            locations.append(CGFloat(i) / CGFloat(stops))
        }

        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: locations) else { return }

        // 圆心在屏幕下方约一个屏高处，所以看到的是一道从底边升起的弧
        let colX = CGFloat(KeyLayout.normalizedX(for: 36) ?? 0.82)
        let center = CGPoint(x: bounds.width * colX, y: -H * 0.97)
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
