import Foundation

// MARK: - Torrent Get Request

/// Request parameters for `torrent-get`.
public struct TorrentGetRequest: Codable, Sendable {
  /// The torrent ID(s) to retrieve. `nil` means all torrents.
  public let ids: TorrentID?
  /// The fields to include in each torrent object.
  public let fields: [TorrentFields]?
  /// The response format. Defaults to `.objects`.
  public let format: TorrentGetFormat?

  public init(
    ids: TorrentID? = nil,
    fields: [TorrentFields]? = nil,
    format: TorrentGetFormat? = nil
  ) {
    self.ids = ids
    self.fields = fields
    self.format = format
  }
}

// MARK: - Torrent Get Format

/// The response format for `torrent-get`.
public enum TorrentGetFormat: String, Codable, Sendable {
  /// Each torrent returned as an object keyed by field name.
  case objects
  /// Torrents returned as a table: first row = keys, remaining rows = values.
  case table
}

// MARK: - Torrent Get Response

/// The response from `torrent-get`.
public struct TorrentGetResponse: Codable, Sendable {
  /// The requested torrent objects.
  public let torrents: [TorrentInfo]?
  /// Torrent IDs that were removed (when `ids` is `recently_active`).
  public let removed: [Int]?
}

// MARK: - Torrent Info

/// Full information about a torrent, as returned by `torrent-get`.
///
/// All fields are optional because Transmission omits fields
/// that were not requested via the `fields` parameter.
public struct TorrentInfo: Codable, Sendable {
  public let activityDate: Int?
  public let addedDate: Int?
  public let availability: [Double]?
  public let bandwidthPriority: Int?
  public let bytesCompleted: [Int]?
  public let comment: String?
  public let corruptEver: Int?
  public let creator: String?
  public let dateCreated: Int?
  public let desiredAvailable: Int?
  public let doneDate: Int?
  public let downloadDir: String?
  public let downloadLimit: Int?
  public let downloadLimited: Bool?
  public let editDate: Int?
  public let error: Int?
  public let errorString: String?
  public let eta: Int?
  public let etaIdle: Int?
  public let fileCount: Int?
  public let files: [File]?
  public let fileStats: [FileStats]?
  public let group: String?
  public let hashString: String?
  public let haveUnchecked: Int?
  public let haveValid: Int?
  public let honorsSessionLimits: Bool?
  public let id: Int?
  public let isFinished: Bool?
  public let isPrivate: Bool?
  public let isStalled: Bool?
  public let labels: [String]?
  public let leftUntilDone: Int?
  public let magnetLink: String?
  public let maxConnectedPeers: Int?
  public let metadataPercentComplete: Double?
  public let name: String?
  public let peerLimit: Int?
  public let peers: [Peer]?
  public let peersConnected: Int?
  public let peersFrom: PeerFrom?
  public let peersGettingFromUs: Int?
  public let peersSendingToUs: Int?
  public let percentComplete: Double?
  public let percentDone: Double?
  public let pieces: String?
  public let pieceCount: Int?
  public let pieceSize: Int?
  public let priorities: [Int]?
  public let primaryMimeType: String?
  public let queuePosition: Int?
  public let rateDownload: Int?
  public let rateUpload: Int?
  public let recheckProgress: Double?
  public let secondsDownloading: Int?
  public let secondsSeeding: Int?
  public let seedIdleLimit: Int?
  public let seedIdleMode: Int?
  public let seedRatioLimit: Double?
  public let seedRatioMode: Int?
  public let sequentialDownload: Bool?
  public let sequentialDownloadFromPiece: Int?
  public let sizeWhenDone: Int?
  public let startDate: Int?
  public let status: TorrentStatus?
  public let torrentFile: String?
  public let totalSize: Int?
  public let trackers: [Tracker]?
  public let trackerList: String?
  public let trackerStats: [TrackerStats]?
  public let uploadedEver: Int?
  public let uploadLimit: Int?
  public let uploadLimited: Bool?
  public let uploadRatio: Double?
  public let wanted: [Int]?
  public let webseedsSendingToUs: Int?

  enum CodingKeys: String, CodingKey {
    case activityDate = "activity_date"
    case addedDate = "added_date"
    case availability
    case bandwidthPriority = "bandwidth_priority"
    case bytesCompleted = "bytes_completed"
    case comment
    case corruptEver = "corrupt_ever"
    case creator
    case dateCreated = "date_created"
    case desiredAvailable = "desired_available"
    case doneDate = "done_date"
    case downloadDir = "download_dir"
    case downloadLimit = "download_limit"
    case downloadLimited = "download_limited"
    case editDate = "edit_date"
    case error
    case errorString = "error_string"
    case eta
    case etaIdle = "eta_idle"
    case fileCount = "file_count"
    case files
    case fileStats = "file_stats"
    case group
    case hashString = "hash_string"
    case haveUnchecked = "have_unchecked"
    case haveValid = "have_valid"
    case honorsSessionLimits = "honors_session_limits"
    case id
    case isFinished = "is_finished"
    case isPrivate = "is_private"
    case isStalled = "is_stalled"
    case labels
    case leftUntilDone = "left_until_done"
    case magnetLink = "magnet_link"
    case maxConnectedPeers = "max_connected_peers"
    case metadataPercentComplete = "metadata_percent_complete"
    case name
    case peerLimit = "peer_limit"
    case peers
    case peersConnected = "peers_connected"
    case peersFrom = "peers_from"
    case peersGettingFromUs = "peers_getting_from_us"
    case peersSendingToUs = "peers_sending_to_us"
    case percentComplete = "percent_complete"
    case percentDone = "percent_done"
    case pieces
    case pieceCount = "piece_count"
    case pieceSize = "piece_size"
    case priorities
    case primaryMimeType = "primary_mime_type"
    case queuePosition = "queue_position"
    case rateDownload = "rate_download"
    case rateUpload = "rate_upload"
    case recheckProgress = "recheck_progress"
    case secondsDownloading = "seconds_downloading"
    case secondsSeeding = "seconds_seeding"
    case seedIdleLimit = "seed_idle_limit"
    case seedIdleMode = "seed_idle_mode"
    case seedRatioLimit = "seed_ratio_limit"
    case seedRatioMode = "seed_ratio_mode"
    case sequentialDownload = "sequential_download"
    case sequentialDownloadFromPiece = "sequential_download_from_piece"
    case sizeWhenDone = "size_when_done"
    case startDate = "start_date"
    case status
    case torrentFile = "torrent_file"
    case totalSize = "total_size"
    case trackers
    case trackerList = "tracker_list"
    case trackerStats = "tracker_stats"
    case uploadedEver = "uploaded_ever"
    case uploadLimit = "upload_limit"
    case uploadLimited = "upload_limited"
    case uploadRatio = "upload_ratio"
    case wanted
    case webseedsSendingToUs = "webseeds_sending_to_us"
  }
}
