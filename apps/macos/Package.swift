// swift-tools-version: 6.2
// Package manifest for the Legalogy macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "Legalogy",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "LegalogyIPC", targets: ["LegalogyIPC"]),
        .library(name: "LegalogyDiscovery", targets: ["LegalogyDiscovery"]),
        .executable(name: "Legalogy", targets: ["Legalogy"]),
        .executable(name: "legalogy-mac", targets: ["LegalogyMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/LegalogyKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "LegalogyIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "LegalogyDiscovery",
            dependencies: [
                .product(name: "LegalogyKit", package: "LegalogyKit"),
            ],
            path: "Sources/LegalogyDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "Legalogy",
            dependencies: [
                "LegalogyIPC",
                "LegalogyDiscovery",
                .product(name: "LegalogyKit", package: "LegalogyKit"),
                .product(name: "LegalogyChatUI", package: "LegalogyKit"),
                .product(name: "LegalogyProtocol", package: "LegalogyKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/Legalogy.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "LegalogyMacCLI",
            dependencies: [
                "LegalogyDiscovery",
                .product(name: "LegalogyKit", package: "LegalogyKit"),
                .product(name: "LegalogyProtocol", package: "LegalogyKit"),
            ],
            path: "Sources/LegalogyMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "LegalogyIPCTests",
            dependencies: [
                "LegalogyIPC",
                "Legalogy",
                "LegalogyDiscovery",
                .product(name: "LegalogyProtocol", package: "LegalogyKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
