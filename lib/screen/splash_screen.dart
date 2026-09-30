import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopperxm_flutter/authorization/shopper_basic_signup_screen.dart';
import 'package:toast/toast.dart';

import '../authorization/shopper_signup_dashboard.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/Utils.dart';

// Screens (same as your project)
import 'package:shopperxm_flutter/screen/login_work_flow/login_screen.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/screen/profile_details/basic_information.dart';
import 'package:shopperxm_flutter/screen/faq_term_and_condition/terms_screen.dart';

import '../recording/recording_controller.dart';
import '../recording/recording_screen.dart';
import '../recording/recording_session_storage.dart';


class SplashScreen extends StatefulWidget {
  final String token;
  SplashScreen(this.token);

  @override
  State<SplashScreen> createState() => SplashState();
}

class SplashState extends State<SplashScreen> {

  String authKey = "";
  String userId = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    startFlow();
  }

  // ================= START FLOW =================

  void startFlow() async {
    await Future.delayed(Duration(milliseconds: 500));
    getAppUpdateStatus();
  }

  // ================= VERSION CHECK =================

  Future<void> getAppUpdateStatus() async {
    if (await MyUtils.isNetworkAvailable()) {
      checkAppUpdate();
    } else {
      userValidation();
    }
  }

  Future<void> checkAppUpdate() async {
    try {
      ApiBaseHelper helper = ApiBaseHelper();

      var response = await helper.postAPI(
        "getAppData",
        {"App_Update": "App_Update"},
        context,
      );

      var jsonData = json.decode(response.body);

      if (jsonData["status"] == 1) {
        int liveVersion = int.parse(jsonData["data"]["version_code"]);

        int currentVersion = await MyUtils.getAppVersionCode();

        if (liveVersion > currentVersion) {
          //showUpdateDialog(jsonData["data"]["description"]);
          userToken();
        } else {
          userToken();
        }
      } else {
        userToken();
      }
    } catch (e) {
      userToken();
    }
  }

  // ================= UPDATE DIALOG =================

  void showUpdateDialog(String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("Update Available"),
          content: Text(description),
          actions: [
            ElevatedButton(
              onPressed: () {
                MyUtils.openStore();
              },
              child: Text("Update"),
            )
          ],
        );
      },
    );
  }

  // ================= TOKEN =================

  void userToken() async {
    bool isLoggedOut = await MyUtils.isUserLogout();

    if (!isLoggedOut) {
      authKey = await MyUtils.getSharedPreferences("access_token") ?? "";
      userId = await MyUtils.getSharedPreferences("user_id") ?? "";
      userEmail = await MyUtils.getSharedPreferences("email") ?? "";
      userValidation();
    } else {
      userValidation();
    }
  }



  // ================= USER VALIDATION =================

  void userValidation() async {
    bool isLoggedOut = await MyUtils.isUserLogout();

    if (!isLoggedOut) {
      if (await MyUtils.isNetworkAvailable()) {
        getUserDetails();
      } else {
        Toast.show("Please Check Your Internet !!!");
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  // ================= USER DETAILS =================

  Future<void> getUserDetails() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    try {
      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPIWithHeader(
        "getUserAllInfo",
        {"getUserAllInfo": "getUserAllInfo"},
        context,
      );
      Navigator.pop(context);

      var jsonData = json.decode(response.body);

      if (jsonData["status"] == 1) {
        var data = jsonData["data"];

        String userType = data["user_type"]?.toString() ?? "";
        int overallStatus = data["overall_status"] ?? 0;
        int formLevel = data["form_submit_level"] ?? 0;
        String shopperStatus = data["shoppers_overall_status"]?.toString() ?? "";
        String countryCode = data["country_code"]?.toString() ?? "";
        int sessionExpired = data["session_expire_status"] ?? 0;
        if (sessionExpired == 1) {
          Toast.show("Session Expired");
          MyUtils.logoutUser(context);
          return;
        }

        // ==========================================================
        // CHECK ACTIVE VIDEO RECORDING
        // ==========================================================

        final recordingRestored = await restoreRecordingIfActive();
        if (recordingRestored) {
          return;
        }


        // ================= NAVIGATION =================

        if (userType == "26") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LandingScreen()));
        }
        else if (shopperStatus.isNotEmpty) {
        //else if (shopperStatus.isNotEmpty && overallStatus != 1) {

          if (shopperStatus == "4" || shopperStatus == "5") {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LandingScreen()));
          }
          else if (shopperStatus == "1") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => ShopperBasicSignupScreen()));
          }
          else {
            print("Dashboard Screen Matched");
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ShopperSignupDashboardScreen()));
          }
        }else{
          Toast.show("Please connect with admin. Create a new account and try");
        }
        /*else {
          if (overallStatus == 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LandingScreen()));
          }
          else {

            if (countryCode == "+91") {
              if (formLevel == 0) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BasicInformationScreen({}, "", "")));
              } else if (formLevel == 1) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddressDetailsScreen("", {})));
              } else if (formLevel == 3) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentDetailsScreen({})));
              } else if (formLevel == 5) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => TermsScreen()));
              } else if (formLevel == 7) {
                Toast.show("Account Pending");
              }
            }
          }
        }*/
      }
      else if(jsonData['status']==3){
        Toast.show(jsonData["message"]);
        MyUtils.logoutUser(context);
      }
      else {
        Toast.show(jsonData["message"]);
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      Toast.show("Something went wrong");
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/app_logo.png",
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }

  //================= Check Video Recording ===============================

  Future<bool> checkActiveRecording() async {
    try {
      debugPrint("========================================");
      debugPrint("Checking active recording...");
      debugPrint("========================================");
      final isRecording = await RecordingController.instance.checkRecordingStatus();
      debugPrint("Native recording status: $isRecording");
      // ---------------------------------------------------------
      // No recording is running
      // ---------------------------------------------------------
      if (!isRecording) {
        debugPrint("No native recording is active.");
        // Remove any stale saved session.
        await RecordingSessionStorage.instance.clearRecordingSession();

        return false;
      }

      // ---------------------------------------------------------
      // Native recording is running
      // ---------------------------------------------------------
      final session =
      await RecordingSessionStorage.instance.getActiveSession();

      if (session == null) {
        debugPrint(
          "Native recording is active but no saved session was found.",
        );

        return false;
      }

      debugPrint(
        "Active recording session found: "
            "storeId=${session.storeId}, "
            "storeName=${session.storeName}",
      );

      openRecordingScreen(session);

      return true;
    } catch (e, stackTrace) {
      debugPrint("Error checking active recording: $e");
      debugPrintStack(stackTrace: stackTrace);

      return false;
    }
  }

  void openRecordingScreen(RecordingSession session) {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RecordingScreen(
          userId: session.userId,
          storeId: session.storeId,
          storeName: session.storeName,
          storeCode: session.storeCode,
          storeAddress: session.storeAddress,
          beatplanId: session.beatplanId,
          authKey: session.authKey,
          quality: session.quality,
          camera: session.camera,
        ),
      ),
    );
  }

  Future<bool> restoreRecordingIfActive() async {
    final isRestored = await checkActiveRecording();
    if (isRestored) {
      debugPrint("Recording screen restored.");
      return true;
    }
    debugPrint("No recording to restore.");
    return false;
  }

}