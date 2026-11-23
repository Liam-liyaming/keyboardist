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

    private var recentKeys: [Double] = []
    private var lastKeyAt: Double = 0

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

        meter.onText = { [weak self] added, removed in
            self?.handleText(added: added, removed: removed)
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
        store.mutate { r in
            r.keystrokes += 1
            if r.firstAt == nil { r.firstAt = date }
            r.lastAt = date
            r.minuteKeys[minute, default: 0] += 1
            r.keyCodes[String(code), default: 0] += 1
        }

        onKey?(code, speed)
        scheduleSave()
    }

    // MARK: - 字数

    private func handleText(added: Int, removed: Int) {
        guard !isPaused, added > 0 || removed > 0 else { return }
        if added > 0 { sessionChars += added }
        store.mutate { r in
            r.chars += added
            r.deletions += removed
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

    static func minuteKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}
