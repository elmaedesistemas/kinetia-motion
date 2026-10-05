// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "KinetiaMotion",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "KinetiaMotion", targets: ["KinetiaMotion"]),
        .library(name: "KinetiaMotionVision", targets: ["KinetiaMotionVision"])
    ],
    targets: [
        .target(name: "KinetiaMotion"),
        .target(name: "KinetiaMotionVision", dependencies: ["KinetiaMotion"]),
        .testTarget(name: "KinetiaMotionTests", dependencies: ["KinetiaMotion"]),
        .testTarget(name: "KinetiaMotionVisionTests", dependencies: ["KinetiaMotionVision"])
    ]
)
