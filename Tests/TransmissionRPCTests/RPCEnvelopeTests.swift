import XCTest

@testable import TransmissionRPC

final class RPCEnvelopeTests: XCTestCase {

  // MARK: - RPCRequest Encoding

  func testEncodeRPCRequest_noParams() throws {
    let request = RPCRequest<String>(method: "session-close", params: nil, id: 1)
    let data = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

    XCTAssertEqual(json?["jsonrpc"] as? String, "2.0")
    XCTAssertEqual(json?["method"] as? String, "session-close")
    XCTAssertEqual(json?["id"] as? Int, 1)
    XCTAssertNil(json?["params"])
  }

  func testEncodeRPCRequest_withParams() throws {
    let params = ["ids": [1, 2, 3]]
    let request = RPCRequest(method: "torrent-start", params: params, id: 2)
    let data = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

    XCTAssertEqual(json?["method"] as? String, "torrent-start")
    XCTAssertEqual(json?["id"] as? Int, 2)
    let decodedParams = json?["params"] as? [String: [Int]]
    XCTAssertEqual(decodedParams?["ids"], [1, 2, 3])
  }

  // MARK: - RPCResponse Decoding

  func testDecodeSuccessResponse() throws {
    let json = """
      {
          "jsonrpc": "2.0",
          "result": {
              "result": "success",
              "arguments": {"torrents": [], "removed": null},
              "tag": 1
          },
          "id": 1
      }
      """.data(using: .utf8)!

    let response = try JSONDecoder().decode(
      RPCResponse<RPCResult<TorrentGetResponse>>.self, from: json
    )

    XCTAssertEqual(response.result?.result, "success")
    XCTAssertEqual(response.result?.tag, 1)
    XCTAssertEqual(response.result?.arguments?.torrents?.count, 0)
    XCTAssertNil(response.error)
  }

  func testDecodeErrorResponse() throws {
    let json = """
      {
          "jsonrpc": "2.0",
          "error": {
              "code": 7,
              "message": "HTTP error from backend service",
              "data": {"error_string": "Connection refused"}
          },
          "id": 1
      }
      """.data(using: .utf8)!

    let response = try JSONDecoder().decode(
      RPCResponse<RPCResult<TorrentGetResponse>>.self, from: json
    )

    XCTAssertNil(response.result)
    XCTAssertEqual(response.error?.code, 7)
    XCTAssertEqual(response.error?.message, "HTTP error from backend service")
    XCTAssertEqual(response.error?.data?.errorString, "Connection refused")
  }
}
