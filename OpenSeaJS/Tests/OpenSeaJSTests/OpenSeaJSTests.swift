import XCTest
@testable import OpenSeaJS
import JavaScriptCore

final class OpenSeaJSTests: XCTestCase {
    var js: OpenSeaJS?
    override func setUp() async throws {
        js = try await OpenSeaJS()
    }
    private func checkOK(_ str: String, _ result: Result<String, Error>?) {
        guard let result = result else {
            XCTFail("No result!")
            return
        }
        switch result {
        case .success(let res): XCTAssertEqual(res, str)
        case .failure(let error): XCTFail(error.localizedDescription)
        }
    }
    func testExample() async throws {
        checkOK("https://opensea.io", await js?.runJavascript("OpenSeaJS.seaport.api.hostUrl"))
        checkOK("https://api.opensea.io", await js?.runJavascript(
            "OpenSeaJS.seaport.api.apiBaseUrl")
        )
    }

    func testCheckAsset() async {
        await js?.runJavascript(
            "OpenSeaJS.seaport.api.getAsset({ " +
            "  tokenAddress: '0x06012c8cf97bead5deae237070f9587f8e7a266d'," +
            "  tokenId: '1'" +
            "}).then(function(t){ window.asset = t; })"
        )
        Thread.sleep(forTimeInterval: 2.0)
        checkOK("12345", await js?.runJavascript("JSON.stringify(window.asset)"))
    }
}
