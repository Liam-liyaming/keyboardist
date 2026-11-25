import Foundation
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

    private var timer: Timer?
    private var baseline: Int = -1
    private var baselineElement: AXUIElement?
    private var wasComposing = false
    private var kicked: Set<pid_t> = []

    private(set) var lastHitRate: Double = 0
    /// 最近一次采样时是否处于输入法组合态（用于回车判定）
    private(set) var lastComposing: Bool = false
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
        if delta > 0 {
            onText?(delta, 0, pid)
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
    func enterContext() -> (composing: Bool, textFocused: Bool) {
        guard !KeyCapture.isSecureInputEnabled() else { return (true, false) }

        let system = AXUIElementCreateSystemWide()
        AXUIElementSetMessagingTimeout(system, 0.03)

        var focusedRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(system, kAXFocusedUIElementAttribute as CFString, &focusedRef) == .success,
              let focusedRef,
              CFGetTypeID(focusedRef) == AXUIElementGetTypeID()
        else { return (false, false) }

        let element = focusedRef as! AXUIElement

        var roleRef: CFTypeRef?
        var role = ""
        if AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &roleRef) == .success,
           let roleRef, let value = roleRef as? String {
            role = value
        }

        return (isComposing(element), isTextTarget(element, role))
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
        let system = AXUIElementCreateSystemWide()
        AXUIElementSetMessagingTimeout(system, 0.03)
        var focusedRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(system, kAXFocusedUIElementAttribute as CFString, &focusedRef) == .success,
              let focusedRef, CFGetTypeID(focusedRef) == AXUIElementGetTypeID() else { return "none" }
        var roleRef: CFTypeRef?
        guard AXUIElementCopyAttributeValue(focusedRef as! AXUIElement, kAXRoleAttribute as CFString, &roleRef) == .success,
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

        let system = AXUIElementCreateSystemWide()
        AXUIElementSetMessagingTimeout(system, 0.03)

        var focusedRef: CFTypeRef?
        let status = AXUIElementCopyAttributeValue(system, kAXFocusedUIElementAttribute as CFString, &focusedRef)
        guard status == .success,
              let focusedRef,
              CFGetTypeID(focusedRef) == AXUIElementGetTypeID()
        else { return .notTextTarget }

        let element = focusedRef as! AXUIElement

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
