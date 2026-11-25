import AppKit

/// 「查看今日输入」窗口：把加密日记解密后显示给你自己看。
/// 只读，没有导出按钮（导出统一放在菜单里，避免误操作）。
final class JournalViewer {
    private var window: NSWindow?
    private var textView: NSTextView?

    func show() {
        let day = TextJournal.dayKey(Date())
        let entries = TextJournal.entries(for: day)

        let w: NSWindow
        if let existing = window {
            w = existing
        } else {
            w = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 640, height: 520),
                         styleMask: [.titled, .closable, .resizable],
                         backing: .buffered, defer: false)
            w.title = "今日输入"
            w.isReleasedWhenClosed = false
            w.center()

            let scroll = NSScrollView(frame: w.contentView?.bounds ?? .zero)
            scroll.autoresizingMask = [.width, .height]
            scroll.hasVerticalScroller = true

            let tv = NSTextView(frame: scroll.bounds)
            tv.isEditable = false
            tv.isRichText = false
            tv.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
            tv.textContainerInset = NSSize(width: 12, height: 12)
            scroll.documentView = tv
            w.contentView = scroll
            textView = tv
            window = w
        }

        w.title = "今日输入 · \(day) · \(entries.count) 段"

        if entries.isEmpty {
            textView?.string = "今天还没有记录。\n\n（在任意输入框里打几个字，再回来看看）"
        } else {
            let f = DateFormatter()
            f.dateFormat = "HH:mm:ss"
            let body = entries
                .map { "\(f.string(from: $0.t))  \($0.app)\n\($0.text)\n" }
                .joined(separator: "\n")
            textView?.string = body
        }

        w.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func close() {
        window?.close()
        window = nil
        textView = nil
    }
}
