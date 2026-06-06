import Foundation

// MARK: - Session Stats

/// Response from `session-stats`.
public struct SessionStats: Codable, Sendable {
  public let activeTorrentCount: Int?
  public let downloadSpeed: Int?
  public let pausedTorrentCount: Int?
  public let torrentCount: Int?
  public let uploadSpeed: Int?
  public let cumulativeStats: StatsData?
  public let currentStats: StatsData?

  enum CodingKeys: String, CodingKey {
    case activeTorrentCount = "active_torrent_count"
    case downloadSpeed = "download_speed"
    case pausedTorrentCount = "paused_torrent_count"
    case torrentCount = "torrent_count"
    case uploadSpeed = "upload_speed"
    case cumulativeStats = "cumulative_stats"
    case currentStats = "current_stats"
  }
}

// MARK: - Blocklist Update

/// Response from `blocklist-update`.
public struct BlocklistUpdateResponse: Codable, Sendable {
  public let blocklistSize: Int?

  enum CodingKeys: String, CodingKey {
    case blocklistSize = "blocklist_size"
  }
}

// MARK: - Port Test

/// IP protocol options for port testing.
public enum IPProtocol: String, Codable, Sendable {
  case ipv4
  case ipv6
}

/// Request parameters for `port-test`.
public struct PortTestRequest: Codable, Sendable {
  public let ipProtocol: IPProtocol?

  public init(ipProtocol: IPProtocol? = nil) {
    self.ipProtocol = ipProtocol
  }

  enum CodingKeys: String, CodingKey {
    case ipProtocol = "ip_protocol"
  }
}

/// Response from `port-test`.
public struct PortTestResponse: Codable, Sendable {
  public let portIsOpen: Bool?
  public let ipProtocol: IPProtocol?

  enum CodingKeys: String, CodingKey {
    case portIsOpen = "port_is_open"
    case ipProtocol = "ip_protocol"
  }
}

// MARK: - Queue Movement

/// Request parameters for queue movement methods.
public struct QueueMovementRequest: Codable, Sendable {
  public let ids: TorrentID
}

// MARK: - Free Space

/// Request parameters for `free-space`.
public struct FreeSpaceRequest: Codable, Sendable {
  public let path: String
}

/// Response from `free-space`.
public struct FreeSpaceResponse: Codable, Sendable {
  public let path: String?
  public let sizeBytes: Int?
  public let totalSize: Int?

  enum CodingKeys: String, CodingKey {
    case path
    case sizeBytes = "size_bytes"
    case totalSize = "total_size"
  }
}

// MARK: - Bandwidth Group Set

/// Request parameters for `group-set`.
public struct GroupSetRequest: Codable, Sendable {
  public let name: String
  public let honorsSessionLimits: Bool?
  public let speedLimitDown: Int?
  public let speedLimitDownEnabled: Bool?
  public let speedLimitUp: Int?
  public let speedLimitUpEnabled: Bool?

  public init(
    name: String,
    honorsSessionLimits: Bool? = nil,
    speedLimitDown: Int? = nil,
    speedLimitDownEnabled: Bool? = nil,
    speedLimitUp: Int? = nil,
    speedLimitUpEnabled: Bool? = nil
  ) {
    self.name = name
    self.honorsSessionLimits = honorsSessionLimits
    self.speedLimitDown = speedLimitDown
    self.speedLimitDownEnabled = speedLimitDownEnabled
    self.speedLimitUp = speedLimitUp
    self.speedLimitUpEnabled = speedLimitUpEnabled
  }

  enum CodingKeys: String, CodingKey {
    case name
    case honorsSessionLimits = "honors_session_limits"
    case speedLimitDown = "speed_limit_down"
    case speedLimitDownEnabled = "speed_limit_down_enabled"
    case speedLimitUp = "speed_limit_up"
    case speedLimitUpEnabled = "speed_limit_up_enabled"
  }
}

// MARK: - Bandwidth Group Get

/// Request parameters for `group-get`.
public struct GroupGetRequest: Codable, Sendable {
  public let name: String?

  public init(name: String? = nil) {
    self.name = name
  }
}

/// Response wrapper for `group-get`. Transmission returns `{"group": [...]}`.
public struct GroupGetResponse: Codable, Sendable {
  public let group: [BandwidthGroup]?
}
