// swift-tools-version: 5.7

import PackageDescription


let package = Package(
    name: "SecondFoundation",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15)],
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
