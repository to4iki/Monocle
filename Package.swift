// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Monocle",
    dependencies: [
    ],
    targets: [
        .target(name: "Monocle", dependencies: []),
        .testTarget(name: "MonocleTests", dependencies: ["Monocle"])
    ]
)
