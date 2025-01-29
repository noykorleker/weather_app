import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationWillTerminate(_ application: UIApplication) {
        // Detect app termination
        print("App is being terminated.")

        // Safely check if the rootViewController is a FlutterViewController
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(
                name: "app_events",
                binaryMessenger: controller.binaryMessenger
            )
            do {
                try channel.invokeMethod("onAppTerminated", nil)
            } catch {
                print("Error invoking onAppTerminated: \(error)")
            }
        } else {
            print("RootViewController is not a FlutterViewController")
        }
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        // Detect app entering background
        print("App entered background.")

        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(
                name: "app_events",
                binaryMessenger: controller.binaryMessenger
            )
            do {
                try channel.invokeMethod("onAppBackgrounded", nil)
            } catch {
                print("Error invoking onAppBackgrounded: \(error)")
            }
        } else {
            print("RootViewController is not a FlutterViewController")
        }
    }
}
