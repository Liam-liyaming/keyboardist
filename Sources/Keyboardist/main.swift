import AppKit

// 导出音符事件（给可视化用：音高/位置/时间/力度）
if let flag = CommandLine.arguments.firstIndex(of: "--export-notes") {
    let store = Store()
    let outPath = flag + 1 < CommandLine.arguments.count
        ? CommandLine.arguments[flag + 1]
        : "notes.json"
    let (notes, summary) = SongComposer.compose(store.record)
    let payload: [String: Any] = [
        "day": store.record.day,
        "bpm": summary.bpm,
        "seconds": summary.seconds,
        "sessions": summary.sessions,
        "notes": notes.map { [
            "t": ($0.start * 1000).rounded() / 1000,
            "d": ($0.dur * 1000).rounded() / 1000,
            "m": $0.midi,
            "a": Double($0.amp),
            "p": Double($0.pan),
            "k": String(describing: $0.kind),
        ] as [String: Any] },
    ]
    do {
        let data = try JSONSerialization.data(withJSONObject: payload,
                                              options: [.prettyPrinted, .sortedKeys])
        try data.write(to: URL(fileURLWithPath: outPath))
        print("notes: \(outPath) (\(notes.count) events)")
        exit(0)
    } catch {
        FileHandle.standardError.write("export failed: \(error)\n".data(using: .utf8)!)
        exit(1)
    }
}

// 版本号
if CommandLine.arguments.contains("--version") {
    let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
    let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
    print("键盘手 \(v) (\(b))")
    exit(0)
}

// 自检：线条掩膜的方向是否正确（画在靠近顶部 → 掩膜里也该在靠近顶部）
if CommandLine.arguments.contains("--test-mask") {
    let w = 400, h = 200
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0,
                        space: CGColorSpaceCreateDeviceRGB(),
                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.setFillColor(CGColor(red: 0.06, green: 0.06, blue: 0.06, alpha: 1))
    ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
    ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
    ctx.fill(CGRect(x: 40, y: 180, width: 320, height: 2))   // CG 左下原点：y=180 靠上
    if let img = ctx.makeImage(), let m = LineMask.make(from: img) {
        var rows: [Int] = []
        for y in 0..<m.height where m.pixels[y * m.width + m.width / 2] > 0 { rows.append(y) }
        print("mask \(m.width)x\(m.height)  marked rows=\(rows.prefix(8))  (期望 ~10，靠近顶部)")
    }
    exit(0)
}

// 自检：单独放一次冲击波，2 秒后退出（用来验证窗口是否真的出现）
if CommandLine.arguments.contains("--test-halo") {
let app = NSApplication.shared
    app.setActivationPolicy(.accessory)
    let halo = HaloOverlay()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { halo.trigger() }
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { exit(0) }
    app.run()
}

// 无界面模式：直接渲染今日之歌（便于自动化验证）
if let flag = CommandLine.arguments.firstIndex(of: "--render-song") {
    let store = Store()
    let outPath = flag + 1 < CommandLine.arguments.count ? CommandLine.arguments[flag + 1] : nil
    let url = outPath.map { URL(fileURLWithPath: $0) } ?? SongRenderer.defaultURL(for: store.record.day)
    do {
        let summary = try SongRenderer.render(store.record, to: url)
        print("song: \(url.path)")
        print("bpm=\(summary.bpm) bars=\(summary.bars) seconds=\(summary.seconds) sessions=\(summary.sessions)")
        exit(0)
    } catch {
        FileHandle.standardError.write("render failed: \(error)\n".data(using: .utf8)!)
        exit(1)
    }
}

// 单实例：已经有同名 App 在跑就直接激活它并退出
let bundleID = Bundle.main.bundleIdentifier ?? "com.liyaming.keyboardist"
let me = ProcessInfo.processInfo.processIdentifier
if let other = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
    .first(where: { $0.processIdentifier != me }) {
    other.activate(options: [.activateIgnoringOtherApps])
    exit(0)
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
