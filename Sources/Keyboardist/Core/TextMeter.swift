import Foundation
import AppKit
import ApplicationServices

/// 采集层 · 第二把钥匙：精准字数。
///
/// 隐私红线：只读「字符数」这一个整数。
///   * 优先 kAXNumberOfCharacters（系统直接给计数）
///   * 兜底 CFStringGetLength（只问长度，不取字符）
///   * 代码中不得出现 CFStringGetCharacters / CFStringGetCString / String(cfString)
///
/// 中文难点：拼音组合期间输入框里是 `xianzai`，上屏后变成「现在」，
/// 长度会突然变短。因此：
///   * 检测组合态（选区长 > 0）时不采样
///   * 上屏后从「组合前基线」一次性结算
final class TextMeter {
    /// (新增字数, 删除字数, 焦点应用 pid)
    var onText: ((Int, Int, pid_t) -> Void)?
    /// 最近是否有按键（排除终端滚屏、程序自己改文本这类非输入增长）
    var hadRecentKey: (() -> Bool)?
    /// 新打出来的那段文字（只在这段增长时回调）
    var onTextAppended: ((String, Int32) -> Void)?

    private var timer: Timer?
    private var baseline: Int = -1
    private var baselineElement: AXUIElement?
    private var lastValue: String?
    private var lastValueElement: AXUIElement?
    private var wasComposing = false
    private var kicked: Set<pid_t> = []

    private(set) var lastHitRate: Double = 0
    /// 最近一次采样时是否处于输入法组合态（用于回车判定）
    private(set) var lastComposing: Bool = false
    /// 上次采样到组合态的是哪个 App（避免切换 App 后用到旧状态）
    private(set) var lastComposingApp: String?
    private var reads = 0
    private var hits = 0

    func start() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.sample()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func resetBaseline() {
        baseline = -1
        baselineElement = nil
    }

    // MARK: - 采样

    private func sample() {
        guard !KeyCapture.isSecureInputEnabled() else { return }

        let system = AXUIElementCreateSystemWide()
        AXUIElementSetMessagingTimeout(system, 0.08)

        var focusedRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(system, kAXFocusedUIElementAttribute as CFString, &focusedRef) == .success,
              let focusedRef,
              CFGetTypeID(focusedRef) == AXUIElementGetTypeID()
        else { return }

        let element = focusedRef as! AXUIElement
        var pid: pid_t = 0
        AXUIElementGetPid(element, &pid)

        // Chromium 系默认不建可访问性树，需要显式唤醒
        var length = readLength(element)
        if length == nil, !kicked.contains(pid) {
            enableAccessibilityTree(pid: pid)
            return
        }
        guard let len = length else { return }
        length = nil

        reads += 1
        hits += 1
        lastHitRate = Double(hits) / Double(max(reads, 1))

        let composing = isComposing(element)
        lastComposing = composing
        lastComposingApp = ActiveWindow.frontmostApp()?.name
        if composing {
            wasComposing = true
            return                      // 组合期间不动基线，等上屏
        }
        if wasComposing {
            wasComposing = false
            // 上屏完成，用组合前的基线结算
        }

        let sameElement: Bool
        if let previous = baselineElement {
            sameElement = CFEqual(previous, element)
        } else {
            sameElement = false
        }

        if !sameElement || baseline < 0 {
            baselineElement = element
            baseline = len
            return
        }

        let delta = len - baseline

        // 一次采样最多 0.35 秒，人类不可能打出 200 个字符。
        // 超过这个量级的跳变一定是「换了控件 / 加载了文档」，不是输入。
        if abs(delta) > 200 {
            baseline = len
            return
        }

        if delta > 0 {
            // 没有按键却变长了：终端输出、程序自己改内容、粘贴，都不算打字
            guard hadRecentKey?() ?? true else {
                baseline = len
                return
            }
            onText?(delta, 0, pid)

            // 顺手把「新增的那段文字」截出来，交给加密日记
            if let value = readString(element), value.count <= 100_000 {
                let sameValueElement = lastValueElement.map { CFEqual($0, element) } ?? false
                let previous = sameValueElement ? (lastValue ?? "") : ""
                lastValue = value
                lastValueElement = element
                if let appended = Self.appendedText(from: previous, to: value) {
                    onTextAppended?(appended, pid)
                }
            }

            baseline = len
        } else if delta < 0 {
            if len == 0 {
                // 输入框被清空 / 焦点换到空控件，不是用户删了这么多
                baseline = len
            } else {
                onText?(0, -delta, pid)
                baseline = len
            }
        }
    }

    /// 回车时的一次性判定：此刻是不是在「文本控件里」、以及「是否组合中」。
    /// 只查一次 AX，避免回车链路上两次往返。
    func enterContext() -> (composing: Bool, textFocused: Bool, hasFocus: Bool) {
        guard !KeyCapture.isSecureInputEnabled() else { return (true, false, true) }

        guard let element = focusedElement() else { return (false, false, false) }

        var roleRef: CFTypeRef?
        var role = ""
        if AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &roleRef) == .success,
           let roleRef, let value = roleRef as? String {
            role = value
        }

        return (isComposing(element), isTextTarget(element, role), true)
    }

    /// 焦点元素。先走系统级查询，失败再问前端 App 自己。
    /// 微信这类 App 不响应系统级 AXFocusedUIElement，但 App 级查询能拿到。
    private func focusedElement() -> AXUIElement? {
        let system = AXUIElementCreateSystemWide()
        AXUIElementSetMessagingTimeout(system, 0.03)
        var ref: CFTypeRef?
        if AXUIElementCopyAttributeValue(system, kAXFocusedUIElementAttribute as CFString, &ref) == .success,
           let ref, CFGetTypeID(ref) == AXUIElementGetTypeID() {
            return (ref as! AXUIElement)
        }

        guard let app = NSWorkspace.shared.frontmostApplication else { return nil }
        let appElement = AXUIElementCreateApplication(app.processIdentifier)
        AXUIElementSetMessagingTimeout(appElement, 0.03)
        var appRef: CFTypeRef?
        if AXUIElementCopyAttributeValue(appElement, kAXFocusedUIElementAttribute as CFString, &appRef) == .success,
           let appRef, CFGetTypeID(appRef) == AXUIElementGetTypeID() {
            return (appRef as! AXUIElement)
        }
        return nil
    }

    /// 新值相对旧值多出来的那段（公共前缀之后的部分）。
    /// 只用于增量记录；如果旧值不是新值的前缀（比如整段被替换），返回 nil。
    static func appendedText(from old: String, to new: String) -> String? {
        guard !old.isEmpty else { return new }
        guard new.count > old.count else { return nil }
        guard new.hasPrefix(old) else { return nil }
        return String(new.dropFirst(old.count))
    }

    /// 读控件的完整文本（只用于增量日记，长度有上限）
    private func readString(_ element: AXUIElement) -> String? {
        var ref: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &ref) == .success,
              let ref, let value = ref as? String else { return nil }
        return value
    }

    /// 是不是「可以打字的控件」。多重判定：角色白名单 → 可编辑属性 → 角色名含 Text。
    /// 光靠角色白名单会漏（微信的输入框就不在白名单里）。
    private func isTextTarget(_ element: AXUIElement, _ role: String) -> Bool {
        let textRoles: Set<String> = ["AXTextField", "AXTextArea", "AXComboBox", "AXSearchField"]
        if textRoles.contains(role) { return true }
        if role.contains("Text") { return true }

        var editableRef: CFTypeRef?
        if AXUIElementCopyAttributeValue(element, "AXEditable" as CFString, &editableRef) == .success,
           let editableRef, let editable = editableRef as? Bool, editable {
            return true
        }
        return false
    }

    /// 诊断用：当前焦点元素的角色名
    func focusedRole() -> String {
        guard let element = focusedElement() else { return "none" }
        var roleRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &roleRef) == .success,
              let roleRef, let role = roleRef as? String else { return "unknown" }
        return role
    }

    /// 探针结果：必须区分「不是文本控件」和「查询失败」——
    /// 前者代表用户离开了输入框（= 提交），后者只是我们没读到（= 未知）。
    enum LengthProbe {
        case length(Int)
        case notTextTarget
        case failed
    }

    /// 只取长度，不取内容。
    func probeLength() -> LengthProbe {
        guard !KeyCapture.isSecureInputEnabled() else { return .notTextTarget }

        guard let element = focusedElement() else { return .notTextTarget }

        var roleRef: CFTypeRef?
        var role = ""
        if AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &roleRef) == .success,
           let roleRef, let value = roleRef as? String { role = value }
        let textRoles: Set<String> = ["AXTextField", "AXTextArea", "AXComboBox", "AXSearchField"]
        guard textRoles.contains(role) else { return .notTextTarget }

        guard let length = readLength(element) else { return .failed }
        return .length(length)
    }

    /// 此刻焦点控件是否处于输入法组合态（回车此时是「上屏」，不是「提交」）
    func isComposingNow() -> Bool {
        guard !KeyCapture.isSecureInputEnabled() else { return true }

        let system = AXUIElementCreateSystemWide()
        AXUIElementSetMessagingTimeout(system, 0.03)

        var focusedRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(system, kAXFocusedUIElementAttribute as CFString, &focusedRef) == .success,
              let focusedRef,
              CFGetTypeID(focusedRef) == AXUIElementGetTypeID()
        else { return false }

        return isComposing(focusedRef as! AXUIElement)
    }

    // MARK: - AX 读取（只取整数）

    private func readLength(_ element: AXUIElement) -> Int? {
        var countRef: CFTypeRef?
        if AXUIElementCopyAttributeValue(element, kAXNumberOfCharactersAttribute as CFString, &countRef) == .success,
           let number = countRef as? NSNumber {
            return number.intValue
        }

        var valueRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueRef) == .success,
              let valueRef else { return nil }

        let typeID = CFGetTypeID(valueRef)
        if typeID == CFStringGetTypeID() {
            return CFStringGetLength(valueRef as! CFString)
        }
        if typeID == CFAttributedStringGetTypeID() {
            return CFAttributedStringGetLength(valueRef as! CFAttributedString)
        }
        return nil
    }

    /// 组合态判定：选区长 > 0（拼音候选串通常处于选中状态）
    private func isComposing(_ element: AXUIElement) -> Bool {
        var rangeRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXSelectedTextRangeAttribute as CFString, &rangeRef) == .success,
              let rangeRef,
              CFGetTypeID(rangeRef) == AXValueGetTypeID()
        else { return false }

        var range = CFRange()
        guard AXValueGetValue(rangeRef as! AXValue, .cfRange, &range) else { return false }
        return range.length > 0
    }

    private func enableAccessibilityTree(pid: pid_t) {
        let appElement = AXUIElementCreateApplication(pid)
        AXUIElementSetMessagingTimeout(appElement, 0.1)
        AXUIElementSetAttributeValue(appElement, "AXManualAccessibility" as CFString, kCFBooleanTrue)
        AXUIElementSetAttributeValue(appElement, "AXEnhancedUserInterface" as CFString, kCFBooleanTrue)
        kicked.insert(pid)
    }
}
