// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "SecondFoundation",
    platforms: [.macOS(.v11), .iOS(.v14)],
    products: [
        .library(
            name: "SecondFoundation",
            targets: ["SecondFoundation"]
        )
    ],
    targets: [
        .target(
            name: "SecondFoundation"
        ),
        .testTarget(
            name: "SecondFoundationTests",
            dependencies: ["SecondFoundation"],
            resources: [.process("Assets")]
        )
    ]
)
