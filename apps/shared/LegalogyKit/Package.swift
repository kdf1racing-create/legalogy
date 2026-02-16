// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "LegalogyKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "LegalogyProtocol", targets: ["LegalogyProtocol"]),
        .library(name: "LegalogyKit", targets: ["LegalogyKit"]),
        .library(name: "LegalogyChatUI", targets: ["LegalogyChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "LegalogyProtocol",
            path: "Sources/LegalogyProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "LegalogyKit",
            dependencies: [
                "LegalogyProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/LegalogyKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "LegalogyChatUI",
            dependencies: [
                "LegalogyKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/LegalogyChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "LegalogyKitTests",
            dependencies: ["LegalogyKit", "LegalogyChatUI"],
            path: "Tests/LegalogyKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
