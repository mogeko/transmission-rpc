import Foundation

// MARK: - Torrent Identifier

/// Identifies one or more torrents for RPC methods.
///
/// Transmission's `ids` parameter can be:
/// - A single integer torrent ID
/// - An array of integer IDs and/or hash strings
/// - The string `"recently_active"`
/// - Omitted (meaning "all torrents")
public enum TorrentID: Codable, Sendable {
  /// A single torrent by its numeric ID.
  case single(Int)
  /// Multiple torrents by ID or hash.
  case multiple([Element])
  /// Torrents that were recently active.
  case recentlyActive

  /// An element in a torrent ID list, either a numeric ID or a hash string.
  public enum Element: Codable, Sendable {
    case id(Int)
    case hash(String)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let intValue = try? container.decode(Int.self) {
        self = .id(intValue)
      } else {
        self = .hash(try container.decode(String.self))
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .id(let intValue):
        try container.encode(intValue)
      case .hash(let stringValue):
        try container.encode(stringValue)
      }
    }
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let intValue = try? container.decode(Int.self) {
      self = .single(intValue)
    } else if (try? container.decode(String.self)) != nil {
      self = .recentlyActive
    } else {
      let elements = try container.decode([Element].self)
      self = .multiple(elements)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .single(let intValue):
      try container.encode(intValue)
    case .multiple(let elements):
      try container.encode(elements)
    case .recentlyActive:
      try container.encode("recently_active")
    }
  }
}

// MARK: - Torrent Fields (for torrent_get)

/// Fields that can be requested via `torrent_get`.
public enum TorrentFields: String, CaseIterable, Codable, Sendable {
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

// MARK: - Torrent Status

/// The status of a torrent.
public enum TorrentStatus: Int, Codable, Sendable {
  /// Paused
  case stopped = 0
  /// Queued to verify local data
  case checkWait = 1
  /// Verifying local data
  case checking = 2
  /// Queued to download
  case downloadWait = 3
  /// Downloading
  case downloading = 4
  /// Queued to seed
  case seedWait = 5
  /// Seeding
  case seeding = 6
}

// MARK: - File Info

/// Information about a file within a torrent.
public struct File: Codable, Sendable {
  public let bytesCompleted: Int?
  public let length: Int?
  public let name: String?

  enum CodingKeys: String, CodingKey {
    case bytesCompleted = "bytes_completed"
    case length
    case name
  }
}

// MARK: - File Stats

/// Statistics for a file within a torrent.
public struct FileStats: Codable, Sendable {
  public let bytesCompleted: Int?
  public let wanted: Bool?
  public let priority: Int?

  enum CodingKeys: String, CodingKey {
    case bytesCompleted = "bytes_completed"
    case wanted
    case priority
  }
}

// MARK: - Peer Info

/// Information about a connected peer.
public struct Peer: Codable, Sendable {
  public let address: String?
  public let clientName: String?
  public let clientIsChoked: Bool?
  public let clientIsInterested: Bool?
  public let flagStr: String?
  public let isDownloadingFrom: Bool?
  public let isEncrypted: Bool?
  public let isUTP: Bool?
  public let isUploadingTo: Bool?
  public let peerIsChoked: Bool?
  public let peerIsInterested: Bool?
  public let port: Int?
  public let progress: Double?
  public let rateToClient: Int?
  public let rateToPeer: Int?

  enum CodingKeys: String, CodingKey {
    case address
    case clientName = "client_name"
    case clientIsChoked = "client_is_choked"
    case clientIsInterested = "client_is_interested"
    case flagStr = "flag_str"
    case isDownloadingFrom = "is_downloading_from"
    case isEncrypted = "is_encrypted"
    case isUTP = "is_utp"
    case isUploadingTo = "is_uploading_to"
    case peerIsChoked = "peer_is_choked"
    case peerIsInterested = "peer_is_interested"
    case port
    case progress
    case rateToClient = "rate_to_client"
    case rateToPeer = "rate_to_peer"
  }
}

// MARK: - Peer Sources

/// Counts of peers from various sources.
public struct PeerFrom: Codable, Sendable {
  public let fromCache: Int?
  public let fromDht: Int?
  public let fromIncoming: Int?
  public let fromLpd: Int?
  public let fromPex: Int?
  public let fromTracker: Int?

  enum CodingKeys: String, CodingKey {
    case fromCache = "from_cache"
    case fromDht = "from_dht"
    case fromIncoming = "from_incoming"
    case fromLpd = "from_lpd"
    case fromPex = "from_pex"
    case fromTracker = "from_tracker"
  }
}

// MARK: - Tracker Info

/// Information about a tracker associated with a torrent.
public struct Tracker: Codable, Sendable {
  public let announce: String?
  public let id: Int?
  public let scrape: String?
  public let sitename: String?
  public let tier: Int?

  enum CodingKeys: String, CodingKey {
    case announce
    case id
    case scrape
    case sitename
    case tier
  }
}

// MARK: - Tracker Stats

/// Statistics for a tracker associated with a torrent.
public struct TrackerStats: Codable, Sendable {
  public let announce: String?
  public let announceState: Int?
  public let downloadCount: Int?
  public let hasAnnounced: Bool?
  public let hasScraped: Bool?
  public let host: String?
  public let id: Int?
  public let isBackup: Bool?
  public let lastAnnouncePeerCount: Int?
  public let lastAnnounceResult: String?
  public let lastAnnounceStartTime: Int?
  public let lastAnnounceSucceeded: Bool?
  public let lastAnnounceTime: Int?
  public let lastAnnounceTimedOut: Bool?
  public let lastScrapeResult: String?
  public let lastScrapeStartTime: Int?
  public let lastScrapeSucceeded: Bool?
  public let lastScrapeTime: Int?
  public let lastScrapeTimedOut: Bool?
  public let leecherCount: Int?
  public let nextAnnounceTime: Int?
  public let nextScrapeTime: Int?
  public let scrapeState: Int?
  public let seederCount: Int?
  public let tier: Int?

  enum CodingKeys: String, CodingKey {
    case announce
    case announceState = "announce_state"
    case downloadCount = "download_count"
    case hasAnnounced = "has_announced"
    case hasScraped = "has_scraped"
    case host
    case id
    case isBackup = "is_backup"
    case lastAnnouncePeerCount = "last_announce_peer_count"
    case lastAnnounceResult = "last_announce_result"
    case lastAnnounceStartTime = "last_announce_start_time"
    case lastAnnounceSucceeded = "last_announce_succeeded"
    case lastAnnounceTime = "last_announce_time"
    case lastAnnounceTimedOut = "last_announce_timed_out"
    case lastScrapeResult = "last_scrape_result"
    case lastScrapeStartTime = "last_scrape_start_time"
    case lastScrapeSucceeded = "last_scrape_succeeded"
    case lastScrapeTime = "last_scrape_time"
    case lastScrapeTimedOut = "last_scrape_timed_out"
    case leecherCount = "leecher_count"
    case nextAnnounceTime = "next_announce_time"
    case nextScrapeTime = "next_scrape_time"
    case scrapeState = "scrape_state"
    case seederCount = "seeder_count"
    case tier
  }
}

// MARK: - Units

/// Speed, size, and memory unit configuration.
public struct Units: Codable, Sendable {
  public let speedUnits: [String]?
  public let speedBytes: Int?
  public let sizeUnits: [String]?
  public let sizeBytes: Int?
  public let memoryUnits: [String]?
  public let memoryBytes: Int?

  enum CodingKeys: String, CodingKey {
    case speedUnits = "speed_units"
    case speedBytes = "speed_bytes"
    case sizeUnits = "size_units"
    case sizeBytes = "size_bytes"
    case memoryUnits = "memory_units"
    case memoryBytes = "memory_bytes"
  }
}

// MARK: - Bandwidth Group

/// A bandwidth group configuration.
public struct BandwidthGroup: Codable, Sendable {
  public let name: String?
  public let honorsSessionLimits: Bool?
  public let speedLimitDown: Int?
  public let speedLimitDownEnabled: Bool?
  public let speedLimitUp: Int?
  public let speedLimitUpEnabled: Bool?

  enum CodingKeys: String, CodingKey {
    case name
    case honorsSessionLimits = "honors_session_limits"
    case speedLimitDown = "speed_limit_down"
    case speedLimitDownEnabled = "speed_limit_down_enabled"
    case speedLimitUp = "speed_limit_up"
    case speedLimitUpEnabled = "speed_limit_up_enabled"
  }
}

// MARK: - Cumulative / Current Stats

/// Cumulative or current session statistics.
public struct StatsData: Codable, Sendable {
  public let uploadedBytes: Int?
  public let downloadedBytes: Int?
  public let filesAdded: Int?
  public let secondsActive: Int?
  public let sessionCount: Int?

  enum CodingKeys: String, CodingKey {
    case uploadedBytes = "uploaded_bytes"
    case downloadedBytes = "downloaded_bytes"
    case filesAdded = "files_added"
    case secondsActive = "seconds_active"
    case sessionCount = "session_count"
  }
}
