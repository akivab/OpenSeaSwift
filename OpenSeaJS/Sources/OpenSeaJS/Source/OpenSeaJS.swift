import JavaScriptCore
import Foundation
import WebKit

public enum OpenSeaJSError: Error {
    case generic(_ str: String)
}
public struct OpenSeaJS {
    let webKitView: WKWebView
    init() throws {
        webKitView = WKWebView()
        try loadJS()
    }

    func loadJS() throws {
        guard let url = Bundle.module.url(
            forResource: "OpenSeaJS.bundle",
            withExtension: "js"
        ) else {
            throw OpenSeaJSError.generic("URL not found")
        }
        runJavascript(try String(contentsOf: url))
    }

    func runJavascript(
        _ str: String,
        callback: ((Result<String, Error>?) -> Void)? = nil
    ) {
        webKitView.evaluateJavaScript(str) { res, err in
            if let err = err {
                callback?(.failure(err))
                return
            }
            callback?(.success((res as? String) ?? str))
        }
    }
}
