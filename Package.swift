// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Keyboardist",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Keyboardist",
            path: "Sources/Keyboardist",
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("ApplicationServices"),
                .linkedFramework("Carbon"),
                .linkedFramework("QuartzCore"),
            ]
        )
    ]
)
