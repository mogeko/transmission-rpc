---
description: "Use when writing or editing Swift source files that involve Codable types, JSON-RPC serialization, Transmission RPC models, or network request/response types. Covers CodingKeys conventions, Optional field handling, and async/await networking patterns specific to this project."
applyTo: "Sources/**/*.swift"
---

# Transmission RPC Swift Conventions

This project is a Swift library for the [Transmission RPC specification](https://github.com/transmission/transmission/blob/main/docs/rpc-spec.md). See [AGENTS.md](../../AGENTS.md) for the full project overview.

## CodingKeys Convention

Transmission RPC uses `underscore_case` (e.g., `peer-limit`, `seed_ratio_mode`). Map to Swift `camelCase` via `CodingKeys`:

```swift
public struct TorrentActionRequest: Codable, Sendable {
    public let ids: [Int]?
    public let peerLimit: Int?

    enum CodingKeys: String, CodingKey {
        case ids
        case peerLimit = "peer-limit"
    }
}
```

- **Only define CodingKeys for fields whose JSON key differs from the Swift name.**
- **Use `String` raw value type** for CodingKeys enum.

## Optional Semantics

Transmission omits fields from responses to indicate "unchanged." **Always use `Optional`** for response model properties — never assume a field will always be present.

```swift
// CORRECT: Optional; field may be absent meaning "unchanged"
public struct TorrentInfo: Codable, Sendable {
    public let name: String?          // Always present for this field, but be explicit
    public let comment: String?       // May be omitted = "unchanged"
    public let peerLimit: Int?        // May be omitted = "unchanged"
}

// WRONG: Non-optional assumes field always exists
public struct TorrentInfo: Codable, Sendable {
    public let name: String           // Will crash if field is missing
}
```

For request models, use `Optional` when the argument is optional per the spec; `nil` values are omitted during encoding.

## JSON-RPC Envelope

All RPC calls wrap their payload in a standard JSON-RPC 2.0 envelope:

```swift
struct RPCRequest: Codable {
    let method: String
    let arguments: Encodable?  // method-specific payload
    let tag: Int?
}
```

The response envelope:

```swift
struct RPCResponse<T: Decodable>: Decodable {
    let result: String         // "success" or error
    let arguments: T?          // method-specific payload
    let tag: Int?
}
```

## Sendable & Thread Safety

All types shared across concurrency domains must be `Sendable`:

- `struct` with only `Sendable` properties is implicitly `Sendable`
- Mark all `public` types explicitly: `public struct Foo: Codable, Sendable`

## Networking Pattern

RPC methods follow this pattern:

```swift
func performRequest<T: Decodable>(_ request: RPCRequest) async throws -> T {
    // 1. Encode request body
    // 2. POST to /transmission/rpc
    // 3. If 409 Conflict → extract X-Transmission-Session-Id, retry once
    // 4. Decode RPCResponse<T>, check result == "success"
    // 5. Return arguments
}
```
