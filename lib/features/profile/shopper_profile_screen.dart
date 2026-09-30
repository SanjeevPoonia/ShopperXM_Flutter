import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/features/profile/profile_additioninfo_screen.dart';
import 'package:shopperxm_flutter/features/profile/profile_basic_info_screen.dart';
import 'package:shopperxm_flutter/features/profile/profile_kycinfo_screen.dart';
import 'package:shopperxm_flutter/features/profile/profile_payment_info_screen.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/Utils.dart';
import '../../screen/login_work_flow/login_screen.dart';
import '../../utils/app_theme.dart';

class ShopperProfileScreen extends StatefulWidget {
  const ShopperProfileScreen({super.key});

  @override
  State<ShopperProfileScreen> createState() =>
      _ShopperProfileScreenState();
}

class _ShopperProfileScreenState extends State<ShopperProfileScreen>
    with SingleTickerProviderStateMixin {

  // ============================================================
  // USER DETAILS
  // ============================================================

  String userName = "";
  String userEmail = "";
  String userId = "";
  String authKey = "";
  String shoppersOverallStatus = "";

  // ============================================================
  // PROFILE STATUS
  // ============================================================

  String profileStatus = "";

  int emailMobileVerified = 0;
  int bankDetailStatus = 0;
  int aadhaarPanStatus = 0;
  int otherProfileStatus = 0;

  int profilePercentage = 0;

  bool isLoadingProfile = false;
  bool isChangingPassword = false;
  bool isLoggingOut = false;

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController oldPasswordController =
  TextEditingController();

  final TextEditingController newPasswordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    loadUserDetails();
  }

  // ============================================================
  // LOAD USER DETAILS
  // ============================================================

  Future<void> loadUserDetails() async {
    try {
      final isLoggedOut = await MyUtils.isUserLogout();

      if (isLoggedOut) {
        if (!mounted) return;

        Toast.show(
          "Session expired",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );

        return;
      }



      userId =
          await MyUtils.getSharedPreferences("user_id") ?? "";

      userName =
          await MyUtils.getSharedPreferences("name") ?? "";

      userEmail =
          await MyUtils.getSharedPreferences("email") ?? "";

      authKey =
          await MyUtils.getSharedPreferences("access_token") ?? "";

      shoppersOverallStatus =
          await MyUtils.getSharedPreferences("shopper_status") ?? "";

      if (mounted) {
        setState(() {});
      }

      await getProfileFromServer();

    } catch (e) {
      debugPrint("loadUserDetails error: $e");
    }
  }

  // ============================================================
  // PROFILE API
  // ============================================================

  Future<void> getProfileFromServer() async {

    if (isLoadingProfile) return;

    setState(() {
      isLoadingProfile = true;
    });

    try {

      final helper = ApiBaseHelper();

      final response = await helper.getWithHeader(
        "get_profile_complete_status",
        context,
      );

      final jsonObject = json.decode(response.body);

      debugPrint("Profile API Response: $jsonObject");

      if (jsonObject["success"] == true) {

        final dataObject = jsonObject["data"];

        final profileStatusObject =
        dataObject["profile_status"];

        profileStatus =
            profileStatusObject["profile_status"]
                ?.toString() ??
                "0%";

        final informationStatus =
        profileStatusObject["information_status"];

        emailMobileVerified =
            int.tryParse(
              informationStatus[
              "Email or Mobile verified"]
                  ?.toString() ??
                  "0",
            ) ??
                0;

        bankDetailStatus =
            int.tryParse(
              informationStatus[
              "Bank details provided"]
                  ?.toString() ??
                  "0",
            ) ??
                0;

        aadhaarPanStatus =
            int.tryParse(
              informationStatus[
              "Aadhaar and PAN details"]
                  ?.toString() ??
                  "0",
            ) ??
                0;

        otherProfileStatus =
            int.tryParse(
              informationStatus[
              "Other profile details"]
                  ?.toString() ??
                  "0",
            ) ??
                0;

        profilePercentage =
            int.tryParse(
              profileStatus.replaceAll("%", "").trim(),
            ) ??
                0;

        if (mounted) {
          setState(() {});
        }

      } else {

        Toast.show(
          jsonObject["message"]?.toString() ??
              "Unable to load profile",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }

    } catch (e) {

      debugPrint(
        "getProfileFromServer error: $e",
      );

      if (mounted) {
        Toast.show(
          "Error! Something went wrong. Please try again.",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }

    } finally {

      if (mounted) {
        setState(() {
          isLoadingProfile = false;
        });
      }
    }
  }

  // ============================================================
  // PROFILE STATUS TEXT
  // ============================================================

  String getProfileStatusText() {

    if (profilePercentage < 50) {
      return "Profile Incomplete";
    }

    if (profilePercentage < 100) {
      return "Almost there";
    }

    return "Profile Complete";
  }

  // ============================================================
  // CHANGE PASSWORD DIALOG
  // ============================================================

  void showChangePasswordDialog() {

    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) {

        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // ==================================================
                      // HEADER
                      // ==================================================

                      Row(
                        children: [

                          const Expanded(
                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // OLD PASSWORD
                      // ==================================================

                      TextField(
                        controller:
                        oldPasswordController,
                        obscureText: obscureOld,
                        textInputAction:
                        TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "Old Password",
                          hintText:
                          "Enter old password",
                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          suffixIcon:
                          IconButton(
                            icon: Icon(
                              obscureOld
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                obscureOld =
                                !obscureOld;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // NEW PASSWORD
                      // ==================================================

                      TextField(
                        controller:
                        newPasswordController,
                        obscureText: obscureNew,
                        textInputAction:
                        TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          hintText:
                          "Enter new password",
                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          suffixIcon:
                          IconButton(
                            icon: Icon(
                              obscureNew
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                obscureNew =
                                !obscureNew;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // CONFIRM PASSWORD
                      // ==================================================

                      TextField(
                        controller:
                        confirmPasswordController,
                        obscureText: obscureConfirm,
                        textInputAction:
                        TextInputAction.done,
                        decoration: InputDecoration(
                          labelText:
                          "Confirm New Password",
                          hintText:
                          "Confirm new password",
                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          suffixIcon:
                          IconButton(
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                obscureConfirm =
                                !obscureConfirm;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // SUBMIT
                      // ==================================================

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed:
                          isChangingPassword
                              ? null
                              : () {
                            Navigator.pop(
                              context,
                            );

                            changePasswordApi();
                          },
                          child: isChangingPassword
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Submit",
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // CHANGE PASSWORD API
  // ============================================================

  Future<void> changePasswordApi() async {

    final oldPassword =
    oldPasswordController.text.trim();

    final newPassword =
    newPasswordController.text.trim();

    final confirmPassword =
    confirmPasswordController.text.trim();

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (oldPassword.isEmpty ||
        oldPassword.length < 8) {

      Toast.show(
        "The old password must be at least 8 digits long.",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );

      return;
    }

    if (newPassword.isEmpty ||
        newPassword.length < 8) {

      Toast.show(
        "The new password must be at least 8 digits long.",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );

      return;
    }

    if (confirmPassword.isEmpty) {

      Toast.show(
        "Please confirm your new password.",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );

      return;
    }

    if (newPassword != confirmPassword) {

      Toast.show(
        "New password and Confirm New password must be same!",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );

      return;
    }

    final isInternet =
    await MyUtils.isNetworkAvailable();

    if (!isInternet) {

      Toast.show(
        "Please check your internet connection",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );

      return;
    }

    setState(() {
      isChangingPassword = true;
    });

    try {

      final helper = ApiBaseHelper();

      final response =
      await helper.postAPIWithHeader(
        "change_password",
        {
          "old_password": oldPassword,
          "password": confirmPassword,
        },
        context,
      );

      final jsonObject =
      json.decode(response.body);

      debugPrint(
        "Change Password Response: $jsonObject",
      );

      if (jsonObject["status"] == 1) {

        Toast.show(
          jsonObject["message"]?.toString() ??
              "Password changed successfully",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );

        final newToken =
        jsonObject["auth_key"]?.toString();

        if (newToken != null &&
            newToken.isNotEmpty) {

          await MyUtils.saveSharedPreferences(
            "access_token",
            newToken,
          );

          authKey = newToken;
        }

      } else {

        Toast.show(
          jsonObject["message"]?.toString() ??
              "Unable to change password",
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
        );
      }

    } catch (e) {

      debugPrint(
        "changePasswordApi error: $e",
      );

      Toast.show(
        "Error! Something went wrong. Please try again.",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );

    } finally {

      if (mounted) {
        setState(() {
          isChangingPassword = false;
        });
      }
    }
  }

  // ============================================================
  // LOGOUT CONFIRMATION
  // ============================================================

  void showLogoutDialog() {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                "Cancel",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                logout(context);
              //  removeFcmTokenFromServer();
              },
              child: const Text(
                "Logout",
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // REMOVE FCM TOKEN
  // ============================================================

  /*Future<void> removeFcmTokenFromServer() async {

    if (isLoggingOut) return;

    setState(() {
      isLoggingOut = true;
    });

    try {

      final helper = ApiBaseHelper();

      final response =
      await helper.patchAPIWithHeader(
        "clear_fcm_token",
        {
          "user_id": userId,
        },
        context,
      );

      final jsonObject =
      json.decode(response.body);

      debugPrint(
        "Remove FCM Response: $jsonObject",
      );

      // Java implementation logs out whether
      // request succeeds or fails.
      await logoutUser();

    } catch (e) {

      debugPrint(
        "removeFcmTokenFromServer error: $e",
      );

      await logoutUser();

    } finally {

      if (mounted) {
        setState(() {
          isLoggingOut = false;
        });
      }
    }
  }*/

  // ============================================================
  // LOGOUT USER
  // ============================================================



  void logout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,bottomSheetState)
        {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)), // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),

                Center(
                  child: Container(
                    height: 6,
                    width: 62,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 14),
                    Center(
                      child: Text("Are you Sure?",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),

                    ),

                    Spacer(),

                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",width: 38,height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Lottie.asset('assets/logout.json',
                          width: 200.0, // Adjust the image width as needed
                          height: 200.0,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 25),


                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ))),
                      onPressed: () async {
                        Navigator.pop(context);
                        SharedPreferences preferences = await SharedPreferences.getInstance();
                        await preferences.clear();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => true);

                      },
                      child: const Text(
                        'LOGOUT',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 15),



              ],
            ),
          );
        }

        );

      },
    );
  }

  // ============================================================
  // NAVIGATION HELPERS
  // ============================================================

  void openBasicInformation() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileBasicInfoScreen(),
      ),
    );
  }

  void openPaymentInformation() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePaymentInfoScreen(),
      ),
    );
  }

  void openKycInformation() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileKycinfoScreen(),
      ),
    );
  }

  void openAdditionalInformation() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const ProfileAdditioninfoScreen(),
      ),
    );
  }

  // ============================================================
  // STATUS ICON
  // ============================================================

  Widget statusIcon(int status) {

    if (status == 1) {

      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 25,
      );
    }

    return const Icon(
      Icons.access_time,
      color: Colors.orange,
      size: 25,
    );
  }

  // ============================================================
  // PROFILE ITEM
  // ============================================================

  Widget profileItem({
    required IconData icon,
    required String title,
    required int status,
    required VoidCallback onTap,
  }) {

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        child: Row(
          children: [

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: Icon(
                icon,
                size: 27,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            statusIcon(status),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: isLoadingProfile?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
          child: Column(
            children: [

              // ==================================================
              // PROFILE HEADER
              // ==================================================

              SizedBox(
                height: 200,
                child: Stack(
                  children: [

                    Positioned.fill(
                      child: Container(
                        decoration:
                        const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xff4A90E2),
                              Color(0xff7B61FF),
                            ],
                          ),
                        ),
                      ),
                    ),



                    // ------------------------------------------------
                    // USER DETAILS
                    // ------------------------------------------------

                    Positioned(
                      left: 20,
                      right: 20,
                      top: 50,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [

                          Text(
                            userName.isEmpty
                                ? "User name"
                                : userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            userEmail.isEmpty
                                ? "user_email@demo.com"
                                : userEmail,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 20),

                          if (profileStatus.isNotEmpty)
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [

                                SizedBox(
                                  width: 200,
                                  child:
                                  LinearProgressIndicator(
                                    value: profilePercentage / 100,
                                    minHeight: 12,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      AppTheme.orangeColor,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  profileStatus,
                                  style:
                                  const TextStyle(
                                    color:
                                    AppTheme.orangeColor,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  getProfileStatusText(),
                                  style:
                                  const TextStyle(
                                    color:
                                    AppTheme.orangeColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // ------------------------------------------------
                    // PERSON ICON
                    // ------------------------------------------------

                    const Positioned(
                      left: 15,
                      bottom: 10,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor:
                        Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // PROFILE ITEMS
              // ==================================================

              profileItem(
                icon: Icons.person_outline,
                title: "Basic Information",
                status: emailMobileVerified,
                onTap: openBasicInformation,
              ),

              const Divider(height: 1),

              profileItem(
                icon: Icons.account_balance,
                title: "Payment Information",
                status: bankDetailStatus,
                onTap: openPaymentInformation,
              ),

              const Divider(height: 1),

              profileItem(
                icon: Icons.badge_outlined,
                title: "Kyc Document",
                status: aadhaarPanStatus,
                onTap: openKycInformation,
              ),

              const Divider(height: 1),

              profileItem(
                icon: Icons.info_outline,
                title: "Additional Information",
                status: otherProfileStatus,
                onTap: openAdditionalInformation,
              ),

              const Divider(height: 1),

              profileItem(
                icon: Icons.lock_outline,
                title: "Change Password",
                status: 1,
                onTap: showChangePasswordDialog,
              ),

              const Divider(height: 1),

              // ==================================================
              // LOGOUT
              // ==================================================

              InkWell(
                onTap: isLoggingOut
                    ? null
                    : showLogoutDialog,
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [

                      Container(
                        width: 48,
                        height: 48,
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                            10,
                          ),
                          color: Colors.grey.shade100,
                        ),
                        child: const Icon(
                          Icons.logout,
                          size: 27,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(width: 15),

                      const Expanded(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),

                      if (isLoggingOut)
                        const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {

    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }
}


// ================================================================
// TEMPORARY SCREEN PLACEHOLDERS
// ================================================================
//
// Replace these with your actual Flutter screens.
//
// I have kept them here only so the profile screen structure is
// clear. Do NOT create these if these screens already exist.
// ================================================================



