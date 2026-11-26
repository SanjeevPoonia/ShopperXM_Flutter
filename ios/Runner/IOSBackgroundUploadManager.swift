
import Foundation
import UserNotifications

final class IOSBackgroundUploadManager: NSObject,
    URLSessionDelegate,
    URLSessionTaskDelegate,
    URLSessionDataDelegate {

    static let shared = IOSBackgroundUploadManager()

    private let sessionIdentifier =
        "com.qdegrees.shopperxm.backgroundArtifactUpload"

    private var backgroundCompletionHandler: (() -> Void)?

    private var responseDataByTask: [Int: Data] = [:]

    private lazy var backgroundSession: URLSession = {
        let configuration = URLSessionConfiguration.background(
            withIdentifier: sessionIdentifier
        )

        configuration.isDiscretionary = false
        configuration.sessionSendsLaunchEvents = true
        configuration.httpMaximumConnectionsPerHost = 2

        return URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: nil
        )
    }()

    private let defaults = UserDefaults.standard
    private let jobsKey = "ios_background_upload_jobs"

    private var jobs: [String: [String: Any]] {
        get {
            defaults.dictionary(forKey: jobsKey)
                as? [String: [String: Any]] ?? [:]
        }
        set {
            defaults.set(newValue, forKey: jobsKey)
        }
    }

    private override init() {
        super.init()
        _ = backgroundSession
    }

    // MARK: - Public Methods

    func startUpload(
        arguments: [String: Any],
        completion: @escaping (Result<Int, Error>) -> Void
    ) {

        guard
            let artifacts = arguments["artifacts"] as? [[String: Any]],
            let presignedURL = arguments["presignedApiUrl"] as? String,
            let saveURL = arguments["saveApiUrl"] as? String,
            let token = arguments["token"] as? String,
            let userID = arguments["user_id"] as? String,
            let storeID = arguments["store_id"] as? String
        else {
            completion(.failure(uploadError("Invalid upload arguments.")))
            return
        }

        guard !artifacts.isEmpty else {
            completion(.failure(uploadError("No artifacts found.")))
            return
        }

        guard
            URL(string: presignedURL) != nil,
            URL(string: saveURL) != nil
        else {
            completion(.failure(uploadError("Invalid API URL.")))
            return
        }

        guard !token.isEmpty, !userID.isEmpty, !storeID.isEmpty else {
            completion(
                .failure(uploadError("Missing user, store or token."))
            )
            return
        }

        var currentJobs = jobs
        var createdIDs: [String] = []

        for (index, artifact) in artifacts.enumerated() {

            guard
                let filePath = artifact["file_path"] as? String,
                let fileName = artifact["file_name"] as? String,
                let fileType = artifact["file_type"] as? String,
                FileManager.default.fileExists(atPath: filePath)
            else {
                continue
            }

            let fileURL = URL(fileURLWithPath: filePath)

            guard
                let fileSize = try? fileURL.resourceValues(
                    forKeys: [.fileSizeKey]
                ).fileSize,
                fileSize > 0
            else {
                continue
            }

            let id = UUID().uuidString
            let mimeType = contentType(for: fileName)

            let localDate = (
                (try? FileManager.default.attributesOfItem(
                    atPath: filePath
                )[.modificationDate]) as? Date ?? Date()
            ).description

            let job: [String: Any] = [
                "id": id,
                "file_path": filePath,
                "file_name": fileName,
                "file_type": fileType,
                "content_type": mimeType,
                "local_created_date": localDate,
                "presigned_api_url": presignedURL,
                "save_api_url": saveURL,
                "token": token,
                "user_id": userID,
                "store_id": storeID,
                "beatplan_id": arguments["beat_id"] as? String ?? "",
                "device_id": arguments["device_id"] as? String ?? "flutter_app",
                "status": "waitingForPresign",

                // Notification details
                "queue_index": index + 1,
                "queue_total": artifacts.count,
                "last_notified_progress": 0
            ]

            currentJobs[id] = job
            createdIDs.append(id)
        }

        jobs = currentJobs

        guard !createdIDs.isEmpty else {
            completion(
                .failure(
                    uploadError("No valid files found in upload queue.")
                )
            )
            return
        }

        // Request permission. Uploads continue even if permission is denied.
        requestNotificationPermission()

        for id in createdIDs {
            showUploadNotification(
                id: id,
                title: "ShopperXM - Upload Started",
                message: "Preparing artifact \(queueDescription(for: id))"
            )

            requestPresignedURL(for: id)
        }

        completion(.success(createdIDs.count))
    }

    func setBackgroundCompletionHandler(
        _ handler: @escaping () -> Void
    ) {
        backgroundCompletionHandler = handler
        _ = backgroundSession
    }

    func handleBackgroundEvents(
        identifier: String,
        completionHandler: @escaping () -> Void
    ) {
        guard identifier == sessionIdentifier else {
            completionHandler()
            return
        }

        setBackgroundCompletionHandler(completionHandler)
    }

    // Call on app launch to retry jobs interrupted before
    // their background URLSession task was created.
    func resumePendingJobs() {
        for (id, job) in jobs {
            if job["status"] as? String == "waitingForPresign" {
                requestPresignedURL(for: id)
            }
        }
    }

    // MARK: - Presigned URL

    private func requestPresignedURL(for id: String) {

        guard
            var job = jobs[id],
            let endpoint = job["presigned_api_url"] as? String,
            let fileName = job["file_name"] as? String,
            let mimeType = job["content_type"] as? String,
            let fileType = job["file_type"] as? String
        else {
            return
        }

        let folder: String

        switch fileType {
        case "1":
            folder = "audio"
        case "2":
            folder = "video"
        case "3":
            folder = "img"
        default:
            folder = "store_img"
        }

        guard let url = URL(string: endpoint) else {
            failJob(id, message: "Invalid presigned API URL.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        let body: [String: String] = [
            "file_name": fileName,
            "file_type": mimeType,
            "folder": folder
        ]

        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: body
            )
        } catch {
            failJob(id, message: error.localizedDescription)
            return
        }

        job["status"] = "requestingPresign"
        jobs[id] = job

        URLSession.shared.dataTask(
            with: request
        ) { [weak self] data, response, error in

            guard let self = self else { return }

            if let error = error {
                self.failJob(
                    id,
                    message: error.localizedDescription
                )
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data
            else {
                self.failJob(
                    id,
                    message: "Presigned API returned an invalid response."
                )
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(
                    with: data
                ) as? [String: Any]

                guard
                    let json = json,
                    (json["status"] as? Bool) == true,
                    let dataObject = json["data"] as? [String: Any],
                    let uploadURLString =
                        dataObject["upload_url"] as? String,
                    let fileURL =
                        dataObject["file_url"] as? String,
                    let uploadURL = URL(string: uploadURLString)
                else {
                    self.failJob(
                        id,
                        message: "Invalid presigned URL response."
                    )
                    return
                }

                self.startS3Upload(
                    id: id,
                    uploadURL: uploadURL,
                    fileURL: fileURL
                )

            } catch {
                self.failJob(
                    id,
                    message: error.localizedDescription
                )
            }

        }.resume()
    }

    // MARK: - S3 Background Upload

    private func startS3Upload(
        id: String,
        uploadURL: URL,
        fileURL: String
    ) {

        guard
            var job = jobs[id],
            let filePath = job["file_path"] as? String,
            let mimeType = job["content_type"] as? String
        else {
            return
        }

        let localFileURL = URL(fileURLWithPath: filePath)

        guard FileManager.default.fileExists(atPath: filePath) else {
            failJob(id, message: "Local file no longer exists.")
            return
        }

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "PUT"
        request.setValue(
            mimeType,
            forHTTPHeaderField: "Content-Type"
        )

        // Do not add the app Authorization token to this S3 request.

        let task = backgroundSession.uploadTask(
            with: request,
            fromFile: localFileURL
        )

        job["file_url"] = fileURL
        job["status"] = "uploadingToS3"
        job["task_id"] = task.taskIdentifier
        job["last_notified_progress"] = 0

        jobs[id] = job

        task.taskDescription = "s3|\(id)"
        task.resume()
    }

    // MARK: - Save Metadata

    private func saveMetadata(for id: String) {

        guard
            var job = jobs[id],
            let saveURL = job["save_api_url"] as? String,
            let fileURL = job["file_url"] as? String,
            let token = job["token"] as? String
        else {
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"

        let fields: [String: String] = [
            "user_id": job["user_id"] as? String ?? "",
            "store_id": job["store_id"] as? String ?? "",
            "file_url": fileURL,
            "file_type": job["file_type"] as? String ?? "",
            "Authorization": token,
            "beatplan_id": job["beatplan_id"] as? String ?? "",
            "device_id": job["device_id"] as? String ?? "flutter_app",
            "fileCount": "1",
            "local_path": job["file_path"] as? String ?? "",
            "local_created_date": job["local_created_date"] as? String ?? ""
        ]

        var body = Data()

        for (key, value) in fields {
            body.appendUTF8("--\(boundary)\r\n")
            body.appendUTF8(
                "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            )
            body.appendUTF8("\(value)\r\n")
        }

        body.appendUTF8("--\(boundary)--\r\n")

        do {
            let bodyURL = try writeTemporaryBody(body, id: id)

            guard let url = URL(string: saveURL) else {
                failJob(id, message: "Invalid metadata API URL.")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "multipart/form-data; boundary=\(boundary)",
                forHTTPHeaderField: "Content-Type"
            )
            request.setValue(
                token,
                forHTTPHeaderField: "Authorization"
            )
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Accept"
            )

            let task = backgroundSession.uploadTask(
                with: request,
                fromFile: bodyURL
            )

            job["status"] = "savingMetadata"
            job["metadata_body_path"] = bodyURL.path
            job["task_id"] = task.taskIdentifier

            jobs[id] = job

            task.taskDescription = "meta|\(id)"
            task.resume()

        } catch {
            failJob(id, message: error.localizedDescription)
        }
    }

    // MARK: - URLSession Delegate - Upload Percentage

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {

        guard
            let description = task.taskDescription,
            description.hasPrefix("s3|"),
            totalBytesExpectedToSend > 0
        else {
            return
        }

        let parts = description.split(
            separator: "|",
            maxSplits: 1
        )

        guard parts.count == 2 else {
            return
        }

        let id = String(parts[1])

        let percentage = min(
            100,
            Int(
                (Double(totalBytesSent) /
                 Double(totalBytesExpectedToSend)) * 100
            )
        )

        guard var job = jobs[id] else {
            return
        }

        let lastPercentage =
            job["last_notified_progress"] as? Int ?? 0

        // Update notifications at 10% milestones.
        let milestone = (percentage / 10) * 10

        guard
            milestone >= 10,
            milestone > lastPercentage
        else {
            return
        }

        job["last_notified_progress"] = milestone
        job["upload_percentage"] = percentage

        jobs[id] = job

        print(
            "Artifact upload progress: \(id) = \(percentage)%"
        )

        updateUploadNotification(
            id: id,
            percentage: percentage
        )
    }

    // MARK: - URLSession Delegate - Task Completion

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {

        guard let description = task.taskDescription else {
            return
        }

        let parts = description.split(
            separator: "|",
            maxSplits: 1
        )

        guard parts.count == 2 else {
            return
        }

        let type = String(parts[0])
        let id = String(parts[1])

        if let error = error {
            failJob(
                id,
                message: error.localizedDescription
            )
            return
        }

        let statusCode =
            (task.response as? HTTPURLResponse)?.statusCode ?? 0

        guard (200...299).contains(statusCode) else {
            failJob(
                id,
                message: "\(type) request failed. HTTP \(statusCode)."
            )
            return
        }

        if type == "s3" {

            // S3 upload successful.
            // Now save metadata on your server.
            saveMetadata(for: id)

        } else if type == "meta" {

            let responseData = responseDataByTask.removeValue(
                forKey: task.taskIdentifier
            ) ?? Data()

            do {
                let json = try JSONSerialization.jsonObject(
                    with: responseData
                ) as? [String: Any]

                let status = json?["status"]

                let isSuccess: Bool

                if let number = status as? NSNumber {
                    isSuccess = number.intValue == 1
                } else if let string = status as? String {
                    isSuccess =
                        string == "1" ||
                        string.lowercased() == "true"
                } else {
                    isSuccess = false
                }

                guard isSuccess else {
                    failJob(
                        id,
                        message: "Metadata API did not return success."
                    )
                    return
                }

                finishJob(id)

            } catch {
                failJob(
                    id,
                    message: "Invalid metadata API response: \(error.localizedDescription)"
                )
            }
        }
    }

    // MARK: - URLSession Delegate - Response Data

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {

        let taskID = dataTask.taskIdentifier

        responseDataByTask[taskID, default: Data()].append(data)
    }

    // MARK: - Background Session Completion

    func urlSessionDidFinishEvents(
        forBackgroundURLSession session: URLSession
    ) {

        DispatchQueue.main.async {
            self.backgroundCompletionHandler?()
            self.backgroundCompletionHandler = nil
        }
    }

    // MARK: - Job State

    private func finishJob(_ id: String) {

        guard let job = jobs[id] else {
            return
        }

        let artifactIndex =
            job["queue_index"] as? Int ?? 1

        let totalArtifacts =
            job["queue_total"] as? Int ?? 1

        showUploadNotification(
            id: id,
            title: "ShopperXM - Upload Completed",
            message: "Artifact \(artifactIndex) of \(totalArtifacts) uploaded successfully."
        )

        if let path = job["metadata_body_path"] as? String {
            try? FileManager.default.removeItem(
                atPath: path
            )
        }

        var currentJobs = jobs
        currentJobs.removeValue(forKey: id)
        jobs = currentJobs

        print(
            "Artifact upload and metadata save completed: \(id)"
        )
    }

    private func failJob(
        _ id: String,
        message: String
    ) {

        guard var job = jobs[id] else {
            return
        }

        let artifactIndex =
            job["queue_index"] as? Int ?? 1

        let totalArtifacts =
            job["queue_total"] as? Int ?? 1

        job["status"] = "failed"
        job["error"] = message

        jobs[id] = job

        showUploadNotification(
            id: id,
            title: "ShopperXM - Upload Failed",
            message: "Artifact \(artifactIndex) of \(totalArtifacts) failed: \(message)"
        )

        print(
            "Artifact upload failed [\(id)]: \(message)"
        )
    }

    // MARK: - Upload Notifications

    private func requestNotificationPermission() {

        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]
            ) { granted, error in

                if let error = error {
                    print(
                        "Notification permission error: \(error)"
                    )
                    return
                }

                print(
                    "Upload notification permission: \(granted)"
                )
            }
    }

    private func showUploadNotification(
        id: String,
        title: String,
        message: String
    ) {

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default

        let notificationID = "artifact-upload-\(id)"

        let request = UNNotificationRequest(
            identifier: notificationID,
            content: content,
            trigger: nil
        )

        let center = UNUserNotificationCenter.current()

        // Replace the previous delivered notification
        // for this artifact.
        center.removePendingNotificationRequests(
            withIdentifiers: [notificationID]
        )

        center.removeDeliveredNotifications(
            withIdentifiers: [notificationID]
        )

        center.add(request) { error in
            if let error = error {
                print(
                    "Upload notification error: \(error)"
                )
            }
        }
    }

    private func updateUploadNotification(
        id: String,
        percentage: Int
    ) {

        guard let job = jobs[id] else {
            return
        }

        let artifactIndex =
            job["queue_index"] as? Int ?? 1

        let totalArtifacts =
            job["queue_total"] as? Int ?? 1

        showUploadNotification(
            id: id,
            title: "ShopperXM - Uploading Artifacts",
            message: "Artifact \(artifactIndex) of \(totalArtifacts) — Uploading: \(percentage)%"
        )
    }

    private func queueDescription(for id: String) -> String {

        guard let job = jobs[id] else {
            return ""
        }

        let index = job["queue_index"] as? Int ?? 1
        let total = job["queue_total"] as? Int ?? 1

        return "\(index) of \(total)"
    }

    // MARK: - Helpers

    private func contentType(for fileName: String) -> String {

        let ext = URL(fileURLWithPath: fileName)
            .pathExtension
            .lowercased()

        switch ext {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "heic":
            return "image/heic"
        case "mp4":
            return "video/mp4"
        case "mov":
            return "video/quicktime"
        case "m4a":
            return "audio/mp4"
        case "mp3":
            return "audio/mpeg"
        case "aac":
            return "audio/aac"
        case "wav":
            return "audio/wav"
        case "wma":
            return "audio/x-ms-wma"
        default:
            return "application/octet-stream"
        }
    }

    private func writeTemporaryBody(
        _ data: Data,
        id: String
    ) throws -> URL {

        let directory = FileManager.default.temporaryDirectory

        let url = directory.appendingPathComponent(
            "metadata_\(id).body"
        )

        try data.write(
            to: url,
            options: .atomic
        )

        return url
    }

    private func uploadError(_ message: String) -> NSError {

        NSError(
            domain: "IOSBackgroundUpload",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey: message
            ]
        )
    }
}

// MARK: - Data Extension

private extension Data {

    mutating func appendUTF8(_ string: String) {

        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
