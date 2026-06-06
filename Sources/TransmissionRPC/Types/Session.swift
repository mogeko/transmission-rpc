import Foundation

// MARK: - Session Get Request

/// Request parameters for `session-get`.
public struct SessionGetRequest: Codable, Sendable {
  /// The session fields to retrieve. `nil` means all fields.
  public let fields: [String]?

  public init(fields: [String]? = nil) {
    self.fields = fields
  }
}

// MARK: - Session

/// Full session information, as returned by `session-get`.
///
/// All fields are optional because Transmission omits fields
/// that were not requested via the `fields` parameter.
public struct Session: Codable, Sendable {
  public let altSpeedDown: Int?
  public let altSpeedEnabled: Bool?
  public let altSpeedTimeBegin: Int?
  public let altSpeedTimeDay: Int?
  public let altSpeedTimeEnabled: Bool?
  public let altSpeedTimeEnd: Int?
  public let altSpeedUp: Int?
  public let antiBruteForceEnabled: Bool?
  public let blocklistEnabled: Bool?
  public let blocklistSize: Int?
  public let blocklistUrl: String?
  public let configDir: String?
  public let defaultTrackers: String?
  public let dhtEnabled: Bool?
  public let downloadDir: String?
  public let downloadQueueEnabled: Bool?
  public let downloadQueueSize: Int?
  public let encryption: String?
  public let idleSeedingLimit: Int?
  public let idleSeedingLimitEnabled: Bool?
  public let incompleteDir: String?
  public let incompleteDirEnabled: Bool?
  public let lpdEnabled: Bool?
  public let peerLimitGlobal: Int?
  public let peerLimitPerTorrent: Int?
  public let peerPort: Int?
  public let peerPortRandomOnStart: Bool?
  public let pexEnabled: Bool?
  public let portForwardingEnabled: Bool?
  public let preferredTransports: String?
  public let queueStalledEnabled: Bool?
  public let queueStalledMinutes: Int?
  public let renamePartialFiles: Bool?
  public let reqq: Int?
  public let rpcVersionSemver: String?
  public let scriptTorrentAddedEnabled: Bool?
  public let scriptTorrentAddedFilename: String?
  public let scriptTorrentDoneEnabled: Bool?
  public let scriptTorrentDoneFilename: String?
  public let scriptTorrentDoneSeedingEnabled: Bool?
  public let scriptTorrentDoneSeedingFilename: String?
  public let seedQueueEnabled: Bool?
  public let seedQueueSize: Int?
  public let seedRatioLimit: Double?
  public let seedRatioLimited: Bool?
  public let sequentialDownload: Bool?
  public let sessionId: String?
  public let speedLimitDown: Int?
  public let speedLimitDownEnabled: Bool?
  public let speedLimitUp: Int?
  public let speedLimitUpEnabled: Bool?
  public let startAddedTorrents: Bool?
  public let trashOriginalTorrentFiles: Bool?
  public let units: Units?
  public let version: String?

  enum CodingKeys: String, CodingKey {
    case altSpeedDown = "alt_speed_down"
    case altSpeedEnabled = "alt_speed_enabled"
    case altSpeedTimeBegin = "alt_speed_time_begin"
    case altSpeedTimeDay = "alt_speed_time_day"
    case altSpeedTimeEnabled = "alt_speed_time_enabled"
    case altSpeedTimeEnd = "alt_speed_time_end"
    case altSpeedUp = "alt_speed_up"
    case antiBruteForceEnabled = "anti_brute_force_enabled"
    case blocklistEnabled = "blocklist_enabled"
    case blocklistSize = "blocklist_size"
    case blocklistUrl = "blocklist_url"
    case configDir = "config_dir"
    case defaultTrackers = "default_trackers"
    case dhtEnabled = "dht_enabled"
    case downloadDir = "download_dir"
    case downloadQueueEnabled = "download_queue_enabled"
    case downloadQueueSize = "download_queue_size"
    case encryption
    case idleSeedingLimit = "idle_seeding_limit"
    case idleSeedingLimitEnabled = "idle_seeding_limit_enabled"
    case incompleteDir = "incomplete_dir"
    case incompleteDirEnabled = "incomplete_dir_enabled"
    case lpdEnabled = "lpd_enabled"
    case peerLimitGlobal = "peer_limit_global"
    case peerLimitPerTorrent = "peer_limit_per_torrent"
    case peerPort = "peer_port"
    case peerPortRandomOnStart = "peer_port_random_on_start"
    case pexEnabled = "pex_enabled"
    case portForwardingEnabled = "port_forwarding_enabled"
    case preferredTransports = "preferred_transports"
    case queueStalledEnabled = "queue_stalled_enabled"
    case queueStalledMinutes = "queue_stalled_minutes"
    case renamePartialFiles = "rename_partial_files"
    case reqq
    case rpcVersionSemver = "rpc_version_semver"
    case scriptTorrentAddedEnabled = "script_torrent_added_enabled"
    case scriptTorrentAddedFilename = "script_torrent_added_filename"
    case scriptTorrentDoneEnabled = "script_torrent_done_enabled"
    case scriptTorrentDoneFilename = "script_torrent_done_filename"
    case scriptTorrentDoneSeedingEnabled = "script_torrent_done_seeding_enabled"
    case scriptTorrentDoneSeedingFilename = "script_torrent_done_seeding_filename"
    case seedQueueEnabled = "seed_queue_enabled"
    case seedQueueSize = "seed_queue_size"
    case seedRatioLimit = "seed_ratio_limit"
    case seedRatioLimited = "seed_ratio_limited"
    case sequentialDownload = "sequential_download"
    case sessionId = "session_id"
    case speedLimitDown = "speed_limit_down"
    case speedLimitDownEnabled = "speed_limit_down_enabled"
    case speedLimitUp = "speed_limit_up"
    case speedLimitUpEnabled = "speed_limit_up_enabled"
    case startAddedTorrents = "start_added_torrents"
    case trashOriginalTorrentFiles = "trash_original_torrent_files"
    case units
    case version
  }
}

// MARK: - Session Set Request

/// Request parameters for `session-set`.
///
/// All fields are optional. Only non-nil fields are sent
/// to the server; other fields remain unchanged.
/// Read-only session fields (version, rpc_version_semver, etc.) are excluded.
public struct SessionSetRequest: Codable, Sendable {
  public let altSpeedDown: Int?
  public let altSpeedEnabled: Bool?
  public let altSpeedTimeBegin: Int?
  public let altSpeedTimeDay: Int?
  public let altSpeedTimeEnabled: Bool?
  public let altSpeedTimeEnd: Int?
  public let altSpeedUp: Int?
  public let antiBruteForceEnabled: Bool?
  public let blocklistEnabled: Bool?
  public let blocklistUrl: String?
  public let defaultTrackers: String?
  public let dhtEnabled: Bool?
  public let downloadDir: String?
  public let downloadQueueEnabled: Bool?
  public let downloadQueueSize: Int?
  public let encryption: String?
  public let idleSeedingLimit: Int?
  public let idleSeedingLimitEnabled: Bool?
  public let incompleteDir: String?
  public let incompleteDirEnabled: Bool?
  public let lpdEnabled: Bool?
  public let peerLimitGlobal: Int?
  public let peerLimitPerTorrent: Int?
  public let peerPort: Int?
  public let peerPortRandomOnStart: Bool?
  public let pexEnabled: Bool?
  public let portForwardingEnabled: Bool?
  public let preferredTransports: String?
  public let queueStalledEnabled: Bool?
  public let queueStalledMinutes: Int?
  public let renamePartialFiles: Bool?
  public let reqq: Int?
  public let scriptTorrentAddedEnabled: Bool?
  public let scriptTorrentAddedFilename: String?
  public let scriptTorrentDoneEnabled: Bool?
  public let scriptTorrentDoneFilename: String?
  public let scriptTorrentDoneSeedingEnabled: Bool?
  public let scriptTorrentDoneSeedingFilename: String?
  public let seedQueueEnabled: Bool?
  public let seedQueueSize: Int?
  public let seedRatioLimit: Double?
  public let seedRatioLimited: Bool?
  public let sequentialDownload: Bool?
  public let speedLimitDown: Int?
  public let speedLimitDownEnabled: Bool?
  public let speedLimitUp: Int?
  public let speedLimitUpEnabled: Bool?
  public let startAddedTorrents: Bool?
  public let trashOriginalTorrentFiles: Bool?

  public init(
    altSpeedDown: Int? = nil,
    altSpeedEnabled: Bool? = nil,
    altSpeedTimeBegin: Int? = nil,
    altSpeedTimeDay: Int? = nil,
    altSpeedTimeEnabled: Bool? = nil,
    altSpeedTimeEnd: Int? = nil,
    altSpeedUp: Int? = nil,
    antiBruteForceEnabled: Bool? = nil,
    blocklistEnabled: Bool? = nil,
    blocklistUrl: String? = nil,
    defaultTrackers: String? = nil,
    dhtEnabled: Bool? = nil,
    downloadDir: String? = nil,
    downloadQueueEnabled: Bool? = nil,
    downloadQueueSize: Int? = nil,
    encryption: String? = nil,
    idleSeedingLimit: Int? = nil,
    idleSeedingLimitEnabled: Bool? = nil,
    incompleteDir: String? = nil,
    incompleteDirEnabled: Bool? = nil,
    lpdEnabled: Bool? = nil,
    peerLimitGlobal: Int? = nil,
    peerLimitPerTorrent: Int? = nil,
    peerPort: Int? = nil,
    peerPortRandomOnStart: Bool? = nil,
    pexEnabled: Bool? = nil,
    portForwardingEnabled: Bool? = nil,
    preferredTransports: String? = nil,
    queueStalledEnabled: Bool? = nil,
    queueStalledMinutes: Int? = nil,
    renamePartialFiles: Bool? = nil,
    reqq: Int? = nil,
    scriptTorrentAddedEnabled: Bool? = nil,
    scriptTorrentAddedFilename: String? = nil,
    scriptTorrentDoneEnabled: Bool? = nil,
    scriptTorrentDoneFilename: String? = nil,
    scriptTorrentDoneSeedingEnabled: Bool? = nil,
    scriptTorrentDoneSeedingFilename: String? = nil,
    seedQueueEnabled: Bool? = nil,
    seedQueueSize: Int? = nil,
    seedRatioLimit: Double? = nil,
    seedRatioLimited: Bool? = nil,
    sequentialDownload: Bool? = nil,
    speedLimitDown: Int? = nil,
    speedLimitDownEnabled: Bool? = nil,
    speedLimitUp: Int? = nil,
    speedLimitUpEnabled: Bool? = nil,
    startAddedTorrents: Bool? = nil,
    trashOriginalTorrentFiles: Bool? = nil
  ) {
    self.altSpeedDown = altSpeedDown
    self.altSpeedEnabled = altSpeedEnabled
    self.altSpeedTimeBegin = altSpeedTimeBegin
    self.altSpeedTimeDay = altSpeedTimeDay
    self.altSpeedTimeEnabled = altSpeedTimeEnabled
    self.altSpeedTimeEnd = altSpeedTimeEnd
    self.altSpeedUp = altSpeedUp
    self.antiBruteForceEnabled = antiBruteForceEnabled
    self.blocklistEnabled = blocklistEnabled
    self.blocklistUrl = blocklistUrl
    self.defaultTrackers = defaultTrackers
    self.dhtEnabled = dhtEnabled
    self.downloadDir = downloadDir
    self.downloadQueueEnabled = downloadQueueEnabled
    self.downloadQueueSize = downloadQueueSize
    self.encryption = encryption
    self.idleSeedingLimit = idleSeedingLimit
    self.idleSeedingLimitEnabled = idleSeedingLimitEnabled
    self.incompleteDir = incompleteDir
    self.incompleteDirEnabled = incompleteDirEnabled
    self.lpdEnabled = lpdEnabled
    self.peerLimitGlobal = peerLimitGlobal
    self.peerLimitPerTorrent = peerLimitPerTorrent
    self.peerPort = peerPort
    self.peerPortRandomOnStart = peerPortRandomOnStart
    self.pexEnabled = pexEnabled
    self.portForwardingEnabled = portForwardingEnabled
    self.preferredTransports = preferredTransports
    self.queueStalledEnabled = queueStalledEnabled
    self.queueStalledMinutes = queueStalledMinutes
    self.renamePartialFiles = renamePartialFiles
    self.reqq = reqq
    self.scriptTorrentAddedEnabled = scriptTorrentAddedEnabled
    self.scriptTorrentAddedFilename = scriptTorrentAddedFilename
    self.scriptTorrentDoneEnabled = scriptTorrentDoneEnabled
    self.scriptTorrentDoneFilename = scriptTorrentDoneFilename
    self.scriptTorrentDoneSeedingEnabled = scriptTorrentDoneSeedingEnabled
    self.scriptTorrentDoneSeedingFilename = scriptTorrentDoneSeedingFilename
    self.seedQueueEnabled = seedQueueEnabled
    self.seedQueueSize = seedQueueSize
    self.seedRatioLimit = seedRatioLimit
    self.seedRatioLimited = seedRatioLimited
    self.sequentialDownload = sequentialDownload
    self.speedLimitDown = speedLimitDown
    self.speedLimitDownEnabled = speedLimitDownEnabled
    self.speedLimitUp = speedLimitUp
    self.speedLimitUpEnabled = speedLimitUpEnabled
    self.startAddedTorrents = startAddedTorrents
    self.trashOriginalTorrentFiles = trashOriginalTorrentFiles
  }

  enum CodingKeys: String, CodingKey {
    case altSpeedDown = "alt_speed_down"
    case altSpeedEnabled = "alt_speed_enabled"
    case altSpeedTimeBegin = "alt_speed_time_begin"
    case altSpeedTimeDay = "alt_speed_time_day"
    case altSpeedTimeEnabled = "alt_speed_time_enabled"
    case altSpeedTimeEnd = "alt_speed_time_end"
    case altSpeedUp = "alt_speed_up"
    case antiBruteForceEnabled = "anti_brute_force_enabled"
    case blocklistEnabled = "blocklist_enabled"
    case blocklistUrl = "blocklist_url"
    case defaultTrackers = "default_trackers"
    case dhtEnabled = "dht_enabled"
    case downloadDir = "download_dir"
    case downloadQueueEnabled = "download_queue_enabled"
    case downloadQueueSize = "download_queue_size"
    case encryption
    case idleSeedingLimit = "idle_seeding_limit"
    case idleSeedingLimitEnabled = "idle_seeding_limit_enabled"
    case incompleteDir = "incomplete_dir"
    case incompleteDirEnabled = "incomplete_dir_enabled"
    case lpdEnabled = "lpd_enabled"
    case peerLimitGlobal = "peer_limit_global"
    case peerLimitPerTorrent = "peer_limit_per_torrent"
    case peerPort = "peer_port"
    case peerPortRandomOnStart = "peer_port_random_on_start"
    case pexEnabled = "pex_enabled"
    case portForwardingEnabled = "port_forwarding_enabled"
    case preferredTransports = "preferred_transports"
    case queueStalledEnabled = "queue_stalled_enabled"
    case queueStalledMinutes = "queue_stalled_minutes"
    case renamePartialFiles = "rename_partial_files"
    case reqq
    case scriptTorrentAddedEnabled = "script_torrent_added_enabled"
    case scriptTorrentAddedFilename = "script_torrent_added_filename"
    case scriptTorrentDoneEnabled = "script_torrent_done_enabled"
    case scriptTorrentDoneFilename = "script_torrent_done_filename"
    case scriptTorrentDoneSeedingEnabled = "script_torrent_done_seeding_enabled"
    case scriptTorrentDoneSeedingFilename = "script_torrent_done_seeding_filename"
    case seedQueueEnabled = "seed_queue_enabled"
    case seedQueueSize = "seed_queue_size"
    case seedRatioLimit = "seed_ratio_limit"
    case seedRatioLimited = "seed_ratio_limited"
    case sequentialDownload = "sequential_download"
    case speedLimitDown = "speed_limit_down"
    case speedLimitDownEnabled = "speed_limit_down_enabled"
    case speedLimitUp = "speed_limit_up"
    case speedLimitUpEnabled = "speed_limit_up_enabled"
    case startAddedTorrents = "start_added_torrents"
    case trashOriginalTorrentFiles = "trash_original_torrent_files"
  }
}
