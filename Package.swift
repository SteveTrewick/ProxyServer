// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProxyServer",
    products: [
        .library(
            name: "ProxyServer",
            targets: ["ProxyServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.16.0")
    ],
    targets: [
        .target(
            name: "ProxyServer",
            dependencies: [
            	.product(name: "NIO", package: "swift-nio")
            ]),
    ]
)
