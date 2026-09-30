import 'dart:developer';
import 'dart:io';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/login_screen.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/start_screen.dart';
import 'package:shopperxm_flutter/screen/splash_screen.dart';
import 'package:shopperxm_flutter/utils/app_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/widgets/app_startup_gate.dart';
import 'package:workmanager/workmanager.dart';
import 'network/constants.dart';
import 'dart:convert';


/*@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Work Manageer executed");
    var notifications = FlutterLocalNotificationsPlugin();
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_ic');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        String? payload = response.payload;
      },
    );

    *//*var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );*//*
    *//*var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {},
    );*//*
    *//* FormData formData = FormData.fromMap({
      "user_id": AppModel.userID,
      "Orignal_Name": inputData!["filesPath"].split('/').last,
      "fileCount": "1",
      "file": await MultipartFile.fromFile(inputData["filesPath"]),
      "Authorization": AppModel.token,
      "store_id": inputData["store_id"],
      "beatplan_id": ["beat_id"],
      "file_type": "2",
    });
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "saveMultipleOverallVideo");
    print("Service running");
*//*

    ChunkedUploader chunkedUploader = ChunkedUploader(
      Dio(
        BaseOptions(
          baseUrl: AppConstant.appBaseURL,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Connection': 'Keep-Alive',
            'Authorization': inputData!["token"],
          },
        ),
      ),
    );
    try {
      Response? response = await chunkedUploader.uploadUsingFilePath(
        fileKey: "file",
        method: "POST",
        filePath: inputData["filesPath"],
        maxChunkSize: 500000000,
        fileName: inputData["filesPath"].split('/').last,
        path: "/saveMultipleOverallVideo",
        data: {
          "user_id": inputData["user_id"],
          "Orignal_Name": inputData["filesPath"].split('/').last,
          "fileCount": "1",
          "Authorization": inputData["token"],
          "store_id": inputData["store_id"],
          "beatplan_id": inputData["beat_id"],
          "file_type": inputData["file_type"],
        },
        onUploadProgress: (v) {
          if (kDebugMode) {
            print(v);
          }

          double progress = v;

          progress = progress * 100;

          notifications.show(
            123,
            progress.toInt() == 100
                ? 'File uploaded successfully'
                : 'Uploading file',
            progress.toInt() == 100
                ? 'Upload Completed'
                : 'Upload in Progress (' + progress.toInt().toString() + "%)",
            NotificationDetails(
              android: AndroidNotificationDetails(
                'FlutterUploader.Example',
                'FlutterUploader',
                channelDescription:
                    'Installed when you activate the Flutter Uploader Example',
                progress: progress.toInt(),
                icon: 'arrow_down',
                enableVibration: false,
                importance: Importance.low,
                showProgress: true,
                onlyAlertOnce: true,
                maxProgress: 100,
                channelShowBadge: false,
              ),
            //  iOS: const IOSNotificationDetails(),
              iOS: const DarwinNotificationDetails(),
            ),
          );
        },
      );
      if (kDebugMode) {
        print(response);
      }

      var data = response?.data;

      print(data.toString());
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

*//*
    var response = await dio.post(
        AppConstant.appBaseURL + "saveMultipleOverallVideo",
        data: formData, onSendProgress: (int sent, int total) {
      double progress = sent / total;
      print('progress: $progress ($sent/$total)');
      progress = progress * 100;

      notifications.show(
        123,
        progress.toInt()==100?'Video uploaded successfully':
        'Uploading video',
          progress.toInt()==100?'Upload Completed':
        'Upload in Progress (' + progress.toInt().toString() + "%)",
        NotificationDetails(
          android: AndroidNotificationDetails(
            'FlutterUploader.Example',
            'FlutterUploader',
            channelDescription:
            'Installed when you activate the Flutter Uploader Example',
            progress: progress.toInt(),
            icon: 'arrow_down',
            enableVibration: false,
            importance: Importance.low,
            showProgress: true,
            onlyAlertOnce: true,
            maxProgress: 100,
            channelShowBadge: false,
          ),
          iOS: const IOSNotificationDetails(),
        ),
      );
    });*//*
    // log(response.data);

    print("Service completed");

    return Future.value(true);
  });
}*/
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Work Manager executed");

    final notifications = FlutterLocalNotificationsPlugin();

    const androidSettings =
    AndroidInitializationSettings('app_ic');

    const iosSettings =
    DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        final payload = response.payload;
      },
    );

    const AndroidNotificationChannel uploadChannel =
    AndroidNotificationChannel(
      'video_upload_channel',
      'Video Upload',
      description: 'Shows video upload progress',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
      showBadge: false,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(uploadChannel);

    /*try {
      final filePath = inputData!["filesPath"].toString();
      final fileName = filePath.split('/').last;

      print("======================================");
      print("Background video upload started");
      print("File: $filePath");
      print("File name: $fileName");
      print("======================================");

      final file = File(filePath);

      if (!await file.exists()) {
        print("ERROR: Video file does not exist");

        return false;
      }

      final formData = FormData.fromMap({
        "user_id": inputData["user_id"],
        "Orignal_Name": fileName,
        "fileCount": "1",
        "file": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        "Authorization": inputData["token"],
        "store_id": inputData["store_id"],
        "beatplan_id": inputData["beat_id"],
        "file_type": inputData["file_type"],
      });

      final dio = Dio();

      dio.options.headers = {
        "Accept": "application/json",
        "Authorization": inputData["token"],
      };

      final url =
          AppConstant.appBaseURL +
              "saveMultipleOverallVideo";

      print("Upload URL: $url");

      final response = await dio.post(
        url,
        data: formData,
        onSendProgress: (sent, total) {
          if (total <= 0) return;

          final percentage =
          ((sent / total) * 100).toInt();

          print(
            "Upload progress: $percentage% "
                "($sent/$total)",
          );

          notifications.show(
            123,
            percentage >= 100
                ? "Video uploaded successfully"
                : "Uploading video",
            percentage >= 100
                ? "Upload Completed"
                : "Upload in Progress ($percentage%)",
            NotificationDetails(
              android: AndroidNotificationDetails(
                'video_upload_channel',
                'Video Upload',
                channelDescription: 'Shows video upload progress',
                progress: percentage,
                maxProgress: 100,
                showProgress: true,
                onlyAlertOnce: true,
                playSound: false,
                enableVibration: false,
                importance: Importance.low,
                priority: Priority.low,
                channelShowBadge: false,
                icon: 'app_ic',
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );
        },
      );

      print("======================================");
      print("Server response:");
      print(response.data);
      print("======================================");

      if (response.statusCode == 200) {
        print("Video uploaded successfully");
        print("Service completed");

        return true;
      }

      print(
        "Upload failed. HTTP status: "
            "${response.statusCode}",
      );

      return false;

    } on DioException catch (e) {
      print("======================================");
      print("DIO UPLOAD ERROR");
      print("Status: ${e.response?.statusCode}");
      print("Response: ${e.response?.data}");
      print("Message: ${e.message}");
      print("======================================");

      return false;

    } catch (e, stackTrace) {
      print("======================================");
      print("UPLOAD ERROR");
      print(e);
      print(stackTrace);
      print("======================================");

      return false;
    }*/
    try {
      // ============================================================
      // READ INPUT DATA
      // ============================================================

      final String artifactsJson =
          inputData?["artifacts"]?.toString() ?? "";

      print("======================================");
      print("WORK MANAGER EXECUTED");
      print("Task: $task");
      print("Artifacts JSON:");
      print(artifactsJson);
      print("======================================");

      if (artifactsJson.isEmpty || artifactsJson == "null") {
        print("ERROR: artifacts data is missing");
        return false;
      }

      final dynamic decodedData = jsonDecode(artifactsJson);

      if (decodedData is! List) {
        print("ERROR: artifacts is not a List");
        return false;
      }

      final List<dynamic> artifacts = decodedData;

      final String beatId =
          inputData?["beat_id"]?.toString() ?? "";

      final String storeId =
          inputData?["store_id"]?.toString() ?? "";

      final String userId =
          inputData?["user_id"]?.toString() ?? "";

      final String token =
          inputData?["token"]?.toString() ?? "";

      final int totalFiles = artifacts.length;

      print("======================================");
      print("BACKGROUND ARTIFACT UPLOAD");
      print("Total files in queue: $totalFiles");
      print("Beat ID: $beatId");
      print("Store ID: $storeId");
      print("User ID: $userId");
      print("======================================");

      // ============================================================
      // NOTHING TO UPLOAD
      // ============================================================

      if (totalFiles == 0) {
        print("No files in upload queue.");

        await notifications.show(
          123,
          "Upload queue empty",
          "No files to upload",
          NotificationDetails(
            android: AndroidNotificationDetails(
              'video_upload_channel',
              'Video Upload',
              channelDescription: 'Shows upload progress',
              importance: Importance.low,
              priority: Priority.low,
              icon: 'app_ic',
              showProgress: false,
              playSound: false,
              enableVibration: false,
              channelShowBadge: false,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );

        return true;
      }

      // ============================================================
      // INITIAL QUEUE NOTIFICATION
      // ============================================================

      await notifications.show(
        123,
        "Upload queue",
        "$totalFiles file(s) waiting to upload",
        NotificationDetails(
          android: AndroidNotificationDetails(
            'video_upload_channel',
            'Video Upload',
            channelDescription: 'Shows upload progress',
            importance: Importance.low,
            priority: Priority.low,
            icon: 'app_ic',
            showProgress: true,
            progress: 0,
            maxProgress: 100,
            onlyAlertOnce: true,
            playSound: false,
            enableVibration: false,
            channelShowBadge: false,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );

      // ============================================================
      // UPLOAD FILES ONE BY ONE
      // ============================================================

      for (int i = 0; i < totalFiles; i++) {
        final dynamic item = artifacts[i];

        if (item is! Map) {
          print("ERROR: Artifact $i is not a Map");
          return false;
        }

        final Map<String, dynamic> artifact =
        Map<String, dynamic>.from(item);

        // ----------------------------------------------------------
        // READ FILE INFORMATION
        // ----------------------------------------------------------

        final dynamic pathValue = artifact["file_path"];
        final dynamic nameValue = artifact["file_name"];
        final dynamic typeValue = artifact["file_type"];

        if (pathValue == null ||
            pathValue.toString().trim().isEmpty ||
            pathValue.toString() == "null") {
          print("ERROR: file_path is null for artifact ${i + 1}");
          print("Artifact data: $artifact");

          await notifications.show(
            123,
            "Upload failed",
            "File ${i + 1} has no file path",
            NotificationDetails(
              android: AndroidNotificationDetails(
                'video_upload_channel',
                'Video Upload',
                channelDescription: 'Shows upload progress',
                importance: Importance.low,
                priority: Priority.low,
                icon: 'app_ic',
                playSound: false,
                enableVibration: false,
                channelShowBadge: false,
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );

          return false;
        }

        final String filePath = pathValue.toString();

        final String fileName =
            nameValue?.toString() ??
                filePath.split(Platform.pathSeparator).last;

        final String fileType =
            typeValue?.toString() ?? "";

        // ----------------------------------------------------------
        // QUEUE COUNTERS
        // ----------------------------------------------------------

        final int uploadedFiles = i;
        final int remainingFiles = totalFiles - i;

        print("--------------------------------------");
        print("UPLOAD FILE ${i + 1}/$totalFiles");
        print("File name      : $fileName");
        print("File type      : $fileType");
        print("File path      : $filePath");
        print("Uploaded       : $uploadedFiles");
        print("Remaining      : $remainingFiles");
        print("--------------------------------------");

        // ----------------------------------------------------------
        // CHECK FILE EXISTS
        // ----------------------------------------------------------

        final File file = File(filePath);

        final bool fileExists = await file.exists();

        if (!fileExists) {
          print("ERROR: File does not exist");
          print("Path: $filePath");

          await notifications.show(
            123,
            "Upload failed",
            "$fileName not found\n"
                "Uploaded: $uploadedFiles/$totalFiles\n"
                "Remaining: $remainingFiles",
            NotificationDetails(
              android: AndroidNotificationDetails(
                'video_upload_channel',
                'Video Upload',
                channelDescription: 'Shows upload progress',
                importance: Importance.low,
                priority: Priority.low,
                icon: 'app_ic',
                showProgress: false,
                playSound: false,
                enableVibration: false,
                channelShowBadge: false,
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );

          return false;
        }

        // ----------------------------------------------------------
        // FILE SIZE
        // ----------------------------------------------------------

        final int fileSize = await file.length();

        print("File size: $fileSize bytes");

        // ----------------------------------------------------------
        // MULTIPART DATA
        // ----------------------------------------------------------

        final FormData formData = FormData.fromMap({
          "user_id": userId,
          "Orignal_Name": fileName,
          "fileCount": "1",
          "file": await MultipartFile.fromFile(
            filePath,
            filename: fileName,
          ),
          "Authorization": token,
          "store_id": storeId,
          "beatplan_id": beatId,
          "file_type": fileType,
        });

        // ----------------------------------------------------------
        // DIO
        // ----------------------------------------------------------

        final Dio dio = Dio();

        dio.options.headers = {
          "Accept": "application/json",
          "Authorization": token,
        };

        final String url =
            AppConstant.appBaseURL +
                "saveMultipleOverallVideo";

        // ----------------------------------------------------------
        // UPLOAD
        // ----------------------------------------------------------

        final response = await dio.post(
          url,
          data: formData,
          onSendProgress: (sent, total) async {
            if (total <= 0) {
              return;
            }

            final int filePercentage =
            ((sent / total) * 100).toInt();

            // Number of files completed before current file
            final int completedBeforeCurrent = i;

            // Current file progress from 0 to 1
            final double currentProgress =
                sent / total;

            // Overall progress
            final double overallProgress =
                (completedBeforeCurrent + currentProgress) /
                    totalFiles;

            final int overallPercentage =
            (overallProgress * 100)
                .clamp(0, 100)
                .toInt();

            final int uploadedCount =
            filePercentage >= 100
                ? i + 1
                : i;

            final int remainingCount =
                totalFiles - uploadedCount;

            print(
              "FILE: $fileName | "
                  "File: $filePercentage% | "
                  "Overall: $overallPercentage% | "
                  "Uploaded: $uploadedCount | "
                  "Remaining: $remainingCount",
            );

            await notifications.show(
              123,
              "Uploading $fileName",
              "File $filePercentage% • "
                  "Uploaded: $uploadedCount/$totalFiles • "
                  "Remaining: $remainingCount",
              NotificationDetails(
                android: AndroidNotificationDetails(
                  'video_upload_channel',
                  'Video Upload',
                  channelDescription: 'Shows upload progress',
                  importance: Importance.low,
                  priority: Priority.low,
                  icon: 'app_ic',
                  progress: overallPercentage,
                  maxProgress: 100,
                  showProgress: true,
                  onlyAlertOnce: true,
                  playSound: false,
                  enableVibration: false,
                  channelShowBadge: false,
                ),
                iOS: const DarwinNotificationDetails(),
              ),
            );
          },
        );

        // ----------------------------------------------------------
        // SERVER RESPONSE
        // ----------------------------------------------------------

        print("--------------------------------------");
        print("SERVER RESPONSE");
        print("File: $fileName");
        print("Status: ${response.statusCode}");
        print("Response: ${response.data}");
        print("--------------------------------------");

        if (response.statusCode != 200) {
          print(
            "HTTP ERROR: ${response.statusCode}",
          );

          await notifications.show(
            123,
            "Upload failed",
            "$fileName\n"
                "Uploaded: $i/$totalFiles\n"
                "Remaining: ${totalFiles - i}",
            NotificationDetails(
              android: AndroidNotificationDetails(
                'video_upload_channel',
                'Video Upload',
                channelDescription: 'Shows upload progress',
                importance: Importance.low,
                priority: Priority.low,
                icon: 'app_ic',
                showProgress: false,
                playSound: false,
                enableVibration: false,
                channelShowBadge: false,
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );

          return false;
        }

        // ----------------------------------------------------------
        // CHECK API STATUS
        // ----------------------------------------------------------

        final dynamic responseData = response.data;

        if (responseData is Map &&
            responseData["status"] != null &&
            responseData["status"].toString() != "1") {
          print(
            "SERVER REJECTED FILE: $fileName",
          );

          await notifications.show(
            123,
            "Upload failed",
            "$fileName rejected by server\n"
                "Uploaded: $i/$totalFiles\n"
                "Remaining: ${totalFiles - i}",
            NotificationDetails(
              android: AndroidNotificationDetails(
                'video_upload_channel',
                'Video Upload',
                channelDescription: 'Shows upload progress',
                importance: Importance.low,
                priority: Priority.low,
                icon: 'app_ic',
                showProgress: false,
                playSound: false,
                enableVibration: false,
                channelShowBadge: false,
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );

          return false;
        }

        // ----------------------------------------------------------
        // FILE SUCCESSFULLY UPLOADED
        // ----------------------------------------------------------

        final int uploadedCount = i + 1;
        final int remainingCount =
            totalFiles - uploadedCount;

        print("SUCCESS: $fileName");
        print("Uploaded: $uploadedCount/$totalFiles");
        print("Remaining: $remainingCount");

        // ----------------------------------------------------------
        // FILE COMPLETED NOTIFICATION
        // ----------------------------------------------------------

        await notifications.show(
          123,
          "Uploading files",
          "$fileName uploaded\n"
              "Uploaded: $uploadedCount/$totalFiles\n"
              "Remaining: $remainingCount",
          NotificationDetails(
            android: AndroidNotificationDetails(
              'video_upload_channel',
              'Video Upload',
              channelDescription: 'Shows upload progress',
              importance: Importance.low,
              priority: Priority.low,
              icon: 'app_ic',
              showProgress: true,
              progress:
              ((uploadedCount / totalFiles) * 100)
                  .toInt(),
              maxProgress: 100,
              onlyAlertOnce: true,
              playSound: false,
              enableVibration: false,
              channelShowBadge: false,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }

      // ============================================================
      // ALL FILES COMPLETED
      // ============================================================

      await notifications.show(
        123,
        "Upload completed",
        "$totalFiles/$totalFiles files uploaded successfully",
        NotificationDetails(
          android: AndroidNotificationDetails(
            'video_upload_channel',
            'Video Upload',
            channelDescription: 'Shows upload progress',
            importance: Importance.low,
            priority: Priority.low,
            icon: 'app_ic',
            showProgress: false,
            onlyAlertOnce: true,
            playSound: false,
            enableVibration: false,
            channelShowBadge: false,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );

      print("======================================");
      print("ALL FILES UPLOADED");
      print("Total: $totalFiles");
      print("======================================");

      return true;

    } on DioException catch (e) {
      print("======================================");
      print("DIO UPLOAD ERROR");
      print("Status: ${e.response?.statusCode}");
      print("Response: ${e.response?.data}");
      print("Message: ${e.message}");
      print("======================================");

      await notifications.show(
        123,
        "Upload failed",
        e.message ?? "Network error while uploading",
        NotificationDetails(
          android: AndroidNotificationDetails(
            'video_upload_channel',
            'Video Upload',
            channelDescription: 'Shows upload progress',
            importance: Importance.low,
            priority: Priority.low,
            icon: 'app_ic',
            showProgress: false,
            playSound: false,
            enableVibration: false,
            channelShowBadge: false,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );

      return false;

    } catch (e, stackTrace) {
      print("======================================");
      print("BACKGROUND UPLOAD ERROR");
      print(e);
      print(stackTrace);
      print("======================================");

      await notifications.show(
        123,
        "Upload failed",
        e.toString(),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'video_upload_channel',
            'Video Upload',
            channelDescription: 'Shows upload progress',
            importance: Importance.low,
            priority: Priority.low,
            icon: 'app_ic',
            showProgress: false,
            playSound: false,
            enableVibration: false,
            channelShowBadge: false,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );

      return false;
    }
  });
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(callbackDispatcher);

  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token') ?? '';
  String? userID = prefs.getString('user_id') ?? '';
  String? userType = prefs.getString('usertype') ?? '';
  print(token);
  if (token != '') {
    AppModel.setTokenValue(token.toString());
    AppModel.setLoginToken(true);
    AppModel.setUserID(userID);
    AppModel.setUserType(userType);
  }

  runApp(
    AppStartupGate(child: MyApp(token))
  );
}

class MyApp extends StatelessWidget {
  final String token;

  MyApp(this.token);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ShopperXM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Poppins'),
        home: SplashScreen(token));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
