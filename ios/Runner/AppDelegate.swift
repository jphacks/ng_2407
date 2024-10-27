import Flutter
import UIKit
import GoogleMaps
import flutter_config

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // GMSServices.provideAPIKey(FlutterConfigPlugin.env(for: "MAP_API_KEY"))
    GMSServices.provideAPIKey("AIzaSyCMH4WJRGxeCk5VABZBVshqiBysiHgLklQ")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
