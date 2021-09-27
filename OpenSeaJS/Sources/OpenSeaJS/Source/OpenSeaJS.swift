import JavaScriptCore
import Foundation
import WebKit

public enum OpenSeaJSError: Error {
    case generic(_ str: String)
}
public struct OpenSeaJS {
    let webKitView: WKWebView
    static func createWebView() -> WKWebView {
        DispatchQueue.main.sync {
            return WKWebView()
        }
    }
    init() async throws {
        webKitView = OpenSeaJS.createWebView()
        guard let url = Bundle.module.url(
            forResource: "OpenSeaJS.bundle",
            withExtension: "js"
        ) else {
            throw OpenSeaJSError.generic("URL not found")
        }
        _ = await runJavascript(try String(contentsOf: url))
    }

    func runJavascript(_ str: String) async -> Result<String, Error> {
        do {
            guard let result = try await webKitView.evaluateJavaScript(str) as? String else {
                return .success("couldn't evaluate: \(str)")
            }
            return .success(result)
        } catch let err {
            return .failure(err)
        }
    }
}
