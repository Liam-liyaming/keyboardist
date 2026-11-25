import Foundation
import CryptoKit
import Security

/// 本地加密的「输入日记」。
///
/// 设计约束：
///   * 只存**新打出来的那段文字**，不存整篇文档
///   * AES-GCM 加密落盘，密钥在 Keychain —— 文件脱离 App 打不开
///   * 默认保留 7 天，启动时清理
///   * 存放在 Application Support，**不放进 Documents**（避免被 iCloud 同步）
enum TextJournal {
    struct Entry: Codable {
        let t: Date
        let app: String
        let text: String
    }

    static let retentionDays = 7

    private static var directory: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("Keyboardist/journal", isDirectory: true)
    }

    // MARK: - 密钥

    private static let keyService = "com.liyaming.keyboardist.journal"
    private static let keyAccount = "primary"

    private static func loadKey() -> SymmetricKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keyService,
            kSecAttrAccount as String: keyAccount,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
           let data = item as? Data, data.count == 32 {
            return SymmetricKey(data: data)
        }

        let key = SymmetricKey(size: .bits256)
        let data = key.withUnsafeBytes { Data($0) }
        var add: [String: Any] = query
        add[kSecValueData as String] = data
        add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        SecItemAdd(add as CFDictionary, nil)
        return key
    }

    private static let key = loadKey()

    // MARK: - 读写

    private static func fileURL(day: String) -> URL {
        directory.appendingPathComponent("\(day).enc")
    }

    private static func load(day: String) -> [Entry] {
        guard let sealed = try? Data(contentsOf: fileURL(day: day)),
              let box = try? AES.GCM.SealedBox(combined: sealed),
              let plain = try? AES.GCM.open(box, using: key),
              let entries = try? JSONDecoder().decode([Entry].self, from: plain)
        else { return [] }
        return entries
    }

    private static func save(_ entries: [Entry], day: String) {
        guard let plain = try? JSONEncoder().encode(entries),
              let box = try? AES.GCM.seal(plain, using: key),
              let combined = box.combined
        else { return }
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try? combined.write(to: fileURL(day: day))
    }

    // MARK: - 对外

    static var isEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: "journalEnabled") == nil { return true }
            return UserDefaults.standard.bool(forKey: "journalEnabled")
        }
        set { UserDefaults.standard.set(newValue, forKey: "journalEnabled") }
    }

    /// 追加一段新输入出来的文字
    static func append(_ text: String, app: String, at date: Date = Date()) {
        guard isEnabled else { return }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.count <= 4000 else { return }

        let day = Self.dayKey(date)
        var entries = load(day: day)

        // 同一个 App 连续输入的碎片合并成一段（0.35 秒采样一次，不合并会碎成上百条）
        if let last = entries.last,
           last.app == app,
           date.timeIntervalSince(last.t) < 12 {
            entries[entries.count - 1] = Entry(t: last.t, app: app, text: last.text + trimmed)
        } else {
            entries.append(Entry(t: date, app: app, text: trimmed))
        }
        save(entries, day: day)
    }

    static func entries(for day: String) -> [Entry] {
        load(day: day)
    }

    static func clear(day: String) {
        try? FileManager.default.removeItem(at: fileURL(day: day))
    }

    static func clearAll() {
        let files = (try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)) ?? []
        for f in files { try? FileManager.default.removeItem(at: f) }
    }

    /// 删掉超过保留期的日期
    static func purgeOld() {
        let cutoff = Calendar.current.date(byAdding: .day, value: -retentionDays, to: Date()) ?? Date()
        let cutoffKey = dayKey(cutoff)
        let files = (try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)) ?? []
        for f in files where f.lastPathComponent.hasSuffix(".enc") {
            let day = f.deletingPathExtension().lastPathComponent
            if day < cutoffKey { try? FileManager.default.removeItem(at: f) }
        }
    }

    static func dayKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}
