# transmission-rpc

[![Build & Test](https://github.com/mogeko/transmission-rpc/actions/workflows/build+test.yml/badge.svg)](https://github.com/mogeko/transmission-rpc/actions/workflows/build+test.yml)
[![Swift](https://img.shields.io/badge/Swift-5.9+-f05138?logo=swift)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS-silver)](https://swiftpackageindex.com/mogeko/transmission-rpc)
[![MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A Swift library for the [Transmission RPC specification](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md). Provides Swift-native types and an `async/await`-based client to interact with Transmission BitTorrent clients via their JSON-RPC API.

## Requirements

- Swift 5.9+
- macOS 14+ / iOS 17+ / tvOS 17+ / watchOS 10+
- Transmission 4.1.0+ (`rpc_version_semver` 6.0.0)

## Installation

Add `transmission-rpc` as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/mogeko/transmission-rpc.git", from: "0.1.0"),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "TransmissionRPC", package: "transmission-rpc"),
        ]
    ),
]
```

## Quick Start

```swift
import TransmissionRPC

let client = Client(baseURL: URL(string: "http://localhost:9091")!)

// Get session info
let session = try await client.sessionGet()
print("Transmission version: \(session.version ?? "unknown")")

// List all torrents
let torrents = try await client.torrents()
for torrent in torrents {
  print("[\(torrent.status?.rawValue ?? -1)] \(torrent.name ?? "?") — \(torrent.percentDone ?? 0)%")
}

// Add a torrent from URL
let result = try await client.addTorrent(url: URL(string: "https://example.com/file.torrent")!)
print("Added: \(result.torrentAdded?.name ?? "duplicate")")
```

## Supported RPC Methods

### Torrent Actions

| Method                  | Description                               |
| ----------------------- | ----------------------------------------- |
| `torrentStart(_:)`      | Start torrents                            |
| `torrentStartNow(_:)`   | Start torrents immediately (bypass queue) |
| `torrentStop(_:)`       | Stop torrents                             |
| `torrentVerify(_:)`     | Verify local data                         |
| `torrentReannounce(_:)` | Request more peers from tracker           |

### Torrent Accessors & Mutators

| Method                                   | Description                      |
| ---------------------------------------- | -------------------------------- |
| `torrentGet(ids:fields:format:)`         | Retrieve torrent information     |
| `torrentSet(_:)`                         | Modify torrent properties        |
| `torrentAdd(_:)`                         | Add a new torrent                |
| `torrentRemove(ids:deleteLocalData:)`    | Remove torrents                  |
| `torrentSetLocation(ids:location:move:)` | Move torrent data                |
| `torrentRenamePath(ids:path:name:)`      | Rename file/directory in torrent |

### Session

| Method                | Description                 |
| --------------------- | --------------------------- |
| `sessionGet(fields:)` | Retrieve session settings   |
| `sessionSet(_:)`      | Modify session settings     |
| `sessionStats()`      | Retrieve session statistics |
| `sessionClose()`      | Shut down the session       |

### Utilities

| Method                                          | Description                |
| ----------------------------------------------- | -------------------------- |
| `blocklistUpdate()`                             | Update the blocklist       |
| `portTest(ipProtocol:)`                         | Test port connectivity     |
| `freeSpace(path:)`                              | Check available disk space |
| `queueMoveTop(ids:)` / `Up` / `Down` / `Bottom` | Reorder torrent queue      |
| `groupGet(name:)` / `groupSet(_:)`              | Manage bandwidth groups    |

## Convenience Methods

```swift
// Get all torrents with common fields
let all = try await client.torrents()

// Find a torrent by hash
let torrent = try await client.torrent(byHash: "abc123...")

// Quick batch operations
try await client.startAll()
try await client.stopAll()
```

## Torrent ID Selectors

Use the `TorrentID` type to target specific torrents:

```swift
// Single torrent by numeric ID
client.torrentStart(.single(1))

// Multiple torrents by ID or hash
client.torrentStop(.multiple([.id(1), .id(3), .hash("abc123")]))

// Recently active torrents
client.torrentGet(ids: .recentlyActive, fields: [.name, .status])

// All torrents (omit ids)
client.torrentStart(nil)
```

## License

MIT — see [LICENSE](LICENSE)
