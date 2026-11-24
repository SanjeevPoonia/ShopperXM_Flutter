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

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('WorkManager executed: $task');
    final notifications = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('app_ic');
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await notifications.initialize(initializationSettings);
    const uploadChannel = AndroidNotificationChannel(
      'video_upload_channel',
      'Video Upload',
      description: 'Shows video upload progress',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
      showBadge: false,
    );
    final androidPlugin =
    notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(uploadChannel);
    // ------------------------------------------------------------
    // LOCAL HELPER: SHOW NOTIFICATION
    // ------------------------------------------------------------
    Future<void> showUploadNotification({
      required String title,
      required String body,
      int? progress,
      bool showProgress = false,
    }) async {
      await notifications.show(
        123,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'video_upload_channel',
            'Video Upload',
            channelDescription: 'Shows video upload progress',
            importance: Importance.low,
            priority: Priority.low,
            icon: 'app_ic',
            showProgress: showProgress,
            progress: progress ?? 0,
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

    // ------------------------------------------------------------
    // LOCAL HELPER: MIME TYPE
    // ------------------------------------------------------------
    String getContentType(String fileName) {
      final extension = fileName.contains('.')
          ? fileName.split('.').last.toLowerCase()
          : '';

      const mimeTypes = <String, String>{
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'png': 'image/png',
        'webp': 'image/webp',
        'mp4': 'video/mp4',
        'mov': 'video/quicktime',
        'm4v': 'video/x-m4v',
        '3gp': 'video/3gpp',
        'avi': 'video/x-msvideo',
        'mkv': 'video/x-matroska',
        'mp3': 'audio/mpeg',
        'm4a': 'audio/mp4',
        'aac': 'audio/aac',
        'wav': 'audio/wav',
        'pdf': 'application/pdf',
      };

      return mimeTypes[extension] ?? 'application/octet-stream';
    }
    // ------------------------------------------------------------
    // LOCAL HELPER: PARSE JSON MAP
    // ------------------------------------------------------------
    /*Map<String, dynamic> parseResponse(Response response) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final status = data['status'];

        if (status == true || status == 1 || status == '1') {
          return data;
        }
      }

      throw Exception(
        'Invalid API response: ${response.data}',
      );
    }*/
    Map<String, dynamic> parseResponse(Response response) {
      dynamic data = response.data;

      // Handle JSON returned as a String.
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {
          throw Exception('Invalid JSON response: ${response.data}');
        }
      }

      if (data is Map) {
        final Map<String, dynamic> body =
        Map<String, dynamic>.from(data);

        final status = body['status'];

        if (status == true ||
            status == 1 ||
            status == '1') {
          return body;
        }
      }

      throw Exception(
        'Invalid API response: ${response.data}',
      );
    }

    Map<String, dynamic> parisignedResponse(dynamic response) {

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      throw Exception('Invalid aws API response: $response');

    }

    // ------------------------------------------------------------
    // READ INPUT DATA
    // ------------------------------------------------------------
    try {
      final artifactsJson = inputData?['artifacts']?.toString() ?? '';

      if (artifactsJson.isEmpty || artifactsJson == 'null') {
        print('ERROR: Artifacts data is missing');
        await showUploadNotification(
          title: 'Upload failed',
          body: 'Artifacts data is missing',
        );
        return false;
      }

      final dynamic decodedData = jsonDecode(artifactsJson);

      if (decodedData is! List) {
        print('ERROR: Artifacts is not a list');
        return false;
      }

      final List<dynamic> artifacts = decodedData;

      final String beatId =
          inputData?['beat_id']?.toString() ?? '';
      final String storeId =
          inputData?['store_id']?.toString() ?? '';
      final String userId =
          inputData?['user_id']?.toString() ?? '';
      final String token =
          inputData?['token']?.toString() ?? '';
      final String deviceId =
          inputData?['device_id']?.toString() ?? '';

      final int totalFiles = artifacts.length;

      print('======================================');
      print('BACKGROUND ARTIFACT UPLOAD');
      print('Task: $task');
      print('Total files: $totalFiles');
      print('Beat ID: $beatId');
      print('Store ID: $storeId');
      print('User ID: $userId');
      print('Device ID: $deviceId');
      print('======================================');

      if (totalFiles == 0) {
        await showUploadNotification(
          title: 'Upload queue empty',
          body: 'No files to upload',
        );
        return true;
      }

      if (token.isEmpty || userId.isEmpty || storeId.isEmpty) {
        throw Exception(
          'Missing required user, store, or authorization data.',
        );
      }

      await showUploadNotification(
        title: 'Upload queue',
        body: '$totalFiles file(s) waiting to upload',
        progress: 0,
        showProgress: true,
      );

      // ----------------------------------------------------------
      // DIO CONFIGURATION
      // ----------------------------------------------------------
      final Dio dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(hours: 6),
          headers: {
            'Accept': 'application/json',
            'Authorization': token,
          },
        ),
      );

      final String presignedApiUrl = '${AppConstant.appBaseURL}s3/get/presigned/upload/url';

      final String saveApiUrl = '${AppConstant.appBaseURL}save-multiple-overall-video';

      // ----------------------------------------------------------
      // UPLOAD ARTIFACTS ONE BY ONE
      // ----------------------------------------------------------
      for (int i = 0; i < totalFiles; i++) {
        final dynamic item = artifacts[i];

        if (item is! Map) {
          throw Exception('Artifact ${i + 1} is invalid.');
        }

        final Map<String, dynamic> artifact = Map<String, dynamic>.from(item);

        final String filePath = artifact['file_path']?.toString() ?? '';
        final String fileName = artifact['file_name']?.toString() ?? (filePath.isNotEmpty ? filePath.split(Platform.pathSeparator).last : '');
        // Preserve the original application file_type for the save API.
        final String fileType = artifact['file_type']?.toString() ?? '';
        // Override with artifact['folder'] if your queue supplies it.
         String folder ="";
         if(fileType=='1'){
           folder='audio';
         }else if(fileType=='2'){
           folder='video';
         }else if(fileType=='3'){
           folder='img';
         }else{
           folder='store_img';
         }

        if (filePath.isEmpty || fileName.isEmpty) {
          throw Exception(
            'File path or filename is missing for artifact ${i + 1}.',
          );
        }

        final File file = File(filePath);

        if (!await file.exists()) {
          throw Exception('File not found: $filePath');
        }

        final int fileSize = await file.length();

        if (fileSize <= 0) {
          throw Exception('File is empty: $fileName');
        }

        final String contentType = getContentType(fileName);

        // Preserve the source file's modification time.
        final String localCreatedDate =
        (await file.lastModified()).toString();

        print('--------------------------------------');
        print('FILE ${i + 1}/$totalFiles');
        print('Name: $fileName');
        print('Type: $fileType');
        print('MIME: $contentType');
        print('Size: $fileSize bytes');
        print('Path: $filePath');
        print('--------------------------------------');

        // ========================================================
        // STEP 1: REQUEST PRESIGNED URL
        // ========================================================
        final presignResponse = await dio.post(
          presignedApiUrl,
          data: {
            'file_name': fileName,
            'file_type': contentType,
            'folder': folder,
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

        final Map<String, dynamic> presignBody = parisignedResponse(presignResponse.data);

        final dynamic presignData = presignBody['data'];

        if (presignBody['status'] != true ||
            presignData is! Map) {
          throw Exception(
            'Failed to get presigned URL: ${presignResponse.data}',
          );
        }

        final Map<String, dynamic> urlData =
        Map<String, dynamic>.from(presignData);

        final String uploadUrl =
            urlData['upload_url']?.toString() ?? '';

        final String finalFileUrl =
            urlData['file_url']?.toString() ?? '';

        if (uploadUrl.isEmpty || finalFileUrl.isEmpty) {
          throw Exception(
            'Presigned API did not return upload_url and file_url.',
          );
        }

        print('Presigned URL received for $fileName');
        print('Presigned URL  $uploadUrl');
        

        // ========================================================
        // STEP 2: UPLOAD DIRECTLY TO AWS S3
        // ========================================================
        //
        // Do not send your application Authorization token to S3.
        // The presigned URL authorizes the S3 request.
        //
        // Stream the file instead of loading it into memory.
        // Content-Length is the actual file size.
        // ========================================================
        final Dio s3Dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(minutes: 2),
            sendTimeout: const Duration(hours: 6),
            receiveTimeout: const Duration(minutes: 2),
          ),
        );

        await s3Dio.put<void>(
          uploadUrl,
          data: file.openRead(),
          options: Options(
            headers: {
              'Content-Type': contentType,
              'Content-Length': fileSize,
            },
            responseType: ResponseType.plain,
            validateStatus: (status) =>
            status != null && status >= 200 && status < 300,

            // IMPORTANT: Do not send the API Authorization token to S3.
            // Also disable inherited Dio default headers for this request.
            followRedirects: false,
          ),
          onSendProgress: (sent, total) async {
            final int denominator = total > 0 ? total : fileSize;
            if (denominator <= 0) return;

            final double fileProgress =
            (sent / denominator).clamp(0.0, 1.0);

            final int filePercentage = (fileProgress * 100).round();

            final int overallPercentage =
            (((i + fileProgress) / totalFiles) * 100)
                .round()
                .clamp(0, 100);

            final int uploadedCount = fileProgress >= 1 ? i + 1 : i;

            await showUploadNotification(
              title: 'Uploading $fileName',
              body: 'File $filePercentage% • '
                  'Uploaded: $uploadedCount/$totalFiles • '
                  'Remaining: ${totalFiles - uploadedCount}',
              progress: overallPercentage,
              showProgress: true,
            );
          },
        );


        print('S3 upload completed: $fileName');

        // ========================================================
        // STEP 3: SAVE THE S3 URL ON YOUR SERVER
        // ========================================================
        //
        // This API is called only after S3 PUT succeeds.
        // Keep metadata as multipart/form-data, as in your old flow.
        // ========================================================

        final FormData saveFormData = FormData.fromMap({
          'user_id': userId,
          'store_id': storeId,
          'file_url': finalFileUrl,
          'file_type': fileType,
          'Authorization': token,
          'beatplan_id': beatId,
          'device_id': deviceId,
          'fileCount': '1',
          'local_path': filePath,
          'local_created_date': localCreatedDate,
        });

        print('Save  Data ${saveFormData.toString()}');
        print('Save url : $saveApiUrl');

        final saveResponse = await dio.post(
          saveApiUrl,
          data: saveFormData,
          options: Options(
            headers: {
              'Authorization': token,
              'Accept': 'application/json',
            },
            sendTimeout: const Duration(minutes: 2),
            receiveTimeout: const Duration(minutes: 10),
          ),
        );

        print('Save Response Data $saveResponse');
        print('Save Response Type: ${saveResponse.data.runtimeType}');
        final Map<String, dynamic> saveBody = parseResponse(saveResponse);
        print('Save successful: ${saveBody['message']}');

        final dynamic saveStatus = saveBody['status'];

        // Supports common true/1/"1" response conventions.
        // Adjust this check if your API documents another success value.
        final bool saveSucceeded =
            saveStatus == true ||
                saveStatus == 1 ||
                saveStatus?.toString() == '1' ||
                saveStatus?.toString().toLowerCase() == 'true';

        if (!saveSucceeded) {
          throw Exception(
            'Server failed to save $fileName: ${saveResponse.data}',
          );
        }

        // ========================================================
        // FILE SUCCESS: UPDATE NOTIFICATION
        // ========================================================
        final int uploadedCount = i + 1;
        final int remainingCount = totalFiles - uploadedCount;

        final int overallPercentage =
        ((uploadedCount / totalFiles) * 100).round();

        await showUploadNotification(
          title: 'Uploading files',
          body: '$fileName uploaded\n'
              'Uploaded: $uploadedCount/$totalFiles\n'
              'Remaining: $remainingCount',
          progress: overallPercentage,
          showProgress: true,
        );

        print('SUCCESS: $fileName');
        print('Saved S3 URL: $finalFileUrl');
        print('Save API response: ${saveResponse.data}');
      }

      // ----------------------------------------------------------
      // ALL FILES COMPLETED
      // ----------------------------------------------------------
      await showUploadNotification(
        title: 'Upload completed',
        body: '$totalFiles/$totalFiles files uploaded successfully',
        progress: 100,
        showProgress: false,
      );

      print('======================================');
      print('ALL FILES UPLOADED SUCCESSFULLY');
      print('Total files: $totalFiles');
      print('======================================');

      return true;
    } on DioException catch (e, stackTrace) {
      print('======================================');
      print('BACKGROUND DIO ERROR');
      print('Status: ${e.response?.statusCode}');
      print('Response: ${e.response?.data}');
      print('Message: ${e.message}');
      print(stackTrace);
      print('======================================');

      await showUploadNotification(
        title: 'Upload failed',
        body: e.response?.data?.toString() ??
            e.message ??
            'Network error while uploading',
        showProgress: false,
      );

      return true;
    } catch (e, stackTrace) {
      print('======================================');
      print('BACKGROUND UPLOAD ERROR');
      print(e);
      print(stackTrace);
      print('======================================');

      await showUploadNotification(
        title: 'Upload failed',
        body: e.toString(),
        showProgress: false,
      );

      return true;
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
        navigatorKey: appNavigatorKey,
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
