// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ErrorsCore",
    products: [
        .library(name: "ErrorsCore", targets: ["ErrorsCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .branch("master"))
    ],
    targets: [
        .target(name: "ErrorsCore", dependencies: ["Vapor"]),
        .testTarget(name: "ErrorsCoreTests", dependencies: ["ErrorsCore", "Vapor"]),
    ]
)
