//
//  Bridge.swift
//  Runner
//
//  Created by Sagar on 24/11/22.
//

import Foundation
import UIKit
import Flutter

class Bridge {
    var window: UIWindow?
    var hiveController: HiveViewController?

    func initiate(
        controller: FlutterViewController,
        window: UIWindow?,
        hiveController: HiveViewController?
    ) {
        self.window = window
        self.hiveController = hiveController
        let authChannel = FlutterMethodChannel(
            name: "blog.hive.auth/bridge",
            binaryMessenger: controller.binaryMessenger
        )

        authChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            switch (call.method) {
                case "_f2n_get_redirect_uri":
                    guard
                        let arguments = call.arguments as? NSDictionary,
                        let username = arguments ["username"] as? String
                    else {
                        result(FlutterMethodNotImplemented)
                        return
                    }
                    self?.getRedirectUri(username: username, result: result)
                case "getUserInfo":
                    self?.getUserInfo(result: result)
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
    }

    private func getUserInfo(result: @escaping FlutterResult) {
        guard let hiveController = hiveController else {
            result(FlutterError(code: "ERROR",
                                message: "Error setting up Hive",
                                details: nil))
            return
        }
        hiveController.getUserInfo { string in
            result(string)
        }
    }

    private func getRedirectUri(username: String, result: @escaping FlutterResult) {
        guard let hiveController = hiveController else {
            result(FlutterError(code: "ERROR",
                                message: "Error setting up Hive",
                                details: nil))
            return
        }
        hiveController.getRedirectUri(username) { string in
            result(string)
        }
    }
}
