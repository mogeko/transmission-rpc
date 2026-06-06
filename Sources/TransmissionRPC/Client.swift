import Foundation

// MARK: - RPC Client

/// A client for communicating with a Transmission BitTorrent client via its RPC interface.
///
/// The client manages the HTTP session, CSRF token exchange
/// (`X-Transmission-Session-Id` header), and JSON-RPC request/response
/// serialization.
///
/// ## Usage
/// ```swift
/// let client = Client(baseURL: URL(string: "http://localhost:9091")!)
/// let session = try await client.sessionGet()
/// ```
public actor Client {
  // MARK: - Properties

  /// The base URL of the Transmission web interface
  /// (e.g. `http://localhost:9091`).
  public let baseURL: URL

  /// The `URLSession` used for HTTP requests.
  private let session: URLSession

  /// The JSON encoder used for request serialization.
  private let encoder: JSONEncoder

  /// The JSON decoder used for response deserialization.
  private let decoder: JSONDecoder

  /// The current CSRF session identifier, obtained via the
  /// `X-Transmission-Session-Id` header exchange.
  private var sessionId: String?

  /// A monotonically increasing tag for correlating requests and responses.
  private var nextTag: Int = 0

  // MARK: - Initialization

  /// Creates a new Transmission RPC client.
  ///
  /// - Parameters:
  ///   - baseURL: The base URL of the Transmission web interface.
  ///   - session: The `URLSession` to use. Defaults to `.shared`.
  public init(baseURL: URL, session: URLSession = .shared) {
    self.baseURL = baseURL
    self.session = session
    self.encoder = JSONEncoder()
    self.decoder = JSONDecoder()
  }

  // MARK: - Core RPC Method

  /// Performs a Transmission RPC request and returns the decoded method-specific arguments.
  ///
  /// This method handles:
  /// 1. JSON encoding the request body
  /// 2. POSTing to `/transmission/rpc`
  /// 3. CSRF token exchange (HTTP 409 → extract `X-Transmission-Session-Id` → retry)
  /// 4. Decoding the JSON-RPC response envelope
  /// 5. Extracting and returning the method-specific `arguments`
  ///
  /// - Parameter request: The RPC request to send.
  /// - Returns: The method-specific response arguments decoded as `Args`.
  func perform<Params: Encodable, Args: Decodable>(
    _ request: RPCRequest<Params>
  ) async throws -> Args {
    let url = baseURL.appendingPathComponent("transmission/rpc")
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Attach session ID if known
    if let sessionId = sessionId {
      urlRequest.setValue(sessionId, forHTTPHeaderField: "X-Transmission-Session-Id")
    }

    // Encode request body
    do {
      urlRequest.httpBody = try encoder.encode(request)
    } catch {
      throw TransmissionError.encodingFailed(error)
    }

    // Perform the HTTP request
    let (data, response) = try await session.data(for: urlRequest)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw TransmissionError.unexpectedResponse
    }

    // Handle 409 Conflict — CSRF token exchange
    if httpResponse.statusCode == 409 {
      guard
        let newSessionId = httpResponse.value(
          forHTTPHeaderField: "X-Transmission-Session-Id"
        )
      else {
        throw TransmissionError.httpError(statusCode: 409)
      }
      self.sessionId = newSessionId

      // Retry with the new session ID
      urlRequest.setValue(newSessionId, forHTTPHeaderField: "X-Transmission-Session-Id")
      let (retryData, retryResponse) = try await session.data(for: urlRequest)

      guard let retryHttpResponse = retryResponse as? HTTPURLResponse else {
        throw TransmissionError.unexpectedResponse
      }
      guard retryHttpResponse.statusCode == 200 else {
        throw TransmissionError.httpError(statusCode: retryHttpResponse.statusCode)
      }
      return try decodeResponse(retryData)
    }

    guard httpResponse.statusCode == 200 else {
      throw TransmissionError.httpError(statusCode: httpResponse.statusCode)
    }

    return try decodeResponse(data)
  }

  // MARK: - Private Helpers

  /// Returns the next monotonically increasing tag value.
  private func nextTagValue() -> Int {
    nextTag += 1
    return nextTag
  }

  /// Decodes the JSON-RPC response and extracts the method-specific arguments.
  private func decodeResponse<Args: Decodable>(_ data: Data) throws -> Args {
    let rpcResponse: RPCResponse<RPCResult<Args>>
    do {
      rpcResponse = try decoder.decode(RPCResponse<RPCResult<Args>>.self, from: data)
    } catch {
      throw TransmissionError.decodingFailed(error)
    }

    // Check for JSON-RPC error
    if let rpcError = rpcResponse.error {
      throw TransmissionError.rpcError(rpcError)
    }

    // Extract the Transmission result wrapper
    guard let transmissionResult = rpcResponse.result else {
      throw TransmissionError.unexpectedResponse
    }

    // Check Transmission-level result status
    guard transmissionResult.result == "success" else {
      throw TransmissionError.resultFailure(transmissionResult.result)
    }

    // Extract the method-specific arguments
    guard let arguments = transmissionResult.arguments else {
      throw TransmissionError.missingArguments
    }

    return arguments
  }

  // MARK: - Request Builder

  /// Creates an `RPCRequest` for the given method and parameters, with an auto-incrementing tag.
  func makeRequest<Params: Encodable>(
    method: String,
    params: Params?
  ) -> RPCRequest<Params> {
    let tag = nextTagValue()
    return RPCRequest(method: method, params: params, id: tag)
  }

  /// Creates an `RPCRequest` for a method with no parameters.
  func makeRequest(method: String) -> RPCRequest<EmptyParams> {
    let tag = nextTagValue()
    return RPCRequest(method: method, params: EmptyParams?.none, id: tag)
  }
}

// MARK: - Torrent Actions

extension Client {
  /// Starts one or more torrents.
  ///
  /// - Parameter ids: The torrent ID(s) to start. `nil` means all torrents.
  public func torrentStart(_ ids: TorrentID? = nil) async throws {
    let request = makeRequest(
      method: "torrent-start",
      params: ids.map { TorrentActionRequest(ids: $0) }
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Starts one or more torrents immediately, bypassing the queue.
  ///
  /// - Parameter ids: The torrent ID(s) to start. `nil` means all torrents.
  public func torrentStartNow(_ ids: TorrentID? = nil) async throws {
    let request = makeRequest(
      method: "torrent-start-now",
      params: ids.map { TorrentActionRequest(ids: $0) }
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Stops one or more torrents.
  ///
  /// - Parameter ids: The torrent ID(s) to stop. `nil` means all torrents.
  public func torrentStop(_ ids: TorrentID? = nil) async throws {
    let request = makeRequest(
      method: "torrent-stop",
      params: ids.map { TorrentActionRequest(ids: $0) }
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Verifies the local data of one or more torrents.
  ///
  /// - Parameter ids: The torrent ID(s) to verify. `nil` means all torrents.
  public func torrentVerify(_ ids: TorrentID? = nil) async throws {
    let request = makeRequest(
      method: "torrent-verify",
      params: ids.map { TorrentActionRequest(ids: $0) }
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Asks the tracker for more peers for one or more torrents.
  ///
  /// - Parameter ids: The torrent ID(s) to reannounce. `nil` means all torrents.
  public func torrentReannounce(_ ids: TorrentID? = nil) async throws {
    let request = makeRequest(
      method: "torrent-reannounce",
      params: ids.map { TorrentActionRequest(ids: $0) }
    )
    let _: EmptyParams = try await perform(request)
  }
}

// MARK: - Torrent Accessor

extension Client {
  /// Retrieves information about one or more torrents.
  ///
  /// - Parameters:
  ///   - ids: The torrent ID(s) to retrieve. `nil` means all torrents.
  ///   - fields: The fields to include in each torrent object.
  ///   - format: The response format. Defaults to `.objects`.
  /// - Returns: A response containing the requested torrent objects.
  public func torrentGet(
    ids: TorrentID? = nil,
    fields: [TorrentFields]? = nil,
    format: TorrentGetFormat? = nil
  ) async throws -> TorrentGetResponse {
    let request = makeRequest(
      method: "torrent-get",
      params: TorrentGetRequest(ids: ids, fields: fields, format: format)
    )
    return try await perform(request)
  }
}

// MARK: - Torrent Mutator

extension Client {
  /// Modifies properties of one or more torrents.
  ///
  /// Only the fields set in the request will be modified;
  /// unset fields remain unchanged.
  ///
  /// - Parameter request: The modifications to apply.
  public func torrentSet(_ request: TorrentSetRequest) async throws {
    let rpcRequest = makeRequest(method: "torrent-set", params: request)
    let _: EmptyParams = try await perform(rpcRequest)
  }
}

// MARK: - Torrent Add / Remove / Location / Rename

extension Client {
  /// Adds a new torrent.
  ///
  /// Either `filename` (URL or path to a `.torrent` file) or
  /// `metainfo` (base64-encoded torrent data) must be provided
  /// in the request.
  ///
  /// - Parameter request: The add request parameters.
  /// - Returns: Information about the added (or duplicate) torrent.
  public func torrentAdd(_ request: TorrentAddRequest) async throws -> TorrentAddResponse {
    let rpcRequest = makeRequest(method: "torrent-add", params: request)
    return try await perform(rpcRequest)
  }

  /// Removes one or more torrents.
  ///
  /// - Parameters:
  ///   - ids: The torrent ID(s) to remove.
  ///   - deleteLocalData: Whether to delete local data as well. Defaults to `false`.
  public func torrentRemove(ids: TorrentID, deleteLocalData: Bool = false) async throws {
    let request = makeRequest(
      method: "torrent-remove",
      params: TorrentRemoveRequest(ids: ids, deleteLocalData: deleteLocalData)
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Moves one or more torrents to a new download directory.
  ///
  /// - Parameters:
  ///   - ids: The torrent ID(s) to move.
  ///   - location: The new download directory.
  ///   - move: Whether to move data from the previous location. Defaults to `false`.
  public func torrentSetLocation(
    ids: TorrentID,
    location: String,
    move: Bool = false
  ) async throws {
    let request = makeRequest(
      method: "torrent-set-location",
      params: TorrentSetLocationRequest(ids: ids, location: location, move: move)
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Renames a file or directory within a torrent.
  ///
  /// - Parameters:
  ///   - ids: Must identify exactly one torrent.
  ///   - path: The path to the file or directory to rename.
  ///   - name: The new name.
  /// - Returns: The renamed path details.
  public func torrentRenamePath(
    ids: TorrentID,
    path: String,
    name: String
  ) async throws -> TorrentRenamePathResponse {
    let request = makeRequest(
      method: "torrent-rename-path",
      params: TorrentRenamePathRequest(ids: ids, path: path, name: name)
    )
    return try await perform(request)
  }
}

// MARK: - Session Methods

extension Client {
  /// Retrieves session information.
  ///
  /// - Parameter fields: The session fields to retrieve. `nil` means all fields.
  /// - Returns: The session information.
  public func sessionGet(fields: [String]? = nil) async throws -> Session {
    let request = makeRequest(
      method: "session-get",
      params: SessionGetRequest(fields: fields)
    )
    return try await perform(request)
  }

  /// Modifies session settings.
  ///
  /// Only the fields set in the request will be modified;
  /// unset fields remain unchanged.
  ///
  /// - Parameter request: The session modifications to apply.
  public func sessionSet(_ request: SessionSetRequest) async throws {
    let rpcRequest = makeRequest(method: "session-set", params: request)
    let _: EmptyParams = try await perform(rpcRequest)
  }

  /// Retrieves session statistics.
  ///
  /// - Returns: Current session statistics.
  public func sessionStats() async throws -> SessionStats {
    let request = makeRequest(method: "session-stats")
    return try await perform(request)
  }

  /// Closes the current session.
  public func sessionClose() async throws {
    let request = makeRequest(method: "session-close")
    let _: EmptyParams = try await perform(request)
  }
}

// MARK: - Blocklist / Port / Queue / Free Space / Groups

extension Client {
  /// Updates the blocklist.
  ///
  /// - Returns: The new blocklist size.
  public func blocklistUpdate() async throws -> BlocklistUpdateResponse {
    let request = makeRequest(method: "blocklist-update")
    return try await perform(request)
  }

  /// Tests the port for incoming connections.
  ///
  /// - Parameter ipProtocol: The IP protocol to test. `nil` for default.
  /// - Returns: The port test result.
  public func portTest(ipProtocol: IPProtocol? = nil) async throws -> PortTestResponse {
    let request = makeRequest(
      method: "port-test",
      params: PortTestRequest(ipProtocol: ipProtocol)
    )
    return try await perform(request)
  }

  /// Moves a torrent to the top of the queue.
  public func queueMoveTop(ids: TorrentID) async throws {
    let request = makeRequest(
      method: "queue-move-top",
      params: QueueMovementRequest(ids: ids)
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Moves a torrent up in the queue.
  public func queueMoveUp(ids: TorrentID) async throws {
    let request = makeRequest(
      method: "queue-move-up",
      params: QueueMovementRequest(ids: ids)
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Moves a torrent down in the queue.
  public func queueMoveDown(ids: TorrentID) async throws {
    let request = makeRequest(
      method: "queue-move-down",
      params: QueueMovementRequest(ids: ids)
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Moves a torrent to the bottom of the queue.
  public func queueMoveBottom(ids: TorrentID) async throws {
    let request = makeRequest(
      method: "queue-move-bottom",
      params: QueueMovementRequest(ids: ids)
    )
    let _: EmptyParams = try await perform(request)
  }

  /// Checks available free space at a given path.
  ///
  /// - Parameter path: The directory path to check.
  /// - Returns: Free space information.
  public func freeSpace(path: String) async throws -> FreeSpaceResponse {
    let request = makeRequest(
      method: "free-space",
      params: FreeSpaceRequest(path: path)
    )
    return try await perform(request)
  }

  /// Retrieves bandwidth group configurations.
  ///
  /// - Parameter name: The group name or array of names. `nil` for all.
  /// - Returns: The requested bandwidth groups.
  public func groupGet(name: String? = nil) async throws -> [BandwidthGroup] {
    let request = makeRequest(
      method: "group-get",
      params: GroupGetRequest(name: name)
    )
    let response: GroupGetResponse = try await perform(request)
    return response.group ?? []
  }

  /// Modifies a bandwidth group.
  ///
  /// - Parameter request: The group modifications to apply.
  public func groupSet(_ request: GroupSetRequest) async throws {
    let rpcRequest = makeRequest(method: "group-set", params: request)
    let _: EmptyParams = try await perform(rpcRequest)
  }
}

// MARK: - Empty Params

/// A sentinel type for RPC methods that take no parameters or return no arguments.
struct EmptyParams: Codable {}
