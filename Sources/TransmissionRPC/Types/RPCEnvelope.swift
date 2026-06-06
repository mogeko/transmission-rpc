import Foundation

// MARK: - JSON-RPC 2.0 Request

/// A JSON-RPC 2.0 request sent to the Transmission RPC endpoint.
/// Transmission 4.1.0+ (rpc_version_semver 6.0.0) uses standard JSON-RPC 2.0.
struct RPCRequest<Params: Encodable>: Encodable {
  let jsonrpc = "2.0"
  let method: String
  let params: Params?
  let id: Int?
}

// MARK: - JSON-RPC 2.0 Response

/// Top-level JSON-RPC 2.0 response from the Transmission server.
struct RPCResponse<T: Decodable>: Decodable {
  let result: T?
  let error: RPCError?
  let id: Int?
}

// MARK: - Transmission RPC Result

/// The Transmission-specific result wrapper inside the JSON-RPC `result` field.
///
/// Transmission wraps method responses as:
/// ```json
/// {"result": "success", "arguments": {...}, "tag": 1}
/// ```
struct RPCResult<Arguments: Decodable>: Decodable {
  let result: String
  let arguments: Arguments?
  let tag: Int?
}

// MARK: - JSON-RPC Error

/// A JSON-RPC 2.0 error returned by the Transmission server.
public struct RPCError: Decodable, Swift.Error {
  public let code: Int
  public let message: String
  public let data: RPCErrorData?
}

/// Additional error data from the Transmission server.
public struct RPCErrorData: Decodable {
  public let errorString: String?
  enum CodingKeys: String, CodingKey {
    case errorString = "error_string"
  }
}

// MARK: - Transmission Error

/// Errors specific to the Transmission RPC client.
public enum TransmissionError: Swift.Error {
  /// The server returned a non-success HTTP status code.
  case httpError(statusCode: Int)
  /// The RPC response contained an error.
  case rpcError(RPCError)
  /// The RPC `result` field was `"success"` but `arguments` was missing.
  case missingArguments
  /// The RPC `result` field indicated a non-success result.
  case resultFailure(String)
  /// Failed to decode the response.
  case decodingFailed(Swift.Error)
  /// The request encoding failed.
  case encodingFailed(Swift.Error)
  /// An unexpected response format was received.
  case unexpectedResponse
}
