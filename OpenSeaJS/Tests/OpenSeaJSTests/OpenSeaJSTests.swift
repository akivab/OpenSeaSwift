import XCTest
@testable import OpenSeaJS
import JavaScriptCore

final class OpenSeaJSTests: XCTestCase {
    var js: OpenSeaJS?
    override func setUp() {
        js = try? OpenSeaJS()
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
    func testExample() throws {
        let expectation1 = expectation(description: "Gets right host URL")
        js?.runJavascript("OpenSeaJS.seaport.api.hostUrl") { res in
            self.checkOK("https://opensea.io", res)
            expectation1.fulfill()
        }

        let expectation2 = expectation(description: "Gets right base URL")
        js?.runJavascript("OpenSeaJS.seaport.api.apiBaseUrl") { res in
            self.checkOK("https://api.opensea.io", res)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 2.0)
    }

    let delay: (TimeInterval, @escaping () -> Void) -> Void = { timeInterval, action in
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            action()
        }
    }
    func testCheckAsset() {
        let expectation = expectation(description: "Gets the correct asset")
        js?.runJavascript(
            "OpenSeaJS.seaport.api.getAsset({ " +
            "  tokenAddress: '0x06012c8cf97bead5deae237070f9587f8e7a266d'," +
            "  tokenId: '1'" +
            "}).then(function(t){ window.asset = t; })"
        )
        delay(2.0) {
            self.js?.runJavascript("JSON.stringify(window.asset)") { res in
                guard let resultStr = try? res?.get() else {
                    return
                }

                XCTAssertTrue(
                    resultStr.contains("CryptoKitties-Auction-Contract"),
                    "\(resultStr) should contain this string"
                )
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
