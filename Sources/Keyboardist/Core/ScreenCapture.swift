import AppKit
import ScreenCaptureKit

/// 一次性截屏。只在按下回车的那一瞬间抓一帧，不做持续录制。
///
/// 需要的权限：屏幕录制。用户已明确同意（软件不联网，数据全在本地）。
struct CapturedFrame {
    let image: CGImage
    let mask: LineMask.Mask?
}

enum ScreenShot {
    static func hasPermission() -> Bool {
        CGPreflightScreenCaptureAccess()
    }

    @discardableResult
    static func requestPermission() -> Bool {
        CGRequestScreenCaptureAccess()
    }

    /// 抓取指定屏幕的一帧。失败返回 nil，调用方退回「只有色环」的降级版本。
    static func capture(screen: NSScreen) async -> CapturedFrame? {
        guard hasPermission() else { return nil }
        guard let displayID = (screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value else {
            return nil
        }
        if #available(macOS 14.0, *) {
            let started = CACurrentMediaTime()
            guard let image = await captureModern(displayID: displayID) else { return nil }
            let captured = CACurrentMediaTime()

            // 线条掩膜：只留长直线，用来做第 6 层「边线反光」
            let mask = LineMask.make(from: image)
            let masked = CACurrentMediaTime()
            HaloOverlay.log(String(format: "timing capture %.0f ms  mask %.0f ms",
                                   (captured - started) * 1000, (masked - captured) * 1000))
            if let mask {
                let hit = mask.pixels.reduce(0) { $0 + ($1 > 0 ? 1 : 0) }
                HaloOverlay.log("mask \(mask.width)x\(mask.height) coverage \(String(format: "%.2f", Double(hit) / Double(mask.pixels.count) * 100))%")
            } else {
                HaloOverlay.log("mask nil")
            }
            return CapturedFrame(image: image, mask: mask)
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
            HaloOverlay.log("capture failed: \(error.localizedDescription)")
            return nil
        }
    }
}
