import UIKit
import Flutter
import GoogleMaps
import workmanager
import UserNotifications
@main
@objc class AppDelegate: FlutterAppDelegate {
    private let audioChannel =
        "com.qdegrees.shopperxm/audio_recording"
  override func application(
    _ application: UIApplication,
     handleEventsForBackgroundURLSession identifier: String,
        completionHandler: @escaping () -> Void
    ) {
        IOSBackgroundUploadManager.shared.handleBackgroundEvents(
            identifier: identifier,
            completionHandler: completionHandler
        )
    }
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController
                as! FlutterViewController

    let channel = FlutterMethodChannel(
                name: audioChannel,
                binaryMessenger: controller.binaryMessenger
            )
    channel.setMethodCallHandler { call, result in

                switch call.method {

                case "startAudioRecording":

                    guard let details = call.arguments
                        as? [String: Any] else {

                        result(
                            FlutterError(
                                code: "INVALID_ARGUMENTS",
                                message: "Recording details are missing",
                                details: nil
                            )
                        )

                        return
                    }

                    AudioRecordingManager.shared.startRecording(
                        details: details
                    ) { response in

                        DispatchQueue.main.async {

                            switch response {

                            case .success(let data):
                                result(data)

                            case .failure(let error):
                                result(
                                    FlutterError(
                                        code: "START_FAILED",
                                        message: error.localizedDescription,
                                        details: nil
                                    )
                                )
                            }
                        }
                    }

                case "stopAudioRecording":

                    AudioRecordingManager.shared.stopRecording {
                        response in

                        DispatchQueue.main.async {

                            switch response {

                            case .success(let data):
                                result(data)

                            case .failure(let error):
                                result(
                                    FlutterError(
                                        code: "STOP_FAILED",
                                        message: error.localizedDescription,
                                        details: nil
                                    )
                                )
                            }
                        }
                    }

                case "getAudioRecordingStatus":

                    result(
                        AudioRecordingManager.shared.getStatus()
                    )

                default:
                    result(FlutterMethodNotImplemented)
                }
            }


    GMSServices.provideAPIKey("AIzaSyCIkYauCRN1eHkayoQjCRbCwg2pMMiLrhw")

    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }
    GeneratedPluginRegistrant.register(with: self)

    // Set notification delegate for foreground notifications
    UNUserNotificationCenter.current().delegate = self


    let uploadController = FlutterMethodChannel(
        name: "com.qdegrees.shopperxm/ios_background_upload",
        binaryMessenger: window?.rootViewController as! FlutterViewController
    )

    uploadController.setMethodCallHandler { call, result in
        if call.method == "startBackgroundUpload" {
            guard let arguments = call.arguments as? [String: Any] else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid upload arguments",
                        details: nil
                    )
                )
                return
            }

            IOSBackgroundUploadManager.shared.startUpload(
                arguments: arguments
            ) { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let count):
                        result([
                            "success": true,
                            "count": count
                        ])

                    case .failure(let error):
                        result(
                            FlutterError(
                                code: "UPLOAD_START_FAILED",
                                message: error.localizedDescription,
                                details: nil
                            )
                        )
                    }
                }
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    IOSBackgroundUploadManager.shared.resumePendingJobs()

    WorkmanagerPlugin.registerTask(withIdentifier: "com.qdegrees.shopperxm.app.uploadArtifactTask")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Foreground Notification Presentation

  override func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler:
          @escaping (UNNotificationPresentationOptions) -> Void
  ) {
      completionHandler([.banner, .sound, .list])
  }
}
