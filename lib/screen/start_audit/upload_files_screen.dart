import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/utils/app_modal.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:video_player/video_player.dart';
import 'package:workmanager/workmanager.dart';

import '../../network/api_dialog.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import '../../widgets/appbar_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class UploadFilesScreen extends StatefulWidget {
  final int isVideoRequired;
  final int isImageRequired;
  final int isAudioRequired;
  final String storeID;
  final String beatPlanID;

  UploadFilesScreen(this.isVideoRequired, this.isImageRequired,
      this.isAudioRequired, this.storeID, this.beatPlanID);

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<UploadFilesScreen> {
  bool fileUploading = false;
  List<String> mediaFileURI = [];
  bool pageNavigator = false;
  bool check = false;
  VideoPlayerOptions videoPlayerOptions =
      VideoPlayerOptions(mixWithOthers: true);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          AppBarWidget("Upload artifacts"),
          Expanded(
              child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 13),
            children: [
              SizedBox(height: 5),
              SizedBox(height: 10),
              widget.isVideoRequired == 1
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Text("Upload Video",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              )),
                          Spacer(),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                            child: Container(
                              height: 29,
                              //  width: 95,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white), // background
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFFFF8500)), // fore
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ))),
                                onPressed: () {
                                  _fetchVideo(context);
                                },
                                child: const Text(
                                  'Browse',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: 3),
              widget.isVideoRequired == 1
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Divider(),
                    )
                  : Container(),
              SizedBox(height: 5),
              widget.isAudioRequired == 1
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Text("Upload Audio",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              )),
                          Spacer(),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                            child: Container(
                              height: 29,
                              //  width: 95,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white), // background
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFFFF8500)), // fore
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ))),
                                onPressed: () {
                                  pickAudioFiles();
                                },
                                child: const Text(
                                  'Browse',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: 3),
              widget.isAudioRequired == 1
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Divider(),
                    )
                  : Container(),
              SizedBox(height: 5),
              widget.isImageRequired == 1
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Text("Upload Image",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              )),
                          Spacer(),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                            child: Container(
                              height: 29,
                              //  width: 95,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white), // background
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFFFF8500)), // fore
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ))),
                                onPressed: () {
                                  _fetchImage(context);
                                },
                                child: const Text(
                                  'Browse',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: 3),
              widget.isImageRequired == 1
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Divider(),
                    )
                  : Container(),
              SizedBox(height: 15),
              fileUploading
                  ? Container(
                      margin: EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 10),
                      child: Row(
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          SizedBox(width: 10),
                          Text("Uploading files...",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    )
                  : Container(),
              mediaFileURI.length == 0
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: mediaFileURI.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return Column(
                          children: [
                            Container(
                              height: 74,
                              decoration: BoxDecoration(
                                  color: AppTheme.themeColor.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      if (lookupMimeType(mediaFileURI[pos])
                                          .toString()
                                          .startsWith('video/')) {
                                        previewVideoDialog(context, pos);
                                      } else if (lookupMimeType(
                                              mediaFileURI[pos])
                                          .toString()
                                          .startsWith('image/')) {
                                        previewImageDialog(context, pos);
                                      } else {
                                        //Audio
                                        previewAudioDialog(context, pos);
                                      }
                                    },
                                    child: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.themeColor),
                                      child: Center(
                                          child: lookupMimeType(
                                                      mediaFileURI[pos])
                                                  .toString()
                                                  .startsWith('video/')
                                              ? Icon(Icons.play_arrow_rounded,
                                                  color: Colors.white)
                                              : lookupMimeType(
                                                          mediaFileURI[pos])
                                                      .toString()
                                                      .startsWith('image/')
                                                  ? Icon(Icons.image,
                                                      color: Colors.white)
                                                  : Icon(
                                                      Icons.music_note_outlined,
                                                      color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                          mediaFileURI[pos].split('/').last,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          maxLines: 2)),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      mediaFileURI.removeAt(pos);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFfEE4C45)),
                                      child: Center(
                                          child: Icon(Icons.delete_rounded,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 15)
                          ],
                        );
                      }),
              mediaFileURI.length == 0
                  ? Container()
                  : Card(
                      elevation: 4,
                      shadowColor: Colors.grey,
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        height: 47,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white), // background
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppTheme.themeColor), // fore
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                          onPressed: ()async {
                            if (mediaFileURI.isEmpty) {
                              return;
                            }
                            await uploadAllArtifactsInBackground();
                            /*if (mediaFileURI.length != 0) {
                              fileUploading = true;
                              setState(() {});
                              for (int i = 0; i < mediaFileURI.length; i++) {
                                if (lookupMimeType(mediaFileURI[i])
                                    .toString()
                                    .startsWith('video/')) {
                                  fileUploading = false;
                                  setState(() {});
                                  uploadInBackground(i);
                                  // uploadMedia("2", i);
                                } else if (lookupMimeType(mediaFileURI[i])
                                    .toString()
                                    .startsWith('image/')) {
                                  uploadMedia("3", i);
                                } else {
                                  uploadMedia("1", i);
                                }
                              }
                            }*/
                          },
                          child: const Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
              mediaFileURI.length == 0 ? Container() : SizedBox(height: 15),
              Card(
                elevation: 4,
                shadowColor: Colors.grey,
                margin: EdgeInsets.symmetric(horizontal: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 47,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // background
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppTheme.themeColor), // fore
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ))),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => LandingScreen()));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(height: 16),
            ],
          )),
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> uploadAllArtifactsInBackground() async {
    // ---------------------------------------------------------
    // 1. Check notification permission
    // ---------------------------------------------------------

    final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('app_ic');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notifications.initialize(initializationSettings);

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? permissionGranted =
    await androidPlugin?.areNotificationsEnabled();

    print("Notification permission status: $permissionGranted");

    if (permissionGranted != true) {
      final bool? requestResult =
      await androidPlugin?.requestNotificationsPermission();

      print("Notification permission request result: $requestResult");

      if (requestResult != true) {
        Toast.show(
          "Notification permission is required for background upload.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red,
        );

        return;
      }
    }

    // ---------------------------------------------------------
    // 2. Create artifact list
    // ---------------------------------------------------------

    final List<Map<String, dynamic>> artifacts = [];

    for (final String filePath in mediaFileURI) {
      final File file = File(filePath);

      if (!await file.exists()) {
        print("======================================");
        print("ERROR: FILE DOES NOT EXIST");
        print("Path: $filePath");
        print("======================================");

        Toast.show(
          "File is no longer available:\n${filePath.split('/').last}",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red,
        );

        continue;
      }

      final String mimeType =
          lookupMimeType(filePath) ?? "";

      String? fileType;

      if (mimeType.startsWith('video/')) {
        fileType = "2";
      } else if (mimeType.startsWith('image/')) {
        fileType = "3";
      } else if (mimeType.startsWith('audio/')) {
        fileType = "1";
      }

      if (fileType == null) {
        print("Unsupported artifact:");
        print(filePath);
        continue;
      }

      final String fileName =
          filePath.split(Platform.pathSeparator).last;

      artifacts.add({
        "file_path": filePath,
        "file_name": fileName,
        "file_type": fileType,
      });
    }
    if (artifacts.isEmpty) {
      Toast.show(
        "No valid artifacts found.",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: Colors.red,
      );
      return;
    }

    print("======================================");
    print("Total artifacts: ${artifacts.length}");
    print("Artifacts:");
    print(artifacts);
    print("======================================");

    // ---------------------------------------------------------
    // 3. Show background upload message
    // ---------------------------------------------------------

    Toast.show(
      "${artifacts.length} artifact(s) uploading in background...",
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
      backgroundColor: Colors.blue,
    );

    // ---------------------------------------------------------
    // 4. Register ONE WorkManager task
    // ---------------------------------------------------------

    final String uniqueId =
        "artifact_upload_${DateTime.now().millisecondsSinceEpoch}";
    await Workmanager().registerOneOffTask(
      uniqueId,
      "uploadArtifactsTask",
      inputData: {
        "artifacts": jsonEncode(artifacts),
        "beat_id": widget.beatPlanID,
        "store_id": widget.storeID,
        "user_id": AppModel.userID,
        "token": AppModel.token,
      },
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      existingWorkPolicy: ExistingWorkPolicy.append,
    );

    print("Background artifact upload task registered.");

    // ---------------------------------------------------------
    // 5. Close UploadFilesScreen
    // ---------------------------------------------------------

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => LandingScreen(),
      ),
    );
  }


  Future<void> uploadInBackground(int index) async {
    // ---------------------------------------------------------
    // 1. Check / Request Notification Permission
    // ---------------------------------------------------------
    final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('app_ic');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notifications.initialize(initializationSettings);

    // Android 13+ notification permission
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? permissionGranted =
    await androidPlugin?.areNotificationsEnabled();

    print("Notification permission status: $permissionGranted");

    if (permissionGranted != true) {
      print("Notification permission not granted. Requesting...");

      final bool? requestResult =
      await androidPlugin?.requestNotificationsPermission();

      print("Notification permission request result: $requestResult");

      if (requestResult != true) {
        Toast.show(
          "Notification permission is required to show upload progress.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red,
        );

        return;
      }
    }

    // ---------------------------------------------------------
    // 2. Start upload process
    // ---------------------------------------------------------

    APIDialog.showAlertDialog(context, "Uploading video...");

    String filePath = mediaFileURI[index].toString();

    print("Uploading started");
    print("File: $filePath");

    Navigator.pop(context);

    Toast.show(
      "Video is uploading in background...",
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
      backgroundColor: Colors.blue,
    );

    // ---------------------------------------------------------
    // 3. Register WorkManager task
    // ---------------------------------------------------------

    await Workmanager().registerOneOffTask(
      "id1${DateTime.now().millisecondsSinceEpoch}",
      "uploadFileTask12${DateTime.now().millisecondsSinceEpoch}",
      inputData: <String, dynamic>{
        'filesPath': filePath,
        'beat_id': widget.beatPlanID,
        'store_id': widget.storeID,
        'user_id': AppModel.userID,
        'token': AppModel.token,
        'file_type': "2",
      },
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      existingWorkPolicy: ExistingWorkPolicy.append,
    );
  }
  /*uploadInBackground(int index) async {
    APIDialog.showAlertDialog(context, "Uploading video...");

    String filePath = mediaFileURI[index].toString();
    print("Uploading started");

    Navigator.pop(context);

    Toast.show("Video is uploading in background...",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);

    await Workmanager().registerOneOffTask(
      "id1" + DateTime.now().toString(),
      "uploadFileTask12" + DateTime.now().toString(),
      inputData: <String, dynamic>{
        'filesPath': filePath,
        'beat_id': widget.beatPlanID,
        'store_id': widget.storeID,
        'user_id':AppModel.userID,
        'token':AppModel.token,
        'file_type':"2"
      },
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      existingWorkPolicy: ExistingWorkPolicy.append,
    );
  }*/
  /*_fetchImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      mediaFileURI.add(image.path.toString());
      setState(() {});
    }
  }*/
  Future<void> _fetchImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
    await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) {
      return;
    }
    print("Selected image:");
    print(image.path);
    final String fileName =
        image.name;
    final String? permanentPath =
    await copyFileToUploadDirectory(
      image.path,
      fileName,
    );
    if (permanentPath == null) {
      Toast.show(
        "Unable to prepare image for upload",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red,
      );
      return;
    }
    mediaFileURI.add(permanentPath);
    setState(() {});
    print("Image added to queue:");
    print(permanentPath);
  }
  /*_fetchVideo(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    print('Video File From Android' + (video?.path).toString());
    if (video != null) {
      mediaFileURI.add(video.path.toString());
      setState(() {});
    }
  }*/
  Future<void> _fetchVideo(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? video =
    await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (video == null) {
      return;
    }

    print("Selected video:");
    print(video.path);

    final String fileName =
        video.name;

    final String? permanentPath =
    await copyFileToUploadDirectory(
      video.path,
      fileName,
    );

    if (permanentPath == null) {
      Toast.show(
        "Unable to prepare video for upload",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red,
      );
      return;
    }

    mediaFileURI.add(permanentPath);

    setState(() {});

    print("Video added to queue:");
    print(permanentPath);
  }
  /*pickAudioFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'aac', 'wav', 'wma'],
    );
    if (result != null) {
      mediaFileURI.add(result.files.single.path.toString());
      setState(() {});
    }
  }*/
  Future<void> pickAudioFiles() async {
    final FilePickerResult? result =
    await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'aac',
        'wav',
        'wma',
      ],
    );

    if (result == null ||
        result.files.single.path == null) {
      return;
    }

    final String sourcePath =
    result.files.single.path!;

    final String fileName =
        result.files.single.name;

    print("Selected audio:");
    print(sourcePath);

    final String? permanentPath =
    await copyFileToUploadDirectory(
      sourcePath,
      fileName,
    );

    if (permanentPath == null) {
      Toast.show(
        "Unable to prepare audio for upload",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red,
      );
      return;
    }

    mediaFileURI.add(permanentPath);

    setState(() {});

    print("Audio added to queue:");
    print(permanentPath);
  }
  uploadMedia(String type, int index) async {
    FormData formData = FormData.fromMap({
      "user_id": AppModel.userID,
      "Orignal_Name": mediaFileURI[index].split('/').last,
      "fileCount": "1",
      "file": await MultipartFile.fromFile(mediaFileURI[index]),
      "Authorization": AppModel.token,
      "store_id": widget.storeID,
      "beatplan_id": widget.beatPlanID,
      "file_type": type,
    });
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "saveMultipleOverallVideo");
    var response = await dio.post(
        AppConstant.appBaseURL + "saveMultipleOverallVideo",
        data: formData);
    log(response.data);
    var responseJSON = jsonDecode(response.data.toString());
    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      if (index == mediaFileURI.length - 1) {
        fileUploading = false;
        setState(() {});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LandingScreen()));
      }
    } else {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  prepareVideo(int index) async {
    APIDialog.showAlertDialog(context, "Please wait...");

    previewVideoDialog(context, index);
  }
  Future<void> previewVideoDialog(BuildContext context, int index) async {
    VideoPlayerController? _controller;
    final chewieController;
    VideoPlayerOptions videoPlayerOptions =
        VideoPlayerOptions(mixWithOthers: true);
    _controller = VideoPlayerController.file(File(mediaFileURI[index]));
    await _controller.initialize();

    chewieController = await ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      looping: false,
    );
    setState(() {});

    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.black),
                            child: Center(
                              child: Icon(Icons.close_sharp,
                                  color: Colors.white, size: 13.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                        child: Container(
                      height: 245,
                      child: Chewie(
                        controller: chewieController,
                      ),
                    )),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
  void previewImageDialog(BuildContext context, int index) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 300,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        child: Center(
                          child: Icon(Icons.close_sharp,
                              color: Colors.white, size: 13.5),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                    height: 245, child: Image.file(File(mediaFileURI[index]))),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
  Future<void> previewAudioDialog(BuildContext context, int index) async {
    final player = AudioPlayer();
    await player.play(UrlSource(mediaFileURI[index]));

    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 105,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        player.pause();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        child: Center(
                          child: Icon(Icons.close_sharp,
                              color: Colors.white, size: 13.5),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  color: Colors.black,
                  height: 50,
                )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Future<String?> copyFileToUploadDirectory(
      String sourcePath,
      String originalFileName,
      ) async {
    try {
      final Directory appDirectory =
      await getApplicationDocumentsDirectory();

      final Directory uploadDirectory =
      Directory('${appDirectory.path}/upload_queue');

      if (!await uploadDirectory.exists()) {
        await uploadDirectory.create(recursive: true);
      }

      final String safeFileName =
      originalFileName.replaceAll(
        RegExp(r'[^a-zA-Z0-9._-]'),
        '_',
      );

      final String destinationPath =
          '${uploadDirectory.path}/'
          '${DateTime.now().millisecondsSinceEpoch}_'
          '$safeFileName';

      final File sourceFile = File(sourcePath);

      if (!await sourceFile.exists()) {
        print("SOURCE FILE DOES NOT EXIST:");
        print(sourcePath);
        return null;
      }

      final File copiedFile =
      await sourceFile.copy(destinationPath);

      print("======================================");
      print("FILE COPIED");
      print("Original : $originalFileName");
      print("Source   : $sourcePath");
      print("Target   : ${copiedFile.path}");
      print("======================================");

      return copiedFile.path;
    } catch (e, stackTrace) {
      print("ERROR COPYING FILE");
      print(e);
      print(stackTrace);

      return null;
    }
  }
}
