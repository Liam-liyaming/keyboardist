import AppKit

/// 菜单栏：今日画像的最小入口。
final class MenuBarController: NSObject {
    private let engine: Engine
    private let glow: GlowOverlay
    private let statusItem: NSStatusItem

    private var charsItem: NSMenuItem!
    private var keysItem: NSMenuItem!
    private var sessionItem: NSMenuItem!
    private var appItem: NSMenuItem!
    private var songItem: NSMenuItem!
    private var screenItem: NSMenuItem!
    private var activeApp: String = "-"
    private var glowItem: NSMenuItem!
    private var pauseItem: NSMenuItem!
    private var refreshTimer: Timer?

    init(engine: Engine, glow: GlowOverlay) {
        self.engine = engine
        self.glow = glow
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        super.init()

        configureButton()
        buildMenu()
        syncHaloMenu(statusItem.menu?.item(withTitle: "冲击波强度")?.submenu)
        refresh()

        refreshTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.refresh()
        }
    }

    private func configureButton() {
        guard let button = statusItem.button else { return }
        let image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "键盘手")
        image?.isTemplate = true
        button.image = image
        button.imagePosition = .imageLeading
        button.toolTip = "键盘手"
    }

    private func buildMenu() {
        let menu = NSMenu()
        menu.autoenablesItems = false

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
        let verItem = NSMenuItem(title: "键盘手 v\(version) (\(build))", action: nil, keyEquivalent: "")
        verItem.isEnabled = false
        menu.addItem(verItem)
        menu.addItem(.separator())

        charsItem = NSMenuItem(title: "今日 0 字", action: nil, keyEquivalent: "")
        charsItem.isEnabled = false
        keysItem = NSMenuItem(title: "击键 0 · 速度 0", action: nil, keyEquivalent: "")
        keysItem.isEnabled = false
        sessionItem = NSMenuItem(title: "会话 0 段", action: nil, keyEquivalent: "")
        sessionItem.isEnabled = false
        appItem = NSMenuItem(title: "辉光跟随：-", action: nil, keyEquivalent: "")
        appItem.isEnabled = false
        songItem = NSMenuItem(title: "生成今日之歌…", action: #selector(renderSong), keyEquivalent: "g")
        songItem.target = self

        menu.addItem(charsItem)
        menu.addItem(keysItem)
        menu.addItem(sessionItem)
        menu.addItem(appItem)
        menu.addItem(.separator())
        menu.addItem(songItem)

        let haloMenu = NSMenu()
        for (title, value) in [("轻", 0.45), ("中", 0.7), ("重", 1.0)] {
            let item = NSMenuItem(title: title, action: #selector(setHaloIntensity(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = value
            haloMenu.addItem(item)
        }
        let haloRoot = NSMenuItem(title: "冲击波强度", action: nil, keyEquivalent: "")
        haloRoot.submenu = haloMenu
        menu.addItem(haloRoot)
        menu.addItem(.separator())

        glowItem = NSMenuItem(title: "屏幕辉光", action: #selector(toggleGlow), keyEquivalent: "")
        glowItem.target = self
        menu.addItem(glowItem)

        pauseItem = NSMenuItem(title: "暂停记录", action: #selector(togglePause), keyEquivalent: "")
        pauseItem.target = self
        menu.addItem(pauseItem)

        menu.addItem(.separator())

        let privacy = NSMenuItem(title: "隐私说明…", action: #selector(showPrivacy), keyEquivalent: "")
        privacy.target = self
        screenItem = NSMenuItem(title: "屏幕录制权限…", action: #selector(screenPermission), keyEquivalent: "")
        screenItem.target = self
        menu.addItem(screenItem)

        let update = NSMenuItem(title: "检查更新…", action: #selector(checkUpdates), keyEquivalent: "")
        update.target = self
        menu.addItem(update)

        menu.addItem(privacy)

        let quit = NSMenuItem(title: "退出键盘手", action: #selector(quit), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)

        statusItem.menu = menu
    }

    func refresh() {
        let r = engine.record
        statusItem.button?.title = " " + MenuBarController.compact(r.netChars)

        charsItem?.title = "今日 \(MenuBarController.grouped(r.netChars)) 字 · 击键 \(MenuBarController.grouped(r.keystrokes))"
        keysItem?.title = "速度 \(engine.recentCPM) 击键/分 · 峰值 \(engine.peakCPM)"
        sessionItem?.title = "会话 \(r.sessions.count) 段 · 有效输入 \(Int(r.efficiency * 100))%"
        appItem?.title = "辉光跟随：\(activeApp)"

        glowItem?.state = glow.isEnabled ? .on : .off
        pauseItem?.state = engine.isPaused ? .on : .off
    }

    func setActiveApp(_ name: String) {
        guard name != activeApp else { return }
        activeApp = name
        refresh()
    }

    @objc private func renderSong() {
        songItem.title = "正在生成今日之歌…"
        songItem.isEnabled = false

        let record = engine.record
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let url = SongRenderer.defaultURL(for: record.day)
            var summary: SongSummary?
            var failure: String?

            do {
                summary = try SongRenderer.render(record, to: url)
            } catch {
                failure = error.localizedDescription
            }

            DispatchQueue.main.async {
                guard let self else { return }
                self.songItem.title = "生成今日之歌…"
                self.songItem.isEnabled = true

                if let failure {
                    let alert = NSAlert()
                    alert.messageText = "生成失败"
                    alert.informativeText = failure
                    alert.runModal()
                    return
                }

                NSSound(contentsOf: url, byReference: false)?.play()

                let alert = NSAlert()
                alert.messageText = "今日之歌已生成"
                if let summary {
                    alert.informativeText = "BPM \(summary.bpm) · \(summary.bars) 小节 · \(Int(summary.seconds)) 秒\n\(url.path)"
                } else {
                    alert.informativeText = url.path
                }
                alert.addButton(withTitle: "好")
                alert.addButton(withTitle: "在 Finder 中显示")
                if alert.runModal() == .alertSecondButtonReturn {
                    NSWorkspace.shared.activateFileViewerSelecting([url])
                }
            }
        }
    }

    @objc private func setHaloIntensity(_ sender: NSMenuItem) {
        if let value = sender.representedObject as? Double {
            HaloOverlay.intensity = value
            syncHaloMenu(sender.menu)
        }
    }

    private func syncHaloMenu(_ menu: NSMenu?) {
        let current = HaloOverlay.intensity
        menu?.items.forEach { item in
            if let v = item.representedObject as? Double {
                item.state = abs(v - current) < 0.01 ? .on : .off
            }
        }
    }

    @objc private func toggleGlow() {
        glow.isEnabled.toggle()
        refresh()
    }

    @objc private func togglePause() {
        engine.isPaused.toggle()
        refresh()
    }


    @objc private func screenPermission() {
        if ScreenShot.hasPermission() {
            let alert = NSAlert()
            alert.messageText = "屏幕录制权限已开启"
            alert.informativeText = "回车冲击波会抓取一帧屏幕来做透镜扭曲。画面只在本机内存里用一次，用完立即丢弃。"
            alert.runModal()
            return
        }

        let alert = NSAlert()
        alert.messageText = "开启屏幕录制权限"
        alert.informativeText = "回车冲击波需要抓取一帧屏幕，才能做出「文字被推开、边缘色散」的效果。没有这个权限也能用，只是会降级成纯发光色环。\n\n数据不出本机：抓到的画面只用于这一次动画，用完立刻丢弃，不写盘、不上传。"
        alert.addButton(withTitle: "去开启")
        alert.addButton(withTitle: "算了")
        if alert.runModal() == .alertFirstButtonReturn {
            ScreenShot.requestPermission()
        }
    }


    @objc private func checkUpdates() {
        Task {
            do {
                let remote = try await UpdateChecker.fetch()
                await MainActor.run { self.presentUpdate(remote) }
            } catch {
                await MainActor.run {
                    let alert = NSAlert()
                    alert.messageText = "检查更新失败"
                    alert.informativeText = error.localizedDescription
                    alert.runModal()
                }
            }
        }
    }

    private func presentUpdate(_ remote: UpdateChecker.Appcast) {
        let current = UpdateChecker.currentVersion

        guard UpdateChecker.isNewer(remote.version, than: current) else {
            let alert = NSAlert()
            alert.messageText = "已是最新版本"
            alert.informativeText = "当前 \(current)，远端 \(remote.version)。"
            alert.runModal()
            return
        }

        let alert = NSAlert()
        alert.messageText = "有新版本 \(remote.version)"
        var text = "当前 \(current)。"
        if let notes = remote.notes, !notes.isEmpty {
            text += "\n\n\(notes)"
        }
        if let date = remote.releasedAt {
            text += "\n\n发布于 \(date)"
        }
        alert.informativeText = text
        alert.addButton(withTitle: "去下载")
        alert.addButton(withTitle: "稍后")
        if alert.runModal() == .alertFirstButtonReturn,
           let url = URL(string: remote.url) {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func showPrivacy() {
        let alert = NSAlert()
        alert.messageText = "键盘手只记录整数"
        alert.informativeText = """
        本应用只统计：击键次数、字数、时间戳、会话长度。
        不记录任何输入内容，不上传任何数据，不连接网络。

        数据保存在：
        ~/Library/Application Support/Keyboardist/days/

        密码框等安全输入场景会自动停止统计。
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "好")
        alert.runModal()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    // MARK: - 格式化

    private static func grouped(_ value: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private static func compact(_ value: Int) -> String {
        if value >= 10000 { return String(format: "%.1fw", Double(value) / 10000) }
        if value >= 1000 { return String(format: "%.1fk", Double(value) / 1000) }
        return "\(value)"
    }
}
