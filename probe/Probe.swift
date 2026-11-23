//
//  KeyboardistProbe — 键盘手 M0 探针 v3
//
//  v3 变更
//    * 击键来源改用 NSEvent 全局监听（只需「辅助功能」，不需要「输入监控」）
//      CGEventTap 保留为可选第二条路，不主动请求 Input Monitoring
//    * 修正删除计数：按控件身份重置基线；长度直接归零一律判为「切控件」而非删除
//    * 增加击键间隔中位数，用来预估「今日歌曲」的 BPM
//
//  隐私约束（勿破坏）
//    * 只读「字符数」一个整数：kAXNumberOfCharacters 或 CFString 长度。
//      禁止 CFStringGetCharacters / CFStringGetCString / String(cfString)。
//    * 日志只出现整数与状态位。
//    * 不使用任何网络框架。
//

import Foundation
import AppKit
import ApplicationServices
import Carbon

// ============ 配置 ============
let cmdArgs = CommandLine.arguments
let kLogPath: String = cmdArgs.count > 1 ? cmdArgs[1] : NSTemporaryDirectory() + "keyboardist-probe.log"
let kDuration: Double = cmdArgs.count > 2 ? (Double(cmdArgs[2]) ?? 900.0) : 900.0

// ============ 日志 ============
let fm = FileManager.default
if !fm.fileExists(atPath: kLogPath) { fm.createFile(atPath: kLogPath, contents: Data()) }
let logHandle = FileHandle(forWritingAtPath: kLogPath)!
logHandle.seekToEndOfFile()
let t0 = Date()

func emit(_ text: String) {
    let stamp = String(format: "%7.2f", Date().timeIntervalSince(t0))
    guard let data = ("[\(stamp)s] " + text + "\n").data(using: .utf8) else { return }
    logHandle.write(data)
    try? logHandle.synchronize()
}

// ============ 键位分类 ============
let modifierKeyCodes: Set<Int64> = [54, 55, 56, 57, 58, 59, 60, 61, 62, 63]
let functionKeyCodes: Set<Int64> = [
    53, 71, 75, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
    96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112,
    113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126,
]

// ============ 状态 ============
final class Recorder {
    var tap: CFMachPort?
    var tapCreated = false
    var monitorInstalled = false

    var totalKeys = 0
    var textKeys = 0
    var fromNS = 0
    var fromTap = 0
    var dupSuppressed = 0
    var keyTimes: [Double] = []
    var intervals: [Double] = []
    var lastEventAt: Double = 0
    var lastEventCode: Int64 = -1
    var sessionStart: Double = 0
    var sessionKeys = 0
    var sessionCount = 0
    var longestGap: Double = 0
    var peakCpm = 0

    // AX
    var axChars = 0
    var axDeletions = 0
    var axReads = 0
    var axHits = 0
    var axViaNumber = 0
    var axSwitches = 0          // 控件切换次数（被判为切换而非删除）
    var axKicks = 0
    var lastLength = -1
    var lastElement: AXUIElement?
    var kickedPids: Set<pid_t> = []
    var diag = 0

    var tapDisabledEvents = 0
    var secureInputSeen = false
    var frontmostApp = "-"
}

var recorder = Recorder()

// ============ AX ============
func enableAccessibilityTree(pid: pid_t) {
    let appElement = AXUIElementCreateApplication(pid)
    AXUIElementSetMessagingTimeout(appElement, 0.1)
    AXUIElementSetAttributeValue(appElement, "AXManualAccessibility" as CFString, kCFBooleanTrue)
    AXUIElementSetAttributeValue(appElement, "AXEnhancedUserInterface" as CFString, kCFBooleanTrue)
    recorder.kickedPids.insert(pid)
    recorder.axKicks += 1
}

/// 只问「有多少字」。
func readCharCount(_ element: AXUIElement) -> Int? {
    var countRef: CFTypeRef?
    if AXUIElementCopyAttributeValue(element, kAXNumberOfCharactersAttribute as CFString, &countRef) == .success,
       let number = countRef as? NSNumber {
        recorder.axViaNumber += 1
        recorder.diag = 2
        return number.intValue
    }
    var valueRef: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueRef) == .success,
          let valueRef else { return nil }
    recorder.diag = 3
    let typeID = CFGetTypeID(valueRef)
    if typeID == CFStringGetTypeID() {
        return CFStringGetLength(valueRef as! CFString)
    }
    if typeID == CFAttributedStringGetTypeID() {
        return CFAttributedStringGetLength(valueRef as! CFAttributedString)
    }
    return nil
}

func sampleAX() {
    recorder.axReads += 1
    recorder.diag = 0

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

    var length = readCharCount(element)

    if length == nil && !recorder.kickedPids.contains(pid) {
        enableAccessibilityTree(pid: pid)
        recorder.diag = 4
        return                      // 下一拍再读，唤醒需要一点时间
    }

    guard let len = length else { return }
    recorder.axHits += 1

    // 控件身份变化 → 重置基线，这次差值不算任何东西
    let sameElement: Bool
    if let previous = recorder.lastElement {
        sameElement = CFEqual(previous, element)
    } else {
        sameElement = false
    }

    if !sameElement {
        recorder.lastElement = element
        recorder.lastLength = len
        if recorder.axReads > 2 { recorder.axSwitches += 1 }
        return
    }

    let previous = recorder.lastLength
    let delta = len - previous

    if delta > 0 {
        recorder.axChars += delta
    } else if delta < 0 {
        // 长度直接归零 = 焦点换到了空控件 / 输入框被清空，不是用户删了这么多字
        if len == 0 {
            recorder.axSwitches += 1
        } else {
            recorder.axDeletions += -delta
        }
    }
    recorder.lastLength = len
}

// ============ 击键记录（两条来源共用，带去重） ============
extension Recorder {
    func recordKey(code: Int64, source: String) {
        guard !modifierKeyCodes.contains(code) else { return }

        let now = CFAbsoluteTimeGetCurrent()
        let previousAt = lastEventAt
        // 同一个键在 50ms 内被两条通道各报一次 → 去重
        if code == lastEventCode, now - previousAt < 0.05 {
            dupSuppressed += 1
            return
        }
        lastEventCode = code
        lastEventAt = now

        if source == "ns" { fromNS += 1 } else { fromTap += 1 }

        totalKeys += 1
        keyTimes.append(now)
        if keyTimes.count > 20000 { keyTimes.removeFirst(5000) }

        if sessionStart == 0 || now - previousAt > 2.5 {
            if sessionKeys > 0 { sessionCount += 1 }
            sessionStart = now
            sessionKeys = 0
        }
        if previousAt > 0 { longestGap = max(longestGap, now - previousAt) }
        sessionKeys += 1

        if !functionKeyCodes.contains(code) { textKeys += 1 }

        if intervals.count < 20000, keyTimes.count >= 2 {
            let gap = now - keyTimes[keyTimes.count - 2]
            if gap > 0.01 && gap < 3.0 { intervals.append(gap) }
        }
    }
}

// ============ 来源一：NSEvent 全局监听（只需辅助功能） ============
func installNSEventMonitor() {
    let mask: NSEvent.EventTypeMask = [.keyDown]
    let token = NSEvent.addGlobalMonitorForEvents(matching: mask) { nsEvent in
        if nsEvent.isARepeat { return }
        recorder.recordKey(code: Int64(nsEvent.keyCode), source: "ns")
    }
    recorder.monitorInstalled = token != nil
    emit("NSEvent global monitor installed=\(recorder.monitorInstalled)")
}

// ============ 来源二：CGEventTap（需要输入监控，作为可选补充） ============
let keyMask = CGEventMask((1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue))

let callback: CGEventTapCallBack = { _, type, event, _ in
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        recorder.tapDisabledEvents += 1
        if let tap = recorder.tap { CGEvent.tapEnable(tap: tap, enable: true) }
        return Unmanaged.passUnretained(event)
    }
    if type == .keyDown {
        let code = event.getIntegerValueField(.keyboardEventKeycode)
        if event.getIntegerValueField(.keyboardEventAutorepeat) == 0 {
            recorder.recordKey(code: code, source: "tap")
        }
    }
    return Unmanaged.passUnretained(event)
}

func tryInstallTap() {
    guard let tap = CGEvent.tapCreate(
        tap: .cgSessionEventTap,
        place: .headInsertEventTap,
        options: .listenOnly,
        eventsOfInterest: keyMask,
        callback: callback,
        userInfo: nil
    ) else { return }
    recorder.tap = tap
    recorder.tapCreated = true
    let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
    CGEvent.tapEnable(tap: tap, enable: true)
    emit("CGEventTap created OK（第二条通道）")
}

// ============ 主流程 ============
let app = NSApplication.shared
app.setActivationPolicy(.accessory)

emit("=== 键盘手 M0 探针 v3 ===")
emit("bundle=\(Bundle.main.bundleIdentifier ?? "-") pid=\(getpid()) duration=\(Int(kDuration))s")

let axTrusted = AXIsProcessTrusted()
emit("AXIsProcessTrusted=\(axTrusted)")

if !axTrusted {
    let opts = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
    _ = AXIsProcessTrustedWithOptions(opts)
    emit("已请求「辅助功能」授权")
}

installNSEventMonitor()

// 不再主动请求输入监控；有则用，没有也不影响主链路
tryInstallTap()

Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { _ in
    recorder.secureInputSeen = recorder.secureInputSeen || IsSecureEventInputEnabled()
    if !recorder.secureInputSeen { sampleAX() }
}

Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
    recorder.frontmostApp = NSWorkspace.shared.frontmostApplication?.localizedName ?? "-"
    let now = CFAbsoluteTimeGetCurrent()
    let recent = recorder.keyTimes.filter { now - $0 <= 10.0 }.count
    let cpm10 = Int(Double(recent) / 10.0 * 60.0)
    recorder.peakCpm = max(recorder.peakCpm, cpm10)

    emit(String(
        format: "keys=%d cpm10=%d src=ns%d/tap%d chars=%d del=%d sw=%d hit=%d/%d kick=%d diag=%d secure=%d ax=%@ top=%@",
        recorder.totalKeys,
        cpm10,
        recorder.fromNS,
        recorder.fromTap,
        recorder.axChars,
        recorder.axDeletions,
        recorder.axSwitches,
        recorder.axHits,
        recorder.axReads,
        recorder.axKicks,
        recorder.diag,
        recorder.secureInputSeen ? 1 : 0,
        AXIsProcessTrusted() ? "y" : "n",
        recorder.frontmostApp
    ))
}

Timer.scheduledTimer(withTimeInterval: kDuration, repeats: false) { _ in
    if recorder.sessionKeys > 0 { recorder.sessionCount += 1 }
    let sorted = recorder.intervals.sorted()
    let median = sorted.isEmpty ? 0 : sorted[sorted.count / 2]
    emit("--- SUMMARY ---")
    emit("totalKeys=\(recorder.totalKeys) textKeys=\(recorder.textKeys) peakCpm=\(recorder.peakCpm)")
    emit("fromNS=\(recorder.fromNS) fromTap=\(recorder.fromTap) dupSuppressed=\(recorder.dupSuppressed) tapCreated=\(recorder.tapCreated ? 1 : 0)")
    emit("axChars=\(recorder.axChars) axDel=\(recorder.axDeletions) axSwitches=\(recorder.axSwitches) net=\(recorder.axChars - recorder.axDeletions)")
    emit(String(format: "medianInterval=%.0fms  notesPerMin=%.0f", median * 1000, median > 0 ? 60.0 / median : 0))
    emit("sessions=\(recorder.sessionCount) longestGap=\(String(format: "%.2f", recorder.longestGap))s secure=\(recorder.secureInputSeen ? 1 : 0)")
    emit("=== END ===")
    exit(0)
}

app.run()
