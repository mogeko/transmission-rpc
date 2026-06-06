import Foundation

// MARK: - Torrent Set Request

/// Request parameters for `torrent-set`.
///
/// All fields are optional. Only non-nil fields are sent
/// to the server; other fields remain unchanged.
public struct TorrentSetRequest: Codable, Sendable {
  /// The torrent ID(s) to modify.
  public let ids: TorrentID?
  public let bandwidthPriority: Int?
  public let downloadLimit: Int?
  public let downloadLimited: Bool?
  public let filesUnwanted: [Int]?
  public let filesWanted: [Int]?
  public let group: String?
  public let honorsSessionLimits: Bool?
  public let labels: [String]?
  public let location: String?
  public let peerLimit: Int?
  public let priorityHigh: [Int]?
  public let priorityLow: [Int]?
  public let priorityNormal: [Int]?
  public let queuePosition: Int?
  public let seedIdleLimit: Int?
  public let seedIdleMode: Int?
  public let seedRatioLimit: Double?
  public let seedRatioMode: Int?
  public let sequentialDownload: Bool?
  public let sequentialDownloadFromPiece: Int?
  public let trackerList: String?
  public let uploadLimit: Int?
  public let uploadLimited: Bool?

  public init(
    ids: TorrentID? = nil,
    bandwidthPriority: Int? = nil,
    downloadLimit: Int? = nil,
    downloadLimited: Bool? = nil,
    filesUnwanted: [Int]? = nil,
    filesWanted: [Int]? = nil,
    group: String? = nil,
    honorsSessionLimits: Bool? = nil,
    labels: [String]? = nil,
    location: String? = nil,
    peerLimit: Int? = nil,
    priorityHigh: [Int]? = nil,
    priorityLow: [Int]? = nil,
    priorityNormal: [Int]? = nil,
    queuePosition: Int? = nil,
    seedIdleLimit: Int? = nil,
    seedIdleMode: Int? = nil,
    seedRatioLimit: Double? = nil,
    seedRatioMode: Int? = nil,
    sequentialDownload: Bool? = nil,
    sequentialDownloadFromPiece: Int? = nil,
    trackerList: String? = nil,
    uploadLimit: Int? = nil,
    uploadLimited: Bool? = nil
  ) {
    self.ids = ids
    self.bandwidthPriority = bandwidthPriority
    self.downloadLimit = downloadLimit
    self.downloadLimited = downloadLimited
    self.filesUnwanted = filesUnwanted
    self.filesWanted = filesWanted
    self.group = group
    self.honorsSessionLimits = honorsSessionLimits
    self.labels = labels
    self.location = location
    self.peerLimit = peerLimit
    self.priorityHigh = priorityHigh
    self.priorityLow = priorityLow
    self.priorityNormal = priorityNormal
    self.queuePosition = queuePosition
    self.seedIdleLimit = seedIdleLimit
    self.seedIdleMode = seedIdleMode
    self.seedRatioLimit = seedRatioLimit
    self.seedRatioMode = seedRatioMode
    self.sequentialDownload = sequentialDownload
    self.sequentialDownloadFromPiece = sequentialDownloadFromPiece
    self.trackerList = trackerList
    self.uploadLimit = uploadLimit
    self.uploadLimited = uploadLimited
  }

  enum CodingKeys: String, CodingKey {
    case ids
    case bandwidthPriority = "bandwidth_priority"
    case downloadLimit = "download_limit"
    case downloadLimited = "download_limited"
    case filesUnwanted = "files_unwanted"
    case filesWanted = "files_wanted"
    case group
    case honorsSessionLimits = "honors_session_limits"
    case labels
    case location
    case peerLimit = "peer_limit"
    case priorityHigh = "priority_high"
    case priorityLow = "priority_low"
    case priorityNormal = "priority_normal"
    case queuePosition = "queue_position"
    case seedIdleLimit = "seed_idle_limit"
    case seedIdleMode = "seed_idle_mode"
    case seedRatioLimit = "seed_ratio_limit"
    case seedRatioMode = "seed_ratio_mode"
    case sequentialDownload = "sequential_download"
    case sequentialDownloadFromPiece = "sequential_download_from_piece"
    case trackerList = "tracker_list"
    case uploadLimit = "upload_limit"
    case uploadLimited = "upload_limited"
  }
}
