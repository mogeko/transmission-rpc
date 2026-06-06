import Foundation

// MARK: - Convenience Methods

extension Client {
  /// Retrieves all torrents with the specified fields.
  ///
  /// - Parameter fields: The fields to include. Defaults to common fields.
  /// - Returns: An array of torrent info objects.
  public func torrents(
    fields: [TorrentFields] = [
      .id, .name, .status, .percentDone, .rateDownload,
      .rateUpload, .totalSize, .sizeWhenDone, .eta,
      .hashString, .addedDate, .downloadDir,
    ]
  ) async throws -> [TorrentInfo] {
    let response = try await torrentGet(fields: fields)
    return response.torrents ?? []
  }

  /// Finds a torrent by its hash string.
  ///
  /// - Parameter hash: The torrent hash string.
  /// - Returns: The matching torrent, or `nil` if not found.
  public func torrent(byHash hash: String) async throws -> TorrentInfo? {
    let response = try await torrentGet(
      ids: .multiple([.hash(hash)]),
      fields: [
        .id, .name, .status, .percentDone, .rateDownload,
        .rateUpload, .totalSize, .sizeWhenDone, .eta,
        .hashString, .addedDate, .downloadDir,
      ]
    )
    return response.torrents?.first
  }

  /// Starts all torrents.
  public func startAll() async throws {
    try await torrentStart(nil)
  }

  /// Stops all torrents.
  public func stopAll() async throws {
    try await torrentStop(nil)
  }

  /// Adds a torrent from a URL.
  ///
  /// - Parameters:
  ///   - url: The URL of the `.torrent` file or magnet link.
  ///   - downloadDir: Optional download directory.
  ///   - paused: Whether to add in a paused state.
  ///   - labels: Optional labels to assign.
  /// - Returns: Information about the added torrent.
  public func addTorrent(
    url: URL,
    downloadDir: String? = nil,
    paused: Bool = false,
    labels: [String]? = nil
  ) async throws -> TorrentAddResponse {
    let request = TorrentAddRequest(
      filename: url.absoluteString,
      downloadDir: downloadDir,
      labels: labels,
      paused: paused
    )
    return try await torrentAdd(request)
  }

  /// Adds a torrent from base64-encoded `.torrent` data.
  ///
  /// - Parameters:
  ///   - metainfo: Base64-encoded `.torrent` file data.
  ///   - downloadDir: Optional download directory.
  ///   - paused: Whether to add in a paused state.
  ///   - labels: Optional labels to assign.
  /// - Returns: Information about the added torrent.
  public func addTorrent(
    metainfo: String,
    downloadDir: String? = nil,
    paused: Bool = false,
    labels: [String]? = nil
  ) async throws -> TorrentAddResponse {
    let request = TorrentAddRequest(
      metainfo: metainfo,
      downloadDir: downloadDir,
      labels: labels,
      paused: paused
    )
    return try await torrentAdd(request)
  }
}
