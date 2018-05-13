// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ErrorsCore",
    products: [
        .library(name: "ErrorsCore", targets: ["ErrorsCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.5.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "ErrorsCore", dependencies: ["Vapor"]),
        .testTarget(name: "ErrorsCoreTests", dependencies: ["ErrorsCore", "Vapor"]),
    ]
)
