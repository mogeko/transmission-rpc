import Foundation
import Testing

@testable import TransmissionRPC

@Suite struct RPCEnvelopeTests {

  // MARK: - RPCRequest Encoding

  @Test func encodeRPCRequestNoParams() throws {
    let request = RPCRequest<String>(method: "session-close", params: nil, id: 1)
    let data = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    let dict = try #require(json)

    #expect(dict["jsonrpc"] as? String == "2.0")
    #expect(dict["method"] as? String == "session-close")
    #expect(dict["id"] as? Int == 1)
    #expect(dict["params"] == nil)
  }

  @Test func encodeRPCRequestWithParams() throws {
    let params = ["ids": [1, 2, 3]]
    let request = RPCRequest(method: "torrent-start", params: params, id: 2)
    let data = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    let dict = try #require(json)

    #expect(dict["method"] as? String == "torrent-start")
    #expect(dict["id"] as? Int == 2)
    let decodedParams = dict["params"] as? [String: [Int]]
    #expect(decodedParams?["ids"] == [1, 2, 3])
  }

  // MARK: - RPCResponse Decoding

  @Test func decodeSuccessResponse() throws {
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

    #expect(response.result?.result == "success")
    #expect(response.result?.tag == 1)
    #expect(response.result?.arguments?.torrents?.count == 0)
    #expect(response.error == nil)
  }

  @Test func decodeErrorResponse() throws {
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

    #expect(response.result == nil)
    #expect(response.error?.code == 7)
    #expect(response.error?.message == "HTTP error from backend service")
    #expect(response.error?.data?.errorString == "Connection refused")
  }
}
