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

    var netChars: Int { max(0, chars - deletions) }

    /// 有效输入率：净保留字数 / 击键数
    var efficiency: Double {
        keystrokes > 0 ? Double(netChars) / Double(keystrokes) : 0
    }
}

struct Session: Codable {
    var start: Date
    var end: Date
    var keystrokes: Int
    var chars: Int

    var duration: TimeInterval { end.timeIntervalSince(start) }
}
