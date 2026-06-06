import XCTest

@testable import TransmissionRPC

final class CodableTests: XCTestCase {

  // MARK: - TorrentID

  func testEncodeTorrentID_single() throws {
    let id = TorrentID.single(42)
    let data = try JSONEncoder().encode(id)
    let json = try JSONSerialization.jsonObject(with: data)
    XCTAssertEqual(json as? Int, 42)
  }

  func testEncodeTorrentID_recentlyActive() throws {
    let id = TorrentID.recentlyActive
    let data = try JSONEncoder().encode(id)
    let json = try JSONSerialization.jsonObject(with: data)
    XCTAssertEqual(json as? String, "recently_active")
  }

  func testEncodeTorrentID_multiple() throws {
    let id = TorrentID.multiple([.id(1), .hash("abc"), .id(3)])
    let data = try JSONEncoder().encode(id)
    let json = try JSONSerialization.jsonObject(with: data) as? [Any]
    XCTAssertEqual(json?.count, 3)
    XCTAssertEqual(json?[0] as? Int, 1)
    XCTAssertEqual(json?[1] as? String, "abc")
    XCTAssertEqual(json?[2] as? Int, 3)
  }

  func testDecodeTorrentID_single() throws {
    let json = Data("42".utf8)
    let id = try JSONDecoder().decode(TorrentID.self, from: json)
    XCTAssertEqual(id, .single(42))
  }

  func testDecodeTorrentID_recentlyActive() throws {
    let json = Data("\"recently_active\"".utf8)
    let id = try JSONDecoder().decode(TorrentID.self, from: json)
    XCTAssertEqual(id, .recentlyActive)
  }

  func testDecodeTorrentID_multiple() throws {
    let json = Data("[1, \"abc\", 3]".utf8)
    let id = try JSONDecoder().decode(TorrentID.self, from: json)
    XCTAssertEqual(id, .multiple([.id(1), .hash("abc"), .id(3)]))
  }

  // MARK: - TorrentActionRequest

  func testEncodeTorrentActionRequest_withIds() throws {
    let request = TorrentActionRequest(ids: .single(7))
    let data = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: data) as? [String: Int]
    XCTAssertEqual(json?["ids"], 7)
  }

  func testEncodeTorrentActionRequest_omitIds() throws {
    let request = TorrentActionRequest(ids: nil)
    let data = try JSONEncoder().encode(request)
    let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    XCTAssertTrue(dict?.isEmpty ?? false)
  }

  // MARK: - TorrentInfo Decoding

  func testDecodeTorrentInfo_basic() throws {
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
    XCTAssertEqual(info.id, 1)
    XCTAssertEqual(info.name, "Test Torrent")
    XCTAssertEqual(info.status, .downloading)
    XCTAssertEqual(info.percentDone, 0.5)
    XCTAssertEqual(info.totalSize, 1_000_000)
    XCTAssertEqual(info.hashString, "abcdef1234567890")
  }

  func testDecodeTorrentInfo_partial() throws {
    let json = """
      {
          "id": 2,
          "name": "Partial"
      }
      """.data(using: .utf8)!

    let info = try JSONDecoder().decode(TorrentInfo.self, from: json)
    XCTAssertEqual(info.id, 2)
    XCTAssertEqual(info.name, "Partial")
    XCTAssertNil(info.status)  // Not in JSON → nil
    XCTAssertNil(info.totalSize)
  }
}
