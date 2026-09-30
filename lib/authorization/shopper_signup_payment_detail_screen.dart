import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shopperxm_flutter/authorization/shopper_signup_kyc_screen.dart';
import '../network/api_helper.dart';
import '../network/api_dialog.dart';
import '../network/Utils.dart';
import '../utils/app_theme.dart';

class ShopperSignupPaymentInfoScreen extends StatefulWidget {
  @override
  State<ShopperSignupPaymentInfoScreen> createState() =>
      _ShopperSignupPaymentInfoScreenState();
}

class _ShopperSignupPaymentInfoScreenState
    extends State<ShopperSignupPaymentInfoScreen> {

  TextEditingController accountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String bankName = "";
  String bankAddress="";
  String uploadedImageUrl = "";
  File? selectedImage;

  String authKey = "", userId = "";

  String awsBucket = "";
  String awsRegion = "ap-south-1";
  String awsKey = "";
  String awsSecret = "";
  String awsBaseUrl = "";

  double uploadProgress = 0;
  bool isUploading = false;
  bool uploadFailed = false;


  @override
  void initState() {
    super.initState();
    getUserDetails();
    getAwsDetails();

    ifscController.addListener(() {
      if (ifscController.text.length == 11) {
        getBankName(ifscController.text);
      } else {
        setState(() => bankName = "");
      }
    });
  }

  // ================= USER =================
  void getUserDetails() async {
    authKey = await MyUtils.getSharedPreferences("access_token") ?? "";
    userId = await MyUtils.getSharedPreferences("user_id") ?? "";
  }

  // ================= AWS =================
  void getAwsDetails() async {
    awsBucket = await MyUtils.getSharedPreferences("aws_bucket") ?? "";
    awsKey = await MyUtils.getSharedPreferences("aws_key") ?? "";
    awsSecret = await MyUtils.getSharedPreferences("aws_secret") ?? "";
    awsBaseUrl = await MyUtils.getSharedPreferences("aws_base_url") ?? "";
  }

  // ================= IFSC =================
  Future<void> getBankName(String ifsc) async {

    APIDialog.showAlertDialog(context, "Loading...");

    try {

      var response = await ApiBaseHelper().getPublic(
        "https://ifsc.razorpay.com/$ifsc",
      );

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      // 🔥 IMPORTANT FIX
      if (response.statusCode == 200 &&
          response.body.startsWith("{")) {

        var jsonData = json.decode(response.body);

        setState(() {
          bankName = jsonData["BANK"]?.toString() ?? "";
          bankAddress = jsonData['ADDRESS']?.toString() ?? "";
        });

      } else {
        // ❌ invalid IFSC
        setState(() {
          bankName = "";
          bankAddress = "";
        });

        showMsg("Invalid IFSC Code");
      }

    } catch (e) {

      print(e);

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      setState(() {
        bankName = "";
        bankAddress = "";
      });

      showMsg("Invalid IFSC Code");
    }
  }

  // ================= IMAGE PICK =================
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      selectedImage=File(file.path);
      showImageDialog(File(file.path));
    }
  }

  // ================= IMAGE PREVIEW DIALOG =================
  void showImageDialog(File file) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Cheque or Passbook Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Image.file(file, height: 200),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                      //uploadItemOnS3Flutter(file.path, setState);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.themeColor,
                      foregroundColor: Colors.white, // text color
                      minimumSize: const Size(200, 50), // full width + height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: Text("Upload"),
                  )
                ],
              ),

              SizedBox(height: 50,)
            ],
          ),
        );
      },
    );
  }

  // ================= S3 UPLOAD =================
  Future<void> uploadItemOnS3Flutter(
      String imagePath,
      Function(void Function()) setState,
      ) async {

    File file = File(imagePath);

    if (!file.existsSync()) {
      showMsg("Upload Service unable to find the image");
      return;
    }

    setState(() {
      isUploading = true;
      uploadFailed = false;
      uploadProgress = 0;
    });

    try {

      String currentTime = DateTime.now().millisecondsSinceEpoch.toString();

      String extension = imagePath.substring(imagePath.lastIndexOf("."));

      String fileName =
          "${userId}image_bank${currentTime}s3$extension";

      String fileKey = "images/kyc/$fileName";

      String uploadUrl =
          "https://$awsBucket.s3.$awsRegion.amazonaws.com/$fileKey";

      Dio dio = Dio();

      await dio.put(
        uploadUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            "Content-Type": "image/jpeg",
            "x-amz-acl": "public-read",
          },
        ),
        onSendProgress: (sent, total) {
          setState(() {
            uploadProgress = sent / total;
          });
        },
      );

      // ✅ SUCCESS (same as TransferState.COMPLETED)
      setState(() {
        isUploading = false;
        uploadedImageUrl = "$awsBaseUrl/$fileKey";
      });

      showMsg("Image Uploaded successfully!!!");

    } catch (e) {

      // ❌ FAILED (same as TransferState.FAILED)
      setState(() {
        isUploading = false;
        uploadFailed = true;
      });

      showMsg("Error!!! Image Uploading Failed...");
    }
  }

  // ================= VALIDATION =================
  bool validate() {
    if (accountController.text.isEmpty) {
      return showMsg("Account number required");
    }
    if (accountController.text.length < 9 ||
        accountController.text.length > 18) {
      return showMsg("Invalid account number");
    }
    if (ifscController.text.length != 11) {
      return showMsg("Invalid IFSC");
    }
    if (bankName.isEmpty) {
      return showMsg("Bank not found");
    }
    if (nameController.text.length < 3) {
      return showMsg("Invalid name");
    }
    /*if (uploadedImageUrl.isEmpty) {
      return showMsg("Upload image required");
    }*/
    return true;
  }

  bool showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
    return false;
  }

  // ================= API =================
  Future<void> submit() async {
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "user_id": userId,
      "bank_name": bankName,
      "account_holder_name": nameController.text,
      "account_number": accountController.text,
      "ifsc_code": ifscController.text,
      "attachment_url": uploadedImageUrl.isEmpty?"will Upload later ":uploadedImageUrl
    };

    var response = await ApiBaseHelper()
        .postAPIWithHeader("update-freelancer-Bank-details", data, context);

    Navigator.pop(context);

    var jsonData = json.decode(response.body);

    showMsg(jsonData["message"]);

    if (jsonData["status"] == 1) {
      await MyUtils.saveSharedPreferences("shopper_overall_status", "3");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShopperSignupKycScreen()),
      );
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bank Account Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: accountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Account Number"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: ifscController,
              maxLength: 11,
              decoration: const InputDecoration(labelText: "IFSC Code"),
            ),

            Text(bankAddress,
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration:
              const InputDecoration(labelText: "Account Holder Name"),
            ),

            const SizedBox(height: 20),

            const Text("Upload Cheque or Passbook Image"),

            const SizedBox(height: 10),

            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: selectedImage != null
                  ? Image.file(selectedImage!, fit: BoxFit.cover)
                  : Image.asset("assets/demo_img.png",fit: BoxFit.contain,),
            ),

            const SizedBox(height: 10),

            Center(child: ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.orangeColor,
                foregroundColor: Colors.white, // text color
                minimumSize: const Size(200, 50), // full width + height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Text("Browse"),
            ),),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (validate()) submit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.themeColor,
                foregroundColor: Colors.white, // text color
                minimumSize: const Size(double.infinity, 50), // full width + height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}