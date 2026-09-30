import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import 'package:mime/mime.dart';

class ShopperBrowseBarcodeArtifactScreen extends StatefulWidget {
  final String tagId;
  final String storeId;

  const ShopperBrowseBarcodeArtifactScreen({
    required this.tagId,
    required this.storeId,
  });

  @override
  State<ShopperBrowseBarcodeArtifactScreen> createState() =>
      _ShopperBrowseBarcodeArtifactScreenState();
}

class _ShopperBrowseBarcodeArtifactScreenState
    extends State<ShopperBrowseBarcodeArtifactScreen> {

  /// ================= VARIABLES =================
  List<String> imageList = [];
  Function(void Function())? dialogSetState;
  double progress = 0;
  int uploadedCount = 0;
  int totalCount = 0;
  List<String> uploadedUrls = [];
  bool isUploading = false;
  final ImagePicker picker = ImagePicker();

  String authKey = "", userId = "", emailStr = "";

  /// ================= PICK IMAGES =================
  Future<void> pickImages() async {
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      setState(() {
        imageList.addAll(images.map((e) => e.path));
      });
    }
  }

  /// ================= REMOVE IMAGE =================
  void removeImage(int index) {
    setState(() {
      imageList.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }
  void getUserDetails() async {
    authKey = await MyUtils.getSharedPreferences("access_token") ?? "";
    userId = await MyUtils.getSharedPreferences("user_id") ?? "";
    emailStr = await MyUtils.getSharedPreferences("email") ?? "";
    setState(() {});
  }

  /// ================= UPLOAD DIALOG =================
  void showUploadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {

            dialogSetState = setStateDialog; // ✅ store reference

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Uploading Artifacts"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Uploading $uploadedCount / $totalCount"),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 10),
                  Text("${(progress * 100).toStringAsFixed(0)}%"),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ✅ ONLY CHANGED PARTS (बाकी आपका same रहेगा)

  /// ================= MAIN UPLOAD =================
  Future<void> startUpload() async {

    if (imageList.isEmpty) {
      showMsg("Please select images");
      return;
    }

    if (isUploading) return;

    isUploading = true;

    totalCount = imageList.length;
    uploadedCount = 0;
    progress = 0;
    uploadedUrls.clear();

    showUploadDialog();

    try {

      for (int i = 0; i < imageList.length; i++) {

        String path = imageList[i];

        try {
          final presigned = await getPresignedUrl(path);
          await uploadFileToS3(
            filePath: path,
            uploadUrl: presigned['upload_url'],
          );
          uploadedUrls.add(presigned['file_url']);
          uploadedCount++;

        } catch (e) {
          print("Upload failed: $e");
        }
        progress = uploadedCount / totalCount;

        if (mounted) setState(() {});
        dialogSetState?.call(() {});
      }
      if (uploadedUrls.length == totalCount) {
        await saveArtifactsToServer();
        showMsg("Upload successful");
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context, true);
          }
        });
      } else {
        showMsg("Some files failed to upload");
      }

    } catch (e) {
      showMsg("Upload process failed");
    } finally {
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      isUploading = false;
    }
  }

  /// ================= GET PRESIGNED =================
  Future<Map<String, dynamic>> getPresignedUrl(String filePath) async {

    String fileName = filePath.split("/").last;
    String? mimeType = lookupMimeType(filePath);
    print(mimeType);
    var body = {
      "file_name": fileName,
      "file_type": mimeType,
      "folder":"amazon_barcode",
    };

    var response = await ApiBaseHelper().postAPIWithHeader(
      "s3/get/presigned/upload/url",
      body,
      context,
    );

    var json = jsonDecode(response.body);

    if (!(json["status"] == 1 || json["status"] == true)) {
      showMsg(json['message']?.toString()??"Something Went wrong! Please try again.");
      throw Exception("Presigned URL failed");

    }

    return {
      "upload_url": json["data"]["upload_url"],
      "file_url": json["data"]["file_url"],
    };
  }

  /// ================= UPLOAD FILE =================

  /// ================= UPLOAD FILE =================
  Future<void> uploadFileToS3({
    required String filePath,
    required String uploadUrl,
  }) async {

    File file = File(filePath);
    Dio dio = Dio();

    final response = await dio.put(
      uploadUrl,
      data: await file.readAsBytes(),
      options: Options(
        headers: {
          "Content-Type": "binary/octet-stream",
        },
        contentType: "binary/octet-stream",
        validateStatus: (status) => true,
      ),
      onSendProgress: (sent, total) {
        double fileProgress = sent / total;
        progress = (uploadedCount + fileProgress) / totalCount;
        if (mounted) setState(() {});
        dialogSetState?.call(() {});
      },
    );
    if (!(response.statusCode == 200 || response.statusCode == 204)) {
      throw Exception("Upload failed with status ${response.statusCode}");
    }
  }
  /// ================= FINAL API =================
  Future<void> saveArtifactsToServer() async {

    try {

      var body = {
        "barcode_store_id": widget.storeId,
        "user_id": userId,
        "tag_id": widget.tagId,
        "url": uploadedUrls
      };

      var response = await ApiBaseHelper().postAPIWithHeader(
        "barcode_artifacts",
        body,
        context,
      );

      var json = jsonDecode(response.body);

      showMsg(json["message"]);

    } catch (e) {
      showMsg("Final API failed: $e");
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Artifacts"),
        elevation: 0,
      ),

      body: Column(
        children: [

          /// HEADER
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Store ID: ${widget.storeId}"),
                Text("Tag ID: ${widget.tagId}"),
              ],
            ),
          ),

          /// BROWSE BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              onPressed: pickImages,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Browse Images"),
            ),
          ),

          const SizedBox(height: 10),

          /// IMAGE GRID (better UX)
          Expanded(
            child: imageList.isEmpty
                ? const Center(child: Text("No Images Selected"))
                : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imageList.length,
              itemBuilder: (_, i) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(imageList[i]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: InkWell(
                        onTap: () => removeImage(i),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),

      /// SUBMIT BUTTON (SAFE AREA FIXED)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: startUpload,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              backgroundColor: AppTheme.orangeColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Upload"),
          ),
        ),
      ),
    );
  }

  /// ================= HELPER =================
  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}