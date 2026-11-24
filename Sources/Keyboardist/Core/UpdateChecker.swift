import Foundation

/// 「检查更新…」——只在用户主动点击时发一次请求，平时零联网。
///
/// 设计约束：
///   * 不带任何设备标识、不统计、不上报
///   * 只读一个静态 JSON
///   * 失败就静默失败，不打扰
enum UpdateChecker {
    struct Appcast: Decodable {
        let version: String
        let build: Int?
        let url: String
        let notes: String?
        let releasedAt: String?
    }

    enum CheckError: LocalizedError {
        case network(String)
        case decode(String)

        var errorDescription: String? {
            switch self {
            case .network(let m): return "网络请求失败：\(m)"
            case .decode(let m): return "更新信息格式不对：\(m)"
            }
        }
    }

    static let feedURL = URL(string: "https://raw.githubusercontent.com/Liam-liyaming/keyboardist/main/appcast.json")!

    static var currentVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }

    static var currentBuild: Int {
        Int(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0") ?? 0
    }

    static func fetch() async throws -> Appcast {
        var request = URLRequest(url: feedURL)
        request.timeoutInterval = 8
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(Appcast.self, from: data)
        } catch let error as DecodingError {
            throw CheckError.decode(String(describing: error))
        } catch {
            throw CheckError.network(error.localizedDescription)
        }
    }

    /// 语义化比较：0.4.10 > 0.4.9
    static func isNewer(_ remote: String, than local: String) -> Bool {
        let a = remote.split(separator: ".").map { Int($0) ?? 0 }
        let b = local.split(separator: ".").map { Int($0) ?? 0 }
        for i in 0..<max(a.count, b.count) {
            let x = i < a.count ? a[i] : 0
            let y = i < b.count ? b[i] : 0
            if x != y { return x > y }
        }
        return false
    }
}
