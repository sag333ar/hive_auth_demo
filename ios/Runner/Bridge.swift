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
            name: "blog.hive.auth/auth",
            binaryMessenger: controller.binaryMessenger
        )

        authChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            switch (call.method) {
                case "hiveAuthString":
                    guard
                        let arguments = call.arguments as? NSDictionary,
                        let username = arguments ["username"] as? String
                    else {
                        result(FlutterMethodNotImplemented)
                        return
                    }
                    self?.getHiveAuthString(username: username, result: result)
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
    }

    private func getHiveAuthString(username: String, result: @escaping FlutterResult) {
        guard let hiveController = hiveController else {
            result(FlutterError(code: "ERROR",
                                message: "Error setting up Hive",
                                details: nil))
            return
        }
        hiveController.getHiveAuthString(username) { string in
            result(string)
        }
    }
}
