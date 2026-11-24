import UIKit
import Flutter
import GoogleMaps
import workmanager
@main
@objc class AppDelegate: FlutterAppDelegate {
    private let audioChannel =
        "com.qdegrees.shopperxm/audio_recording"
  override func application(
    _ application: UIApplication,
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
    GeneratedPluginRegistrant.register(with: self)
    WorkmanagerPlugin.registerTask(withIdentifier: "com.qdegrees.shopperxm.app.uploadArtifactTask")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
