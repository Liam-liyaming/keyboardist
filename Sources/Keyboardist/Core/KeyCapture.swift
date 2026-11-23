import Foundation
import ApplicationServices
import Carbon

/// 采集层 · 第一把钥匙：全局击键节拍。
///
/// 实测结论（macOS 26）：
///   * NSEvent.addGlobalMonitorForEvents 对键盘事件基本不生效，不能依赖。
///   * CGEvent.tapCreate(.listenOnly) 可靠，需要「辅助功能」授权。
///
final class KeyCapture {
    var onKey: ((Int64) -> Void)?

    private var tap: CFMachPort?
    private var retryTimer: Timer?
    private(set) var isRunning = false

    private static let modifierKeyCodes: Set<Int64> = [54, 55, 56, 57, 58, 59, 60, 61, 62, 63]

    static func isSecureInputEnabled() -> Bool {
        IsSecureEventInputEnabled()
    }

    static func hasAccessibility() -> Bool {
        AXIsProcessTrusted()
    }

    func requestAccessibility() {
        let opts = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(opts)
    }

    func start() {
        guard !isRunning else { return }
        attemptTap()

        // 权限可能稍后才被授予，持续重试（授权后无需重启进程）
        retryTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self, self.tap == nil else { return }
            self.attemptTap()
        }
    }

    func stop() {
        retryTimer?.invalidate()
        retryTimer = nil
        if let tap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        tap = nil
        isRunning = false
    }

    private func attemptTap() {
        guard tap == nil else { return }

        let mask = CGEventMask((1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue))
        let userInfo = Unmanaged.passUnretained(self).toOpaque()

        guard let created = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: mask,
            callback: KeyCapture.callback,
            userInfo: userInfo
        ) else { return }

        tap = created
        isRunning = true
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, created, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        CGEvent.tapEnable(tap: created, enable: true)
    }

    fileprivate func handle(type: CGEventType, event: CGEvent) {
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if let tap { CGEvent.tapEnable(tap: tap, enable: true) }
            return
        }
        guard type == .keyDown else { return }
        guard event.getIntegerValueField(.keyboardEventAutorepeat) == 0 else { return }

        let code = event.getIntegerValueField(.keyboardEventKeycode)
        guard !KeyCapture.modifierKeyCodes.contains(code) else { return }
        guard !KeyCapture.isSecureInputEnabled() else { return }

        onKey?(code)
    }

    private static let callback: CGEventTapCallBack = { _, type, event, userInfo in
        if let userInfo {
            let capture = Unmanaged<KeyCapture>.fromOpaque(userInfo).takeUnretainedValue()
            capture.handle(type: type, event: event)
        }
        return Unmanaged.passUnretained(event)
    }
}
