import AppKit
import ScreenCaptureKit

/// 一次性截屏。只在按下回车的那一瞬间抓一帧，不做持续录制。
///
/// 需要的权限：屏幕录制。用户已明确同意（软件不联网，数据全在本地）。
enum ScreenShot {
    static func hasPermission() -> Bool {
        CGPreflightScreenCaptureAccess()
    }

    @discardableResult
    static func requestPermission() -> Bool {
        CGRequestScreenCaptureAccess()
    }

    /// 抓取指定屏幕的一帧。失败返回 nil，调用方退回「只有色环」的降级版本。
    static func capture(screen: NSScreen) async -> CGImage? {
        guard hasPermission() else { return nil }
        guard let displayID = (screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value else {
            return nil
        }
        if #available(macOS 14.0, *) {
            return await captureModern(displayID: displayID)
        }
        return nil   // macOS 13 及以下：没有 SCScreenshotManager，走降级版
    }

    @available(macOS 14.0, *)
    private static func captureModern(displayID: CGDirectDisplayID) async -> CGImage? {
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
            guard let display = content.displays.first(where: { $0.displayID == displayID }) else { return nil }

            let filter = SCContentFilter(display: display, excludingWindows: [])
            let config = SCStreamConfiguration()
            config.width = display.width
            config.height = display.height
            config.showsCursor = false

            return try await SCScreenshotManager.captureImage(contentFilter: filter, configuration: config)
        } catch {
            NSLog("Halo capture failed: \(error)")
            return nil
        }
    }
}
