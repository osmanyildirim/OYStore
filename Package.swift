// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "OYStore",
    products: [
        .library(name: "OYStore", targets: ["OYStore"])
    ],
    targets: [
        .target(name: "OYStore", path: "Sources")
    ])
