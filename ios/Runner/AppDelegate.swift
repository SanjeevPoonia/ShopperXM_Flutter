import UIKit
import Flutter
import GoogleMaps
import workmanager
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   GMSServices.provideAPIKey("AIzaSyCIkYauCRN1eHkayoQjCRbCwg2pMMiLrhw")
    GeneratedPluginRegistrant.register(with: self)
    WorkmanagerPlugin.registerTask(withIdentifier: "com.qdegrees.shopperxm.app.uploadArtifactTask")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
