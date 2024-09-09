// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Numerica",
    platforms: [
        .iOS("17.4"),
        .macOS(.v13),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Numerica",
            dependencies: [],
            path: "./"
        )
    ]
)

