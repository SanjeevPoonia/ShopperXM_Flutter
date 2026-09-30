import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mime/mime.dart';
import 'package:toast/toast.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';
import 'barcode_scanner_screen.dart';
import 'package:dio/dio.dart';


class ShopperBarcodeTagScreen extends StatefulWidget {
  @override
  State<ShopperBarcodeTagScreen> createState() =>
      _ShopperBarcodeTagScreenState();
}

class _ShopperBarcodeTagScreenState extends State<ShopperBarcodeTagScreen> {
  GoogleMapController? mapController;

  double lat = 0;
  double lng = 0;

  Map<String, dynamic>? selectedStoreData;
  String storeImagePath = "";
  String selfieImagePath = "";

  String storeImageUrl = "";
  String selfieImageUrl = "";
  String authKey = "", userId = "", emailStr = "";
  List<dynamic> storeList = [];

  String tempStoreImagePath = "";
  String tempSelfieImagePath = "";

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStoreLocations();
    });
  }

  // ================= USER =================

  void getUserDetails() async {
    authKey = await MyUtils.getSharedPreferences("access_token") ?? "";
    userId = await MyUtils.getSharedPreferences("user_id") ?? "";
    emailStr = await MyUtils.getSharedPreferences("email") ?? "";
    setState(() {});
  }

  Future<void> getStoreLocations() async {
    APIDialog.showAlertDialog(context, "Loading...");

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithHeader("barcode_store_index", context);
    if (!mounted) return;

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    var jsonResponse = json.decode(response.body);
    bool success = jsonResponse['success'] ?? false;
    if (success) {
      storeList.clear();
      storeList = jsonResponse['data'] is List
          ? List<Map<String, dynamic>>.from(jsonResponse['data'])
          : [];

      if (!mounted) return;

      setState(() {});
    } else {
      Toast.show(jsonResponse["message"], backgroundColor: Colors.red);
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 14, // 👈 zoom level
          ),
        ),
      );
    }
  }

  Future<void> pickImage(String type) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;
    if (type == "selfie") {
      tempSelfieImagePath = image.path;
    } else {
      tempStoreImagePath = image.path;
    }

    showPreviewDialog(type, image.path);
  }

  void showPreviewDialog(String type, String path) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔹 HANDLE BAR
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// 🔹 TITLE
                Text(
                  type == "selfie" ? "Selfie Preview" : "Store Image Preview",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 IMAGE PREVIEW
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(path),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 ACTION BUTTONS
                Row(
                  children: [

                    /// CANCEL
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// UPLOAD
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.orangeColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);

                          if (type == "selfie") {
                            uploadSelfie(path);
                          } else {
                            uploadStore(path);
                          }
                        },
                        child: const Text("Upload"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Function(void Function())? dialogSetState;
  double progress = 0;
  /// ================= UPLOAD DIALOG =================
  void showUploadDialog(String title) {
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
              title:  Text("Uploading $title"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Uploading..."),
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

  /// ================= MAIN UPLOAD =================

  Future<void> uploadSelfie(String path) async {
    progress = 0;
    showUploadDialog("Selfie");
    try {

      /// 🔥 GET PRESIGNED URL
      final presigned = await getPresignedUrl(path);

      /// 🔥 UPLOAD FILE
      await uploadFileToS3(
        filePath: path,
        uploadUrl: presigned['upload_url'],
      );

      String fileUrl=presigned['file_url'];
      progress = 1 / 1;

      if (mounted) setState(() {});

      /// 🔥 ADD THIS
      if (dialogSetState != null) {
        dialogSetState!(() {});
      }
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop(); // ✅ सही जगह
      }
      setState(() {
        selfieImagePath = path;        // UI दिखेगा अब
        selfieImageUrl = fileUrl;      // server url
      });
      

    } catch (e) {
      print("Upload Selfie failed: $e");

      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      showMsg("Selfie Upload Failed. Please try again");
    }

  }

  Future<void> uploadStore(String path) async {
    progress = 0;
    showUploadDialog("Store Image");
    try {

      /// 🔥 GET PRESIGNED URL
      final presigned = await getPresignedUrl(path);

      /// 🔥 UPLOAD FILE
      await uploadFileToS3(
        filePath: path,
        uploadUrl: presigned['upload_url'],
      );

      String fileUrl=presigned['file_url'];
      progress = 1 / 1;

      if (mounted) setState(() {});

      /// 🔥 ADD THIS
      if (dialogSetState != null) {
        dialogSetState!(() {});
      }
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop(); // ✅ सही जगह
      }
      setState(() {
        storeImagePath = path;
        storeImageUrl = fileUrl;
      });


    } catch (e) {
      print("Upload Store Image failed: $e");

      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      showMsg("Store Image Upload Failed. Please try again");
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
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      showMsg(json['message']?.toString()??"Something Went wrong! Please try again.");
      throw Exception("Presigned URL failed");

    }

    return {
      "upload_url": json["data"]["upload_url"],
      "file_url": json["data"]["file_url"],
    };
  }

  /// ================= UPLOAD FILE =================
  Future<void> uploadFileToS3({
    required String filePath,
    required String uploadUrl,
  }) async {
    try {
      File file = File(filePath);
      Dio dio = Dio();

      print(uploadUrl);
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
          progress = fileProgress;

          if (mounted) setState(() {});
          if (dialogSetState != null) {
            dialogSetState!(() {});
          }
        },
      );

      /// 🔥 SUCCESS CHECK
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("UPLOAD SUCCESS");
        return;

      } else {
        throw Exception("Upload failed with status ${response.statusCode}");
      }

    } catch (e) {
      print("UPLOAD ERROR: $e");

      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      /// 🔥 delay to avoid crash
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          showMsg("Upload failed. Please try again");
        }
      });

    }
  }




  void validateAndNext() {
    if (selectedStoreData == null) {
      showMsg("Select Store");
      return;
    }

    if (storeImageUrl.isEmpty) {
      showMsg("Upload Store Image");
      return;
    }

    if (selfieImageUrl.isEmpty) {
      showMsg("Upload Selfie Image");
      return;
    }

    storeTaggingForAmazon();
  }
  Future<void> storeTaggingForAmazon() async {

    APIDialog.showAlertDialog(context, "Please wait...");

    try {

      var body = {
        "barcode_store_id": selectedStoreData!['id']?.toString()??"",
        "user_id": userId,
        "latitude": lat.toString(),
        "longitude": lng.toString(),
        "selfie_url": selfieImageUrl,
        "store_url": storeImageUrl,
      };

      ApiBaseHelper helper = ApiBaseHelper();

      var response = await helper.postAPIWithHeader(
        "barcode_tagging", // 👉 same endpoint
        body,
        context,
      );

      if (!mounted) return;

      if (Navigator.canPop(context)) {
        Navigator.pop(context); // dismiss dialog
      }

      var jsonResponse = json.decode(response.body);

      bool success = jsonResponse["status"] == true ||
          jsonResponse["status"] == 1 ||
          jsonResponse["status"] == "1";
      String message = jsonResponse["message"]?.toString() ?? "";

      showMsg(message);

      if (success) {
        String tagId = jsonResponse["tagging_id"]?.toString() ?? "";
        navigateToBarcodeScanner(tagId);


      }

    } catch (e) {

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      showMsg(e.toString());
    }
  }

  void navigateToBarcodeScanner(String tagId) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BarcodeScannerScreen(
          tagId: tagId,
          storeId: selectedStoreData!['id']?.toString() ?? "",
          storeName: selectedStoreData!['store_name']?.toString() ?? "",
          storeAddress: selectedStoreData!['address']?.toString() ?? "",
          storeCity: selectedStoreData!['city']?.toString() ?? "",
          storeCode: selectedStoreData!['store_code']?.toString() ?? "",
          storeState: selectedStoreData!['state']?.toString() ?? "",
        ),
      ),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        body: Column(
      children: [
        Card(
          elevation: 4,
          margin: EdgeInsets.only(top: 27),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Container(
            height: 69,
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.keyboard_backspace_rounded)),
                Expanded(
                    child: Center(
                  child: Text("Tag Store",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )),
                ))
              ],
            ),
          ),
        ),
        Expanded(
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: MarkerId("me"),
                position: LatLng(lat, lng),
              )
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, dynamic>>(
              isExpanded: true,
              value: selectedStoreData,
              hint: const Text(
                "Select Store",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),

              items: storeList.map((store) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: store,
                  child: Text(
                    store['store_name'] ?? "",
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedStoreData = value;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              /// ================= STORE IMAGE =================
              Expanded(
                child: _imageCard(
                  title: "Store Image",
                  imagePath: storeImagePath,
                  onTap: () => pickImage("store"),
                ),
              ),

              const SizedBox(width: 12),

              /// ================= SELFIE =================
              Expanded(
                child: _imageCard(
                  title: "Selfie",
                  imagePath: selfieImagePath,
                  onTap: () => pickImage("selfie"),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.themeColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
            ),
            onPressed: validateAndNext,
            child: Text("Next"),
          ),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    ));
  }

  Widget _imageCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        /// IMAGE BOX
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imagePath.isNotEmpty
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 32,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Tap to Capture",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.orangeColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
            ),
            onPressed: onTap,
            child: Text(
              imagePath.isEmpty ? "Capture" : "Retake",
            ),
          ),
        ),
      ],
    );
  }
}
