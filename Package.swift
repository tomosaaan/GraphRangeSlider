// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GraphRangeSlider",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "GraphRangeSlider",
            targets: ["GraphRangeSlider"]),
    ],
    targets: [
        .target(
            name: "GraphRangeSlider"),
    ]
)
