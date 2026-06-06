import Foundation

// MARK: - Torrent Remove Request

/// Request parameters for `torrent-remove`.
public struct TorrentRemoveRequest: Codable, Sendable {
  /// The torrent ID(s) to remove.
  public let ids: TorrentID
  /// Whether to delete local data as well.
  public let deleteLocalData: Bool?

  public init(ids: TorrentID, deleteLocalData: Bool? = nil) {
    self.ids = ids
    self.deleteLocalData = deleteLocalData
  }

  enum CodingKeys: String, CodingKey {
    case ids
    case deleteLocalData = "delete_local_data"
  }
}

// MARK: - Torrent Set Location Request

/// Request parameters for `torrent-set-location`.
public struct TorrentSetLocationRequest: Codable, Sendable {
  /// The torrent ID(s) to move.
  public let ids: TorrentID
  /// The new download directory.
  public let location: String
  /// Whether to move data from the previous location.
  public let move: Bool?

  public init(ids: TorrentID, location: String, move: Bool? = nil) {
    self.ids = ids
    self.location = location
    self.move = move
  }
}

// MARK: - Torrent Rename Path Request

/// Request parameters for `torrent-rename-path`.
public struct TorrentRenamePathRequest: Codable, Sendable {
  /// Must identify exactly one torrent.
  public let ids: TorrentID
  /// The path to the file or directory to rename.
  public let path: String
  /// The new name.
  public let name: String

  public init(ids: TorrentID, path: String, name: String) {
    self.ids = ids
    self.path = path
    self.name = name
  }
}

// MARK: - Torrent Rename Path Response

/// The response from `torrent-rename-path`.
public struct TorrentRenamePathResponse: Codable, Sendable {
  public let id: Int?
  public let path: String?
  public let name: String?
}
