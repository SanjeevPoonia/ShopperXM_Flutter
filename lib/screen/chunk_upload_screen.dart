import 'dart:io';

import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PlatformFile>? _paths;
  String? _extension;
  double progress = 0.0;
  String link = '';
  bool isLoading = false;
  File? selectedFile;

  @override
  void initState() {
    super.initState();
  }

  void _pickFiles() async {
    setState(() {
      link = '';
      isLoading = true;
    });
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Unsupported operation$e');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;

      setState(() {});
    }
  }

  upload() async {
    if (_paths == null) {
      showToast('Select a file first.');
    }
    var path = _paths![0].path!;
    String fileName = path.split('/').last;
    String url = 'https://awaitanthony.com/demo/api/v1/file_upload';
    ChunkedUploader chunkedUploader = ChunkedUploader(
      Dio(
        BaseOptions(
          baseUrl: url,
          headers: {
            'Content-Type': 'multipart/form-data',
            'Connection': 'Keep-Alive',
          },
        ),
      ),
    );
    try {
      Response? response = await chunkedUploader.uploadUsingFilePath(
        fileKey: "file",
        method: "POST",
        filePath: path,
        maxChunkSize: 500000000,
        fileName: fileName,
        path: url,
        data: {
          'additional_data': 'hiii',
        },
        onUploadProgress: (v) {
          if (kDebugMode) {
            print(v);
          }

          progress = v;
          setState(() {});
        },
      );
      if (kDebugMode) {
        print(response);
      }

      var data = response?.data;
      if (data != null) {
        if (data['status'] == true) {
          link = data['link'];
        }
        showToast(data['message']);
      } else {
        showToast('Unknown error.');
      }
      setState(() {
        _paths = null;
        progress = 0.0;
      });
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _pickFiles();
              },
              child: const Text('Select File'),
            ),
            const SizedBox(height: 20),
            if ((_paths?.length ?? 0) > 0)
              ElevatedButton(
                onPressed: () {
                  uploadInBackground();
                },
                child: const Text('Upload'),
              ),
            if (progress > 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearPercentIndicator(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  animation: false,
                  lineHeight: 20.0,
                  percent: double.parse(progress.toStringAsExponential(1)),
                  progressColor: Colors.green,
                  center: Text(
                    "${(progress * 100).round()}%",
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (link != '')
              Text(
                link,
                style: const TextStyle(),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      floatingActionButton: link != ''
          ? FloatingActionButton(
        onPressed: () {
          _launchUrl(link);
        },
        child: const Icon(Icons.remove_red_eye_rounded),
      )
          : null,
    );
  }

  showToast(message) {
    Toast.show(message,
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blueAccent);
  }


  uploadInBackground() async {

    String filePath= _paths![0].path.toString();
    print("Uploading started");

    await Workmanager().registerOneOffTask(
      "1",
      "uploadFileTask",
      inputData: <String, dynamic>{
        'filesPath': filePath,
      },
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      existingWorkPolicy: ExistingWorkPolicy.keep,

    );

  }


  _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication))
      throw 'Could not launch $url';
  }
}


