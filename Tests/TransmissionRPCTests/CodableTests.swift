import Foundation
import Testing

@testable import TransmissionRPC

@Suite struct CodableTests {

  // MARK: - TorrentID

  @Test func encodeTorrentIDSingle() throws {
    let id = TorrentID.single(42)
    let data = try JSONEncoder().encode(id)
    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    #expect(json as? Int == 42)
  }

  @Test func encodeTorrentIDRecentlyActive() throws {
    let id = TorrentID.recentlyActive
    let data = try JSONEncoder().encode(id)
    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    #expect(json as? String == "recently_active")
  }

  @Test func encodeTorrentIDMultiple() throws {
    let id = TorrentID.multiple([.id(1), .hash("abc"), .id(3)])
    let data = try JSONEncoder().encode(id)
    let arr = try JSONSerialization.jsonObject(with: data) as? [Any]
    let json = try #require(arr)
    #expect(json.count == 3)
    #expect(json[0] as? Int == 1)
    #expect(json[1] as? String == "abc")
    #expect(json[2] as? Int == 3)
  }

  @Test func decodeTorrentIDSingle() throws {
    let json = Data("42".utf8)
    let id = try JSONDecoder().decode(TorrentID.self, from: json)
    #expect(id == .single(42))
  }

  @Test func decodeTorrentIDRecentlyActive() throws {
    let json = Data("\"recently_active\"".utf8)
    let id = try JSONDecoder().decode(TorrentID.self, from: json)
    #expect(id == .recentlyActive)
  }

  @Test func decodeTorrentIDMultiple() throws {
    let json = Data("[1, \"abc\", 3]".utf8)
    let id = try JSONDecoder().decode(TorrentID.self, from: json)
    #expect(id == .multiple([.id(1), .hash("abc"), .id(3)]))
  }

  // MARK: - TorrentActionRequest

  @Test func encodeTorrentActionRequestWithIds() throws {
    let request = TorrentActionRequest(ids: .single(7))
    let data = try JSONEncoder().encode(request)
    let dict = try JSONSerialization.jsonObject(with: data) as? [String: Int]
    #expect(dict?["ids"] == 7)
  }

  @Test func encodeTorrentActionRequestOmitIds() throws {
    let request = TorrentActionRequest(ids: nil)
    let data = try JSONEncoder().encode(request)
    let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    #expect(dict?.isEmpty == true)
  }

  // MARK: - TorrentInfo Decoding

  @Test func decodeTorrentInfoBasic() throws {
    let json = """
      {
          "id": 1,
          "name": "Test Torrent",
          "status": 4,
          "percent_done": 0.5,
          "total_size": 1000000,
          "hash_string": "abcdef1234567890"
      }
      """.data(using: .utf8)!

    let info = try JSONDecoder().decode(TorrentInfo.self, from: json)
    #expect(info.id == 1)
    #expect(info.name == "Test Torrent")
    #expect(info.status == .downloading)
    #expect(info.percentDone == 0.5)
    #expect(info.totalSize == 1_000_000)
    #expect(info.hashString == "abcdef1234567890")
  }

  @Test func decodeTorrentInfoPartial() throws {
    let json = """
      {
          "id": 2,
          "name": "Partial"
      }
      """.data(using: .utf8)!

    let info = try JSONDecoder().decode(TorrentInfo.self, from: json)
    #expect(info.id == 2)
    #expect(info.name == "Partial")
    #expect(info.status == nil)
    #expect(info.totalSize == nil)
  }
}
