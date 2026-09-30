
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screen/login_work_flow/login_screen.dart';
import 'package:flutter/material.dart';

class MyUtils
{
  static Future<Null> saveSharedPreferences(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
    return null;
  }
  static Future<void> saveAwsDetails({
    required String region,
    required String bucket,
    required String baseUrl,
    required String storeImgPath,
    required String storeSelfiePath,
    required String audioPath,
    required String videoPath,
    required String imgPath,
    required String transactionPath,
    required String key,
    required String secret,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("region", region);
    await prefs.setString("bucket", bucket);
    await prefs.setString("base_url", baseUrl);
    await prefs.setString("store_img_path", storeImgPath);
    await prefs.setString("store_selfie_path", storeSelfiePath);
    await prefs.setString("audio_path", audioPath);
    await prefs.setString("video_path", videoPath);
    await prefs.setString("img_path", imgPath);
    await prefs.setString("transaction_path", transactionPath);
    await prefs.setString("key", key);
    await prefs.setString("secret", secret);
  }

  static Future<String?> getSharedPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? value =  preferences.getString(key);
    return value;
  }
  static Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  static Future<int> getAppVersionCode() async {
    final packageInfo = await PackageInfo.fromPlatform();
    // Android → versionCode
    // iOS → buildNumber
    return int.tryParse(packageInfo.buildNumber) ?? 0;
  }
  /// Returns versionName (1.0.0)
  static Future<String> getAppVersionName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
  static Future<void> openStore() async {

    String androidPackageName = "com.yourapp.package"; // 🔁 change this
    String iosAppId = "1234567890"; // 🔁 change this (App Store ID)

    Uri url;

    if (Platform.isAndroid) {
      url = Uri.parse("market://details?id=$androidPackageName");

      if (!await canLaunchUrl(url)) {
        url = Uri.parse(
            "https://play.google.com/store/apps/details?id=$androidPackageName");
      }
    } else if (Platform.isIOS) {
      url = Uri.parse("https://apps.apple.com/app/id$iosAppId");
    } else {
      return;
    }

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
  static Future<bool> isUserLogout()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? userId =  preferences.getString("user_id");
    bool isavailable=false;
    if(userId==null || userId.isEmpty){
      isavailable=true;
    }else{isavailable=false;}
    return isavailable;
  }

  static void logoutUser(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => true);
  }
}