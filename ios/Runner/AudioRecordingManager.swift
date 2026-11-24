import Foundation
import AVFoundation

final class AudioRecordingManager: NSObject, AVAudioRecorderDelegate {

    static let shared = AudioRecordingManager()

    private var recorder: AVAudioRecorder?

    private let defaults = UserDefaults.standard

    private let recordingKey = "shopperxm_audio_recording"

    private override init() {
        super.init()
    }

    private var recordingFolder: URL {

        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documents.appendingPathComponent(
            "ShopperXM",
            isDirectory: true
        )
    }

    private func createFolder() throws {

        try FileManager.default.createDirectory(
            at: recordingFolder,
            withIntermediateDirectories: true
        )
    }

    func startRecording(
        details: [String: Any],
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {

        let session = AVAudioSession.sharedInstance()

        session.requestRecordPermission { [weak self] granted in

            guard let self = self else { return }

            guard granted else {

                let error = NSError(
                    domain: "ShopperXM.Audio",
                    code: 1001,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Microphone permission denied"
                    ]
                )

                completion(.failure(error))
                return
            }

            do {

                try self.createFolder()

                try session.setCategory(
                    .record,
                    mode: .default,
                    options: []
                )

                try session.setActive(true)

                let recordingId =
                    details["recordingId"] as? String
                    ?? UUID().uuidString

                let storeName =
                    details["storeName"] as? String
                    ?? "Store"

                let safeName = storeName
                    .replacingOccurrences(
                        of: "[^a-zA-Z0-9_-]",
                        with: "_",
                        options: .regularExpression
                    )

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd_HHmmss"

                let date = formatter.string(from: Date())

                let fileName =
                    "\(safeName)_\(date)_\(recordingId.prefix(8)).m4a"

                let fileURL = self.recordingFolder
                    .appendingPathComponent(fileName)

                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey:
                        AVAudioQuality.high.rawValue
                ]

                let audioRecorder = try AVAudioRecorder(
                    url: fileURL,
                    settings: settings
                )

                audioRecorder.delegate = self

                audioRecorder.prepareToRecord()

                guard audioRecorder.record() else {

                    throw NSError(
                        domain: "ShopperXM.Audio",
                        code: 1002,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "Unable to start audio recording"
                        ]
                    )
                }

                self.recorder = audioRecorder

                var savedDetails = details

                savedDetails["recordingId"] = recordingId
                savedDetails["fileName"] = fileName
                savedDetails["filePath"] = fileURL.path
                savedDetails["status"] = "recording"
                savedDetails["startedAt"] =
                    ISO8601DateFormatter().string(from: Date())

                self.defaults.set(
                    savedDetails,
                    forKey: self.recordingKey
                )

                completion(.success(savedDetails))

            } catch {

                completion(.failure(error))
            }
        }
    }

    func stopRecording(
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {

        guard let audioRecorder = recorder else {

            completion(.failure(
                NSError(
                    domain: "ShopperXM.Audio",
                    code: 1003,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "No active recording found"
                    ]
                )
            ))

            return
        }

        audioRecorder.stop()

        let fileURL = audioRecorder.url

        recorder = nil

        do {
            try AVAudioSession.sharedInstance()
                .setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            // Recording has stopped; audio session cleanup can be retried.
        }

        var savedDetails =
            defaults.dictionary(forKey: recordingKey) ?? [:]

        savedDetails["status"] = "completed"
        savedDetails["filePath"] = fileURL.path
        savedDetails["stoppedAt"] =
            ISO8601DateFormatter().string(from: Date())

        defaults.set(
            savedDetails,
            forKey: recordingKey
        )

        completion(.success(savedDetails))
    }

    func getStatus() -> [String: Any] {

        let details =
            defaults.dictionary(forKey: recordingKey) ?? [:]

        let active = recorder?.isRecording ?? false

        return [
            "isRecording": active,
            "recordingDetails": details
        ]
    }

    func audioRecorderEncodeErrorDidOccur(
        _ recorder: AVAudioRecorder,
        error: Error?
    ) {

        self.recorder = nil

        var details =
            defaults.dictionary(forKey: recordingKey) ?? [:]

        details["status"] = "interrupted"
        details["error"] = error?.localizedDescription ?? "Recording error"

        defaults.set(
            details,
            forKey: recordingKey
        )
    }
}
