// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "transmission-rpc",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
    .tvOS(.v17),
    .watchOS(.v10),
  ],
  products: [
    .library(
      name: "TransmissionRPC",
      targets: ["TransmissionRPC"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-testing.git", branch: "main")
  ],
  targets: [
    .target(
      name: "TransmissionRPC",
      dependencies: [],
      path: "Sources/TransmissionRPC"
    ),
    .testTarget(
      name: "TransmissionRPCTests",
      dependencies: [
        "TransmissionRPC",
        .product(name: "Testing", package: "swift-testing"),
      ],
      path: "Tests/TransmissionRPCTests"
    ),
  ]
)
