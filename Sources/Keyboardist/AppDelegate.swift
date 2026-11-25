import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let engine = Engine()
    private let glow = GlowOverlay()
    private let halo = HaloOverlay()
    private var menuBar: MenuBarController?
    private var targetingTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        engine.onKey = { [weak self] keyCode, speed in
            self?.glow.spark(keyCode: keyCode, speed: speed)
        }
        engine.onChange = { [weak self] in
            self?.menuBar?.refresh()
        }
        engine.onEnterPrepare = { [weak self] in
            self?.halo.prepare()
        }
        engine.onEnter = { [weak self] in
            self?.halo.commit()
        }

        menuBar = MenuBarController(engine: engine, glow: glow)
        glow.onTargetChange = { [weak self] name in
            self?.menuBar?.setActiveApp(name)
        }

        glow.start()
        HaloMetalView.warmUp()
        halo.warmUp()   // 提前编译着色器，避免第一次回车卡顿
        engine.start()

        // 换 App 立刻跟随
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(activeAppChanged),
            name: NSWorkspace.didActivateApplicationNotification,
            object: nil
        )

        // 窗口被拖动 / 分屏调整时兜底
        targetingTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
            self?.glow.updateTarget()
        }

        if !engine.hasPermissions {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.engine.requestPermissions()
            }
        }
    }

    @objc private func activeAppChanged() {
        glow.updateTarget()
    }

    func applicationWillTerminate(_ notification: Notification) {
        targetingTimer?.invalidate()
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        engine.stop()
        glow.stop()
    }
}
