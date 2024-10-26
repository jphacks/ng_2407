import Flutter
import UIKit
import GoogleMaps  // Add this import
import flutter_config  // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey(FlutterConfigPlugin.env(for: "MAP_API_KEY"))  
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
