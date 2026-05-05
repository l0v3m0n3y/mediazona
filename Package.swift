// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "mediazona",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "mediazona", targets: ["mediazona"]),
    ],
    targets: [
        .target(
            name: "mediazona",
            path: "src"
        ),
    ]
)
