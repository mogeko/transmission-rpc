import Foundation

// MARK: - Torrent Action Request

/// Request parameters for torrent action methods
/// (`torrent-start`, `torrent-stop`, `torrent-verify`, `torrent-reannounce`).
///
/// All torrent action methods share the same request shape:
/// a single optional `ids` field. Omit `ids` to act on all torrents.
public struct TorrentActionRequest: Codable, Sendable {
  /// The torrent ID(s) to act on. `nil` means "all torrents".
  public let ids: TorrentID?
}
