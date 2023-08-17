// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "SecondFoundation",
    products: [
        .library(
            name: "SecondFoundation",
            targets: ["SecondFoundation"]
        )
    ],
    targets: [
        .target(
            name: "SecondFoundation",
            resources: [.process("Assets")]
        ),
        .testTarget(
            name: "SecondFoundationTests",
            dependencies: ["SecondFoundation"]
        )
    ]
)
