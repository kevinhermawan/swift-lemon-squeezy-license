// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LemonSqueezyLicense",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "LemonSqueezyLicense",
            targets: ["LemonSqueezyLicense"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", .upToNextMajor(from: "1.4.3"))
    ],
    targets: [
        .target(
            name: "LemonSqueezyLicense"),
        .testTarget(
            name: "LemonSqueezyLicenseTests",
            dependencies: ["LemonSqueezyLicense"]
        )
    ]
)
