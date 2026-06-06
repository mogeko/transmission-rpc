import Foundation

// MARK: - Torrent Add Request

/// Request parameters for `torrent-add`.
///
/// Either `filename` (URL or path) or `metainfo` (base64-encoded .torrent data)
/// must be provided.
public struct TorrentAddRequest: Codable, Sendable {
  /// URL or local path to a `.torrent` file.
  public let filename: String?
  /// Base64-encoded `.torrent` file data.
  public let metainfo: String?
  /// Directory to download the torrent to.
  public let downloadDir: String?
  /// Labels to assign to the new torrent.
  public let labels: [String]?
  /// Cookies for the tracker, formatted as `"name1=value1; name2=value2;"`.
  public let cookies: String?
  /// Whether to add the torrent in a paused state.
  public let paused: Bool?
  public let peerLimit: Int?
  public let bandwidthPriority: Int?
  public let filesWanted: [Int]?
  public let filesUnwanted: [Int]?
  public let priorityHigh: [Int]?
  public let priorityLow: [Int]?
  public let priorityNormal: [Int]?
  public let sequentialDownload: Bool?
  public let sequentialDownloadFromPiece: Int?

  public init(
    filename: String? = nil,
    metainfo: String? = nil,
    downloadDir: String? = nil,
    labels: [String]? = nil,
    cookies: String? = nil,
    paused: Bool? = nil,
    peerLimit: Int? = nil,
    bandwidthPriority: Int? = nil,
    filesWanted: [Int]? = nil,
    filesUnwanted: [Int]? = nil,
    priorityHigh: [Int]? = nil,
    priorityLow: [Int]? = nil,
    priorityNormal: [Int]? = nil,
    sequentialDownload: Bool? = nil,
    sequentialDownloadFromPiece: Int? = nil
  ) {
    self.filename = filename
    self.metainfo = metainfo
    self.downloadDir = downloadDir
    self.labels = labels
    self.cookies = cookies
    self.paused = paused
    self.peerLimit = peerLimit
    self.bandwidthPriority = bandwidthPriority
    self.filesWanted = filesWanted
    self.filesUnwanted = filesUnwanted
    self.priorityHigh = priorityHigh
    self.priorityLow = priorityLow
    self.priorityNormal = priorityNormal
    self.sequentialDownload = sequentialDownload
    self.sequentialDownloadFromPiece = sequentialDownloadFromPiece
  }

  enum CodingKeys: String, CodingKey {
    case filename
    case metainfo
    case downloadDir = "download_dir"
    case labels
    case cookies
    case paused
    case peerLimit = "peer_limit"
    case bandwidthPriority = "bandwidth_priority"
    case filesWanted = "files_wanted"
    case filesUnwanted = "files_unwanted"
    case priorityHigh = "priority_high"
    case priorityLow = "priority_low"
    case priorityNormal = "priority_normal"
    case sequentialDownload = "sequential_download"
    case sequentialDownloadFromPiece = "sequential_download_from_piece"
  }
}

// MARK: - Torrent Add Response

/// The response from `torrent-add`.
public struct TorrentAddResponse: Codable, Sendable {
  /// The added torrent, if no duplicate was found.
  public let torrentAdded: TorrentAdded?
  /// The duplicate torrent, if one was found.
  public let torrentDuplicate: TorrentAdded?

  enum CodingKeys: String, CodingKey {
    case torrentAdded = "torrent_added"
    case torrentDuplicate = "torrent_duplicate"
  }
}

/// Information about a newly added or duplicate torrent.
public struct TorrentAdded: Codable, Sendable {
  public let id: Int?
  public let name: String?
  public let hashString: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case hashString = "hash_string"
  }
}
