import Foundation

/// 一天的全部输入画像。只存整数与时间，永不存内容。
struct DayRecord: Codable {
    var day: String
    var keystrokes: Int = 0
    var chars: Int = 0
    var deletions: Int = 0
    var firstAt: Date?
    var lastAt: Date?
    var sessions: [Session] = []
    /// "HH:mm" -> 击键数
    var minuteKeys: [String: Int] = [:]
    /// keyCode -> 击键数（用于键盘热力图与音高分布）
    var keyCodes: [String: Int] = [:]
    /// bundleIdentifier -> 该应用当天的输入画像（只存整数与应用名，不存内容）
    var apps: [String: AppStat] = [:]

    var netChars: Int { max(0, chars - deletions) }

    /// 有效输入率：净保留字数 / 击键数
    var efficiency: Double {
        keystrokes > 0 ? Double(netChars) / Double(keystrokes) : 0
    }

    init(day: String) {
        self.day = day
    }

    /// 兼容旧版 day 文件：新增字段用 decodeIfPresent 回退到默认值，
    /// 避免升级当天丢掉已记录的数据。
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        day = try c.decode(String.self, forKey: .day)
        keystrokes = try c.decode(Int.self, forKey: .keystrokes)
        chars = try c.decode(Int.self, forKey: .chars)
        deletions = try c.decode(Int.self, forKey: .deletions)
        firstAt = try c.decodeIfPresent(Date.self, forKey: .firstAt)
        lastAt = try c.decodeIfPresent(Date.self, forKey: .lastAt)
        sessions = try c.decodeIfPresent([Session].self, forKey: .sessions) ?? []
        minuteKeys = try c.decodeIfPresent([String: Int].self, forKey: .minuteKeys) ?? [:]
        keyCodes = try c.decodeIfPresent([String: Int].self, forKey: .keyCodes) ?? [:]
        apps = try c.decodeIfPresent([String: AppStat].self, forKey: .apps) ?? [:]
    }

    private enum CodingKeys: String, CodingKey {
        case day, keystrokes, chars, deletions, firstAt, lastAt
        case sessions, minuteKeys, keyCodes, apps
    }
}

/// 单个应用当天的输入画像。
struct AppStat: Codable {
    var name: String = ""
    var keystrokes: Int = 0
    var chars: Int = 0
    var deletions: Int = 0
}

struct Session: Codable {
    var start: Date
    var end: Date
    var keystrokes: Int
    var chars: Int

    var duration: TimeInterval { end.timeIntervalSince(start) }
}
