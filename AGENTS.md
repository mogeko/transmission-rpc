# AGENTS.md

## Project Overview

A Swift library implementing the [Transmission RPC specification](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md). Provides Swift-native types and networking to interact with Transmission BitTorrent clients via their JSON-RPC API.

## Build & Test

This project uses **Swift Package Manager**.

```bash
swift build          # Build the library
swift test           # Run tests
swift package format # Format source code (if swift-format is configured)
```

## Architecture Conventions

### Package Structure (planned)

```
Sources/Transmission-rpc/   # Library source
  ├── Client.swift           # Main RPC client
  ├── Types/                 # Request/response models
  ├── Methods/               # RPC method implementations
  └── Extensions/            # Convenience APIs
Tests/Transmission-rpcTests/ # Unit tests
```

### Key Principles

- **All RPC types must be `Codable`** — Transmission uses JSON-RPC, so serialization is fundamental.
- **Use `async/await`** — All networking calls should be Swift concurrency-based.
- **Method chaining** — Provide both low-level RPC calls and high-level convenience APIs.
- **Thread safety** — The RPC client should be safe to use across concurrent tasks (`Sendable`).

### Dependencies

- **`swift-argument-parser`** — For any CLI tooling
- **`async-http-client`** or **`URLSession`** — For HTTP networking (prefer `URLSession` to minimize dependencies)

## Code Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Prefer `struct` over `class` unless reference semantics are needed
- Use `let` by default; `var` only when mutation is required
- Mark types and methods as `public` explicitly (Swift Package Manager defaults to `internal`)

## Transmission RPC Notes

- The RPC endpoint is typically at `/transmission/rpc` on the host
- Session IDs are passed via `X-Transmission-Session-Id` header
- Fields omitted in responses mean "unchanged"; use `Optional` in Swift models
- The spec uses a mix of underscore_case (RPC fields) and camelCase — we map to Swift conventions via `CodingKeys`
