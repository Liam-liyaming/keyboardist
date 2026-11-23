import Foundation

/// 键盘物理布局 → 横向位置。
/// 这是「键盘即琴键」的数学基础：底排最低、顶排最高，
/// 同时左右位置决定辉光在屏幕底部亮起的地方。
enum KeyLayout {
    /// (行, 列)：行 0 = 数字排（最高），行 3 = ZXCVB（最低）
    private static let grid: [Int64: (row: Int, col: Int)] = [
        // 数字排
        18: (0, 0), 19: (0, 1), 20: (0, 2), 21: (0, 3), 23: (0, 4),
        22: (0, 5), 26: (0, 6), 28: (0, 7), 25: (0, 8), 29: (0, 9),
        27: (0, 10), 24: (0, 11), 51: (0, 12),
        // QWERTY 排
        12: (1, 0), 13: (1, 1), 14: (1, 2), 15: (1, 3), 17: (1, 4),
        16: (1, 5), 32: (1, 6), 34: (1, 7), 31: (1, 8), 35: (1, 9),
        33: (1, 10), 30: (1, 11), 42: (1, 12),
        // ASDF 排
        0: (2, 0), 1: (2, 1), 2: (2, 2), 3: (2, 3), 5: (2, 4),
        4: (2, 5), 38: (2, 6), 40: (2, 7), 37: (2, 8), 41: (2, 9), 39: (2, 10),
        // ZXCV 排
        6: (3, 0), 7: (3, 1), 8: (3, 2), 9: (3, 3), 11: (3, 4),
        45: (3, 5), 46: (3, 6), 43: (3, 7), 47: (3, 8), 44: (3, 9),
        // 空格与回车
        49: (3, 5), 36: (2, 11), 48: (1, 0),
    ]

    /// 每行错位的起始偏移（键位宽度为单位）
    private static let rowOffset: [Double] = [0.0, 0.18, 0.36, 0.62]
    private static let rowWidth: Double = 14.2

    /// 归一化到 0...1 的横向位置
    static func normalizedX(for keyCode: Int64) -> Double? {
        guard let cell = grid[keyCode] else { return nil }
        let offset = rowOffset[min(cell.row, rowOffset.count - 1)]
        return (offset + Double(cell.col) + 0.5) / rowWidth
    }

    /// 行 → 八度偏移（数字排 +2，QWERTY +1，ASDF 0，ZXCV -1）
    static func octaveOffset(for keyCode: Int64) -> Int {
        guard let cell = grid[keyCode] else { return 0 }
        return 2 - cell.row
    }

    /// 五声音阶（A 小调）：0 3 5 7 10
    static let pentatonic = [0, 3, 5, 7, 10]

    /// 键位 → 五声音阶的级数（横向列决定）
    static func degree(for keyCode: Int64) -> Int? {
        guard let cell = grid[keyCode] else { return nil }
        return Int((Double(min(cell.col, 12)) / 12.0 * 4.0).rounded())
    }

    /// 键位 → MIDI 音高（行决定八度，列决定音级）
    static func midiNote(for keyCode: Int64) -> Int {
        guard let cell = grid[keyCode], let deg = degree(for: keyCode) else { return 69 }
        let base = [81, 69, 57, 45]
        return base[min(cell.row, 3)] + pentatonic[deg]
    }

    /// 击键速度 → 色相：慢是冷青，快是暖琥珀
    static func hue(forSpeed speed: Double) -> Double {
        let s = max(0, min(1, speed))
        return 0.55 - 0.48 * s
    }
}
