import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopperxm_flutter/authorization/shopper_verifyaadhaar_screen.dart';
import 'package:shopperxm_flutter/network/constants.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';


class ProfileKycinfoScreen extends StatefulWidget {
  const ProfileKycinfoScreen({super.key});

  @override
  State<ProfileKycinfoScreen> createState() =>
      _ShopperSignupKycScreenState();
}

class _ShopperSignupKycScreenState
    extends State<ProfileKycinfoScreen> {

  TextEditingController aadhaarController = TextEditingController();
  TextEditingController panController = TextEditingController();

  bool isAadharVerified = false;

  String aadhaarImagePath = "";
  String panImagePath = "";

  String aadhaarImageUrl = "";
  String panImageUrl = "";

  String verifyUrl = "";
  String clientId = "";

  final ImagePicker picker = ImagePicker();

  String flName="";
  String flMobile="";
  String flemail="";
  String authKey = "", userId = "",  shoppersOverallStatus = "";





  // ================= IMAGE PICK =================

  Future<void> pickImage(String type) async {
    final XFile? file =
    await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      showImageDialog(file.path, type);
    }
  }

  // ================= IMAGE CONFIRM DIALOG =================

  void showImageDialog(String path, String type) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(type == "aadhaar"
                  ? "Aadhaar Image"
                  : "PAN Image"),

              const SizedBox(height: 10),

              Image.file(File(path), height: 200),

              const SizedBox(height: 10),

              Row(
                children: [

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        if (type == "aadhaar") {
                          uploadAadhaar(path);
                        } else {
                          uploadPan(path);
                        }
                      },
                      child: const Text("Upload"),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // ================= UPLOAD (TODO) =================

  void uploadAadhaar(String path)async {
    bool isValid = await detectAadhaarFromImage(path);

    if (!isValid) {
      showMsg("Please upload valid Aadhaar front image");
      return;
    }


    setState(() {
      aadhaarImagePath = path;
      aadhaarImageUrl = "uploaded_url";
    });
  }

  void uploadPan(String path) {
    // TODO: Implement S3 upload using presigned URL

    setState(() {
      panImagePath = path;
      panImageUrl = "uploaded_url";
    });
  }

  // ================= VALIDATION =================

  bool validate() {
    if (aadhaarController.text.length != 12) {
      showMsg("Please enter valid Aadhaar");
      return false;
    }

    if (aadhaarImageUrl.isEmpty) {
      showMsg("Please upload Aadhaar image");
      return false;
    }

    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
        .hasMatch(panController.text)) {
      showMsg("Invalid PAN number");
      return false;
    }

    if (panImageUrl.isEmpty) {
      showMsg("Please upload PAN image");
      return false;
    }

    return true;
  }

  // ================= SUBMIT =================

  Future<void> submit() async {
    APIDialog.showAlertDialog(context, "Please wait...");

    String isVerified = isAadharVerified ? "1" : "0";
    var data = {
      "user_id": userId,
      "aadhaar_number": aadhaarController.text,
      "aadhaar_verified": isVerified,
      "pan_number": panController.text,
      "aadhar_file": aadhaarImageUrl,
      "pan_file": panImageUrl,
    };

    var response = await ApiBaseHelper()
        .postAPIWithHeader("update-freelancer-ID-proof", data, context);

    Navigator.pop(context);

    var jsonData = json.decode(response.body);

    showMsg(jsonData["message"]);

    if (jsonData["status"] == 1) {
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
    }
  }


  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  //=====================Adhaar Detection===============

  Future<bool> detectAadhaarFromImage(String path) async {

    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    textRecognizer.close();

    String fullText = recognizedText.text.replaceAll(" ", "");

    print("OCR TEXT: $fullText");

    // 🔥 Aadhaar regex
    RegExp aadhaarRegex = RegExp(r'\d{12}');

    if (aadhaarRegex.hasMatch(fullText)) {
      return true;
    }

    return false;
  }

  //=====================Generate Aadhaar verify link =============

  Future<void> generateAadharLinkViaDigilocker() async {

    APIDialog.showAlertDialog(context, "Loading...");

    try {

      // 🔥 Prefill Object
      final prefillObject = {
        "full_name": flName,
        "mobile_number": flMobile,
        "user_email": flemail,
      };

      // 🔥 Data Object
      final dataObject = {
        "prefill_options": prefillObject,
        "expiry_minutes": 10,
        "send_sms": false,
        "verify_phone": false,
        "verify_email": false,
        "signup_flow": true,
        "redirect_url": "https://retailanalytics.qdegrees.com",
        "state": "test",
      };

      // 🔥 Main Object
      final mainObject = {
        "data": dataObject,
      };

      print("Request Body: ${jsonEncode(mainObject)}");

      // 🔥 API CALL
      var response = await ApiBaseHelper().postAPIWithHeaderForDigi(
          AppConstant.generateDigilockerAPi,
          mainObject,
          context,
          AppConstant.digilockerVerficationKey
      );

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      var jsonData = json.decode(response.body);

      print("Response: $jsonData");

      int status = jsonData["status_code"] ?? 0;
      String msg = jsonData["message"] ?? "";
      bool success = jsonData["success"] ?? false;

      if (status == 200 && success) {

        var data = jsonData["data"];

        String clientId = data["client_id"] ?? "";
        String token = data["token"] ?? "";
        String url = data["url"] ?? "";

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShopperVerifyAadhaarScreen(
              trainingUrl: url,
              clientId: clientId,
            ),
          ),
        );

        if (result != null) {
          String clientId = result["client_id"];
          verifyAadhaar(clientId);
        }

      } else {
        showMsg(msg);
      }

    } catch (e) {

      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      print(e);
      showMsg("Something went wrong");
    }
  }
  // ================= UI (UNCHANGED) =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [

                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "KYC Details",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    TextField(
                      controller: aadhaarController,
                      enabled: !isAadharVerified,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      decoration: const InputDecoration(
                        labelText: "Aadhaar Card Number",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    Row(
                      children: [

                        if (isAadharVerified)
                          const Text("Verified",
                              style: TextStyle(
                                  color: Colors.green)),

                        const Spacer(),

                        if (!isAadharVerified)
                          GestureDetector(
                            onTap: generateAadharLinkViaDigilocker,
                            child: Container(
                              padding:
                              const EdgeInsets.all(8),
                              color: Colors.green,
                              child: const Text("Verify",
                                  style: TextStyle(
                                      color: Colors.white)),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Text("Upload Aadhaar Image"),

                    const SizedBox(height: 8),

                    Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: aadhaarImagePath.isNotEmpty
                          ? Image.file(File(aadhaarImagePath))
                          : const Icon(Icons.image),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: ElevatedButton(
                        onPressed: () => pickImage("aadhaar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          AppTheme.orangeColor,
                          foregroundColor: Colors.white,
                          minimumSize:
                          const Size(200, 50),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                            "Browse Aadhaar Image"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: panController,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: "PAN Number",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text("Upload PAN Image"),

                    const SizedBox(height: 8),

                    Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: panImagePath.isNotEmpty
                          ? Image.file(File(panImagePath))
                          : const Icon(Icons.image),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: ElevatedButton(
                        onPressed: () => pickImage("pan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          AppTheme.orangeColor,
                          foregroundColor: Colors.white,
                          minimumSize:
                          const Size(200, 50),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                        ),
                        child:
                        const Text("Browse PAN Image"),
                      ),
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: () {
                        if (validate()) submit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        AppTheme.themeColor,
                        foregroundColor: Colors.white,
                        minimumSize:
                        const Size(double.infinity, 50),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }
  void getUserDetails() async {
    authKey = await MyUtils.getSharedPreferences("access_token") ?? "";
    userId = await MyUtils.getSharedPreferences("user_id") ?? "";
    flemail = await MyUtils.getSharedPreferences("email") ?? "";
    flName = await MyUtils.getSharedPreferences("name") ?? "";
    flMobile = await MyUtils.getSharedPreferences("mobile") ?? "";
    shoppersOverallStatus = await MyUtils.getSharedPreferences("shopper_overall_status") ?? "";
    print("shopper overall status: $shoppersOverallStatus");

    setState(() {});
  }

  Future<void> verifyAadhaar(String clientId) async {

    APIDialog.showAlertDialog(context, "Verifying...");

    try {
      String url=AppConstant.verifyDigilockerAPi+clientId;



      var response = await ApiBaseHelper().getDigi(url,  context,AppConstant.digilockerVerficationKey);

      Navigator.pop(context);

      var jsonData = json.decode(response.body);

      if (jsonData["status_code"] == 200) {
        var data= jsonData['data']??{};
        var adharXml=data['aadhaar_xml_data']??{};
        String maskedAadhar=adharXml['masked_aadhaar']?.toString()??"XXXX-XXXX-XXXX";

        setState(() {
          isAadharVerified = true;
          aadhaarController.text = maskedAadhar;
        });
        showMsg("Aadhaar Verified Successfully");
      } else {
        showMsg(jsonData["message"]);
      }

    } catch (e) {

      Navigator.pop(context);
      showMsg("Verification failed");
    }
  }
}


