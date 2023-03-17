// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataAccess",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "DataAccess",
            targets: ["DataAccess"]),
    ],
    dependencies: [
        .package(path: "Common"),
        .package(path: "Networking"),
    ],
    targets: [
        .target(
            name: "DataAccess",
            dependencies: [
                "Common",
                "Networking"
            ]),
        .testTarget(
            name: "DataAccessTests",
            dependencies: ["DataAccess"]),
    ]
)
