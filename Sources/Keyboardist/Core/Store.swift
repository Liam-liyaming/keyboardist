import Foundation

/// 本地存储：一天一个 JSON 文件。
/// 位置 ~/Library/Application Support/Keyboardist/days/YYYY-MM-DD.json
/// 注意：这里只落整数与时间戳，没有任何文本内容。
final class Store {
    private(set) var record: DayRecord
    private let root: URL
    private let dayFormatter: DateFormatter

    init() {
        let fm = FileManager.default
        root = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Keyboardist", isDirectory: true)

        dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        dayFormatter.timeZone = .current

        record = DayRecord(day: Store.dayString())
        try? fm.createDirectory(at: daysDirectory, withIntermediateDirectories: true)
        load()
    }

    var daysDirectory: URL { root.appendingPathComponent("days", isDirectory: true) }

    func fileURL(for day: String) -> URL {
        daysDirectory.appendingPathComponent("\(day).json")
    }

    static func dayString(_ date: Date = Date()) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = .current
        return f.string(from: date)
    }

    /// 跨天时切换文件
    func rolloverIfNeeded() {
        let today = Store.dayString()
        guard today != record.day else { return }
        save()
        record = DayRecord(day: today)
        load()
    }

    private func load() {
        let url = fileURL(for: record.day)
        guard let data = try? Data(contentsOf: url) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let decoded = try? decoder.decode(DayRecord.self, from: data) {
            record = decoded
        }
    }

    func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(record) else { return }
        try? FileManager.default.createDirectory(at: daysDirectory, withIntermediateDirectories: true)
        try? data.write(to: fileURL(for: record.day), options: .atomic)
    }

    /// 读-改-写：保证 Engine 修改的是同一条记录
    func mutate(_ body: (inout DayRecord) -> Void) {
        var copy = record
        body(&copy)
        record = copy
    }
}
