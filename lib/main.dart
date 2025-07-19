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
import 'package:workmanager/workmanager.dart';

import 'network/constants.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Work Manageer executed");
    var notifications = FlutterLocalNotificationsPlugin();
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_ic');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {},
    );
    /* FormData formData = FormData.fromMap({
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
*/

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
              iOS: const IOSNotificationDetails(),
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

/*
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
    });*/
    // log(response.data);

    print("Service completed");

    return Future.value(true);
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

  runApp(MyApp(token));
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
