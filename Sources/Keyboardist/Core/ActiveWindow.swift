import AppKit

/// 找出「用户此刻在打字的那个窗口」在哪块屏。
/// 辉光横向铺满整块屏，只在不同显示器之间切换。
///
/// 为什么要自己算坐标：
///   * CGWindowList 用的是「左上角原点、y 向下」的全局坐标
///   * NSScreen / NSWindow 用的是「左下角原点、y 向上」
///   跨屏和多显示器时，这两套坐标系的差值不是零，必须显式换算。
enum ActiveWindow {

    struct Target {
        let screen: NSScreen
        let frame: CGRect          // 辉光窗口应该在的 AppKit 坐标
        let appName: String
        let windowWidth: CGFloat
    }

    /// 主屏（原点在 0,0 的那块）——换算坐标的基准
    private static var primaryScreen: NSScreen? {
        NSScreen.screens.first { $0.frame.origin == .zero } ?? NSScreen.screens.first
    }

    static func glowTarget(height: CGFloat = 220) -> Target? {
        guard let app = NSWorkspace.shared.frontmostApplication else { return nil }

        // 自己不是目标
        if app.processIdentifier == ProcessInfo.processInfo.processIdentifier {
            return nil
        }

        guard let cgRect = frontWindowFrame(for: app.processIdentifier) else {
            // 没有窗口信息时退回「整块主屏」，至少不会没有反馈
            guard let screen = NSScreen.main ?? NSScreen.screens.first else { return nil }
            return Target(
                screen: screen,
                frame: CGRect(x: screen.frame.minX, y: screen.frame.minY,
                              width: screen.frame.width, height: height),
                appName: app.localizedName ?? "?",
                windowWidth: screen.frame.width
            )
        }

        let appKitRect = toAppKit(cgRect)

        let center = CGPoint(x: appKitRect.midX, y: appKitRect.midY)
        guard let screen = NSScreen.screens.first(where: { $0.frame.contains(center) })
                ?? NSScreen.main else { return nil }

        // 横向铺满整块屏（不跟随窗口宽度），纵向贴这块屏的底边
        return Target(
            screen: screen,
            frame: CGRect(x: screen.frame.minX, y: screen.frame.minY,
                          width: screen.frame.width, height: height),
            appName: app.localizedName ?? "?",
            windowWidth: screen.frame.width
        )
    }

    /// CG（左上原点）→ AppKit（左下原点）
    static func toAppKit(_ cgRect: CGRect) -> CGRect {
        guard let primary = primaryScreen else { return cgRect }
        let flippedY = primary.frame.maxY - cgRect.maxY
        return CGRect(x: cgRect.minX, y: flippedY, width: cgRect.width, height: cgRect.height)
    }

    /// 前台 App 最上层的普通窗口（layer 0、尺寸合理）
    static func frontWindowFrame(for pid: pid_t) -> CGRect? {
        guard let list = CGWindowListCopyWindowInfo(
            [.optionOnScreenOnly, .excludeDesktopElements],
            kCGNullWindowID
        ) as? [[String: Any]] else { return nil }

        for info in list {
            guard let owner = info[kCGWindowOwnerPID as String] as? Int, owner == Int(pid) else { continue }
            guard let layer = info[kCGWindowLayer as String] as? Int, layer == 0 else { continue }
            guard let boundsDict = info[kCGWindowBounds as String] as? [String: Any],
                  let rect = CGRect(dictionaryRepresentation: boundsDict as CFDictionary)
            else { continue }
            if rect.width < 200 || rect.height < 120 { continue }
            return rect
        }
        return nil
    }
}
