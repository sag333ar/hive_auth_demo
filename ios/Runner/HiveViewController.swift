//
//  HiveViewController.swift
//  Runner
//
//  Created by Sagar on 24/11/22.
//

import UIKit
import WebKit

class HiveViewController: UIViewController {
    let hive = "hive"
    let config = WKWebViewConfiguration()
    let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
    var webView: WKWebView?
    var didFinish = false
    var hiveAuthStringHandler: ((String) -> Void)? = nil
    var hiveUserInfoHandler: ((String) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        config.userContentController.add(self, name: hive)
        webView = WKWebView(frame: rect, configuration: config)
        webView?.navigationDelegate = self
        guard
            let path = Bundle.main.path(forResource: "newIndex", ofType: "html")
        else { return }
        let url = URL(fileURLWithPath: path)
        let dir = url.deletingLastPathComponent()
        webView?.loadFileURL(url, allowingReadAccessTo: dir)
    }

    func getHiveAuthString(_ username: String, handler: @escaping (String) -> Void) {
        hiveAuthStringHandler = handler
        webView?.evaluateJavaScript("click_login('\(username)');")
    }

    func getUserInfo(_ handler: @escaping (String) -> Void) {
        hiveUserInfoHandler = handler
        webView?.evaluateJavaScript("getUserInfo();")
    }
}

extension HiveViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinish = true
    }
}

extension HiveViewController: WKScriptMessageHandler {
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == hive else { return }
        guard let dict = message.body as? [String: AnyObject] else { return }
        guard let type = dict["type"] as? String else { return }
        switch type {
            case "hiveAuthString":
                guard
                    let isValid = dict["valid"] as? Bool,
                    let accountName = dict["username"] as? String,
                    let error = dict["error"] as? String,
                    let response = ValidHiveResponse.jsonStringFrom(dict: dict)
                else { return }
                hiveAuthStringHandler?(response)
            case "hiveAuthUserInfo":
                guard
                    let isValid = dict["valid"] as? Bool,
                    let accountName = dict["username"] as? String,
                    let error = dict["error"] as? String,
                    let response = ValidHiveResponse.jsonStringFrom(dict: dict)
                else { return }
                hiveUserInfoHandler?(response)
            default: debugPrint("Do nothing here.")
        }
    }
}

struct ValidHiveResponse: Codable {
    let valid: Bool
    let username: String?
    let error: String

    static func jsonStringFrom(dict: [String: AnyObject]) -> String? {
        guard
            let isValid = dict["valid"] as? Bool,
            let error = dict["error"] as? String
        else { return nil }
        let response = ValidHiveResponse(
            valid: isValid,
            username: dict["username"] as? String,
            error: error
        )
        guard let data = try? JSONEncoder().encode(response) else { return nil }
        guard let dataString = String(data: data, encoding: .utf8) else { return nil }
        return dataString
    }
}
