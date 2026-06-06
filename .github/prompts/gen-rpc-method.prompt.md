---
description: "Generate Swift Codable types and async RPC method for a Transmission RPC method. Use when: implementing a new RPC method from the Transmission spec, creating request/response models, or adding RPC endpoints."
name: "Generate RPC Method"
argument-hint: "RPC method name or spec URL..."
agent: "agent"
---

Generate a complete implementation for a Transmission RPC method. Follow the conventions in [AGENTS.md](../../AGENTS.md).

For the given Transmission RPC method, produce:

## 1. Request Model (`Sources/transmission-rpc/Types/`)

A `Codable` struct with all documented request arguments as `Optional` properties. Use `CodingKeys` to map Transmission's underscore_case field names to Swift camelCase.

```swift
public struct MethodNameRequest: Codable, Sendable {
    public let fieldName: Type?  // Optional when the spec says it can be omitted

    enum CodingKeys: String, CodingKey {
        case fieldName = "field-name"
    }
}
```

## 2. Response Model (if response is nontrivial)

A `Codable` struct for the method's `arguments` payload. Fields absent in the response map to `Optional` in Swift (omitted = unchanged).

```swift
public struct MethodNameResponse: Codable, Sendable {
    public let resultField: Type?
}
```

## 3. RPC Method (`Sources/transmission-rpc/Methods/`)

An `async throws` method on the RPC client that:
- Constructs a JSON-RPC request body (`method` + `arguments`)
- Calls the `/transmission/rpc` endpoint
- Handles `X-Transmission-Session-Id` header (409 Conflict → retry with session ID)
- Decodes the response into the response model

```swift
public func methodName(_ request: MethodNameRequest) async throws -> MethodNameResponse {
    // ... RPC call implementation
}
```

## Key Rules

- All types must be `public`, `Codable`, and `Sendable`
- Use `Optional` for any field that the Transmission spec marks as omissible or "unchanged in response"
- Map underscore_case → camelCase via `CodingKeys` enum
- Use `async/await` and `URLSession` for networking
- Handle the session ID header exchange automatically
