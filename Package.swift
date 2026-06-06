// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "transmission-rpc",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .tvOS(.v15),
    .watchOS(.v8),
  ],
  products: [
    .library(
      name: "TransmissionRPC",
      targets: ["TransmissionRPC"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "TransmissionRPC",
      dependencies: [],
      path: "Sources/TransmissionRPC"
    ),
    .testTarget(
      name: "TransmissionRPCTests",
      dependencies: ["TransmissionRPC"],
      path: "Tests/TransmissionRPCTests"
    ),
  ]
)
