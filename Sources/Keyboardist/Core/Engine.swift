import Foundation

/// 把采集、计数、存储串起来的中枢。
final class Engine {
    let store = Store()
    private let capture = KeyCapture()
    private let meter = TextMeter()

    /// 每敲一下：键码 + 速度(0...1)，供辉光使用
    var onKey: ((Int64, Double) -> Void)?
    /// 数据变化，供菜单栏刷新
    var onChange: (() -> Void)?

    /// 回车（keyCode 36）：交给冲击波
    var onEnter: (() -> Void)?

    private var recentKeys: [Double] = []
    private var lastKeyAt: Double = 0
    private var lastLetterAt: CFTimeInterval = 0
    /// 上一个键，用来判断回车是不是紧跟在字母后面
    private var lastKeyCode: Int64 = -1

    private var sessionStart: Date?
    private var lastKeyDate: Date?
    private var sessionKeys = 0
    private var sessionChars = 0

    private var saveWork: DispatchWorkItem?
    private var tickTimer: Timer?

    private(set) var peakCPM = 0

    var isPaused = false {
        didSet {
            meter.resetBaseline()
            onChange?()
        }
    }

    var record: DayRecord { store.record }
    var hasPermissions: Bool { KeyCapture.hasAccessibility() }
    var tapActive: Bool { capture.isRunning }
    var meterHitRate: Double { meter.lastHitRate }
    var recentCPM: Int { Int(Double(recentKeys.count) / 10.0 * 60.0) }

    /// 中文场景下击键 → 字数的经验折算，仅用于展示
    var estimatedChars: Int {
        max(record.chars, Int(Double(record.keystrokes) / 1.8))
    }

    // MARK: - 生命周期

    func start() {
        store.rolloverIfNeeded()

        capture.onKey = { [weak self] code in self?.handleKey(code) }
        capture.start()

        meter.onText = { [weak self] added, removed, pid in
            self?.handleText(added: added, removed: removed, pid: pid)
        }
        meter.start()

        tickTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func stop() {
        tickTimer?.invalidate()
        tickTimer = nil
        capture.stop()
        meter.stop()
        commitSession(end: lastKeyDate)
        store.save()
    }

    func requestPermissions() {
        capture.requestAccessibility()
    }

    // MARK: - 击键

    private func handleKey(_ code: Int64) {
        guard !isPaused else { return }

        store.rolloverIfNeeded()

        let now = CFAbsoluteTimeGetCurrent()
        let previousKeyCode = lastKeyCode
        lastKeyCode = code
        if Engine.letterKeyCodes.contains(code) { lastLetterAt = now }
        let interval = lastKeyAt > 0 ? now - lastKeyAt : 0.5
        lastKeyAt = now

        // 速度归一化：50ms 以内极快，500ms 以上算慢
        let speed = max(0, min(1, 1.0 - interval / 0.5))

        recentKeys.append(now)
        recentKeys.removeAll { now - $0 > 10 }

        let date = Date()
        if let last = lastKeyDate, date.timeIntervalSince(last) > 3.0 {
            commitSession(end: last)
        }
        if sessionStart == nil {
            sessionStart = date
            sessionKeys = 0
            sessionChars = 0
        }
        lastKeyDate = date
        sessionKeys += 1

        let minute = Engine.minuteKey(date)
        let app = ActiveWindow.frontmostApp()
        store.mutate { r in
            r.keystrokes += 1
            if r.firstAt == nil { r.firstAt = date }
            r.lastAt = date
            r.minuteKeys[minute, default: 0] += 1
            r.keyCodes[String(code), default: 0] += 1
            if let app {
                var stat = r.apps[app.id] ?? AppStat(name: app.name)
                stat.name = app.name
                stat.keystrokes += 1
                r.apps[app.id] = stat
            }
        }

        onKey?(code, speed)
        scheduleSave()

        // 回车 = 提交。但如果此刻输入法正在组合（比如中文输入法里打英文、按回车确认原文），
        // 这个回车是「上屏」，不是「提交」。
        //
        // 必须**同步**判断：异步查的时候按键已经被应用处理完，组合态已经结束了。
        if code == 36 {
            let appName = ActiveWindow.frontmostApp()?.name ?? "?"
            let tag = "app=\(appName) prevKey=\(previousKeyCode)"
            let context = meter.enterContext()
            let composing = context.composing || meter.lastComposing

            if composing {
                HaloOverlay.log("enter skipped: composing  \(tag)")
            } else if !context.textFocused {
                HaloOverlay.log("enter skipped: no text field  \(tag)")
            } else {
                // 不靠时序猜，每次回车都验证「有没有真的提交」：
                //   输入框变少 / 焦点离开 → 提交，放光环
                //   文本没变 或 变长       → 插入（输入法上屏、换行）→ 跳过
                //
                // 早先版本用「回车前 1.5 秒内有没有打字母」来决定要不要验证，
                // 结果同样是敲英文，打得快就跳过、停顿一下就直接放行——按时间分叉是错的。
                // 只有「回车前一个键是字母」才存在输入法确认英文的歧义，才需要等。
                // 打完空格/标点/退格再回车，一定是提交，立刻放。
                let mayBeComposing = Engine.letterKeyCodes.contains(previousKeyCode)

                if !mayBeComposing {
                    HaloOverlay.log("enter immediate (prev key not a letter)  \(tag)")
                    DispatchQueue.main.async { [weak self] in self?.onEnter?() }
                    return
                }

                let before = meter.probeLength()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) { [weak self] in
                    guard let self else { return }
                    let after = self.meter.probeLength()
                    let beforeText = Engine.describe(before)
                    let afterText = Engine.describe(after)

                    switch after {
                    case .notTextTarget:
                        HaloOverlay.log("enter verified: left the field (before=\(beforeText))  \(tag)")
                        self.onEnter?()
                    case .length(let now):
                        if case .length(let was) = before, now < was {
                            HaloOverlay.log("enter verified: cleared \(beforeText) → \(afterText)  \(tag)")
                            self.onEnter?()
                        } else {
                            HaloOverlay.log("enter skipped: text kept or grew \(beforeText) → \(afterText)  \(tag)")
                        }
                    case .failed:
                        // 读不到不等于没提交，宁可少放一次也不误放
                        HaloOverlay.log("enter skipped: probe failed (before=\(beforeText))  \(tag)")
                    }
                }
            }
        }
    }

    // MARK: - 字数

    private func handleText(added: Int, removed: Int, pid: Int32) {
        guard !isPaused, added > 0 || removed > 0 else { return }
        if added > 0 { sessionChars += added }
        store.mutate { r in
            r.chars += added
            r.deletions += removed
            if let app = ActiveWindow.appIdentity(for: pid) {
                var stat = r.apps[app.id] ?? AppStat(name: app.name)
                stat.name = app.name
                stat.chars += added
                stat.deletions += removed
                r.apps[app.id] = stat
            }
        }
        scheduleSave()
    }

    // MARK: - 会话

    private func commitSession(end: Date?) {
        guard let start = sessionStart, sessionKeys > 0 else {
            sessionStart = nil
            lastKeyDate = nil
            sessionKeys = 0
            sessionChars = 0
            return
        }
        let endDate = max(end ?? start, start)
        let session = Session(start: start, end: endDate, keystrokes: sessionKeys, chars: sessionChars)
        store.mutate { $0.sessions.append(session) }
        sessionStart = nil
        lastKeyDate = nil
        sessionKeys = 0
        sessionChars = 0
        scheduleSave()
    }

    // MARK: - 周期任务

    private func tick() {
        let now = CFAbsoluteTimeGetCurrent()
        recentKeys.removeAll { now - $0 > 10 }
        peakCPM = max(peakCPM, recentCPM)

        if let last = lastKeyDate, Date().timeIntervalSince(last) > 3.0 {
            commitSession(end: last)
        }
        onChange?()
    }

    // MARK: - 持久化

    private func scheduleSave() {
        saveWork?.cancel()
        let work = DispatchWorkItem { [weak self] in self?.store.save() }
        saveWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: work)
    }

    // MARK: - 工具

    /// 日志用：把探针结果变成短字符串（只有长度，没有内容）
    static func describe(_ probe: TextMeter.LengthProbe) -> String {
        switch probe {
        case .length(let n): return "len=\(n)"
        case .notTextTarget: return "no-text"
        case .failed: return "failed"
        }
    }

    /// 字母键位（a–z），用来判断「回车前是不是刚打完一串字母」
    static let letterKeyCodes: Set<Int64> = [
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17,
        31, 32, 34, 35, 37, 38, 39, 40, 41, 45, 46,
    ]

    static func minuteKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}
