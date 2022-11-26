import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var hive: HiveViewController?
    let bridge = Bridge()
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        hive = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HiveViewController") as? HiveViewController
        hive?.viewDidLoad()
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        bridge.initiate(controller: controller, window: window, hiveController: hive)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
