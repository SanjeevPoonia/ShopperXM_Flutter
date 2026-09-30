import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shopperxm_flutter/authorization/shopper_basic_verify_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:toast/toast.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';


class ShopperBasicSignupScreen extends StatefulWidget{
  _ShopperBasicDetailScreenState createState()=>_ShopperBasicDetailScreenState();
}
class _ShopperBasicDetailScreenState extends State<ShopperBasicSignupScreen> {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String countryCode = "+91";
  String countryName = "India";

  String latitude = "0.0";
  String longitude = "0.0";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  // ================= LOCATION =================
  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
  }

  // ================= VALIDATION =================
  bool validate() {
    if (firstNameController.text.trim().isEmpty) {
      showMsg("First Name is required");
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      showMsg("Last Name is required");
      return false;
    }
    if (mobileController.text.length < 7) {
      showMsg("Enter valid mobile number");
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      showMsg("Enter valid email");
      return false;
    }
    if (passwordController.text.length < 8) {
      showMsg("Password must be 8 characters");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showMsg("Password not matched");
      return false;
    }
    return true;
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= API =================
  addBasicDetailsSignup() async{
    APIDialog.showAlertDialog(context, 'Please wait...');
    try{
      final body = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "mobile_no": mobileController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "confirm_password": confirmPasswordController.text,
        "lattitude": latitude,
        "longitude": longitude,
        "country_code": countryCode,
        "country_name": countryName,
      };

      print(body);
      final helper = ApiBaseHelper();
      final response = await helper.postAPI('save_Freelancer_UserDetails', body, context);
      Navigator.pop(context);
      final responseJSON = json.decode(response.body);
      final int code = responseJSON['status'] ?? 0;
      final String msg = responseJSON['message']?.toString() ?? "Something went wrong. Please try again later";

      void showError() {
        Toast.show(msg,
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
      // ✅ Main logic
      if (code == 1) {
        String userId=responseJSON['data']['id']?.toString()??"";
        String authKey=responseJSON['data']['auth_key']?.toString()??"";
        String moOtp=responseJSON['data']['otp_code_mobile']?.toString()??"";
        String emOtp=responseJSON['data']['otp_code_email']?.toString()??"";
        showAccountCreatedDialog(msg, userId, authKey, moOtp, emOtp);
      }else{
        showError();
      }






    }catch(e){
      Navigator.of(context).pop();
      Toast.show("Unexpected error occurred",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }


  // ================= DIALOG =================
  void showAccountCreatedDialog(
      String msg, String userId, String authKey, String moOtp, String emOtp) {

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/shopper_done_anim.json', height: 120),
              const SizedBox(height: 10),
              Text(msg, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  redirectToOTP(userId, authKey, moOtp, emOtp);
                },
                child: const Text("Verify"),
              )
            ],
          ),
        );
      },
    );
  }

  // ================= NAVIGATION =================
  void redirectToOTP(
      String userId, String authKey, String moOtp, String emOtp) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopperOtpVerificationScreen(userId: userId, authKey: authKey, mobileOtp: moOtp, emailOtp: emOtp)));
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Basic Information")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                buildField(firstNameController, "First Name"),
                buildField(lastNameController, "Last Name"),

                // 🔥 Country Picker + Mobile
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (code) {
                        countryCode = code.dialCode ?? "+91";
                        countryName = code.name ?? "India";
                      },
                      initialSelection: 'IN',
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                    ),
                    Expanded(
                      child: buildField(
                        mobileController,
                        "Mobile Number",
                        type: TextInputType.phone,
                      ),
                    ),
                  ],
                ),

                buildField(emailController, "Email",
                    type: TextInputType.emailAddress),
                buildField(passwordController, "Password", obscure: true),
                buildField(confirmPasswordController, "Confirm Password",
                    obscure: true),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // 🔶 background color
                    foregroundColor: Colors.white,  // ⚪ text color
                  ),
                  onPressed: () {
                    if (validate()) {
                      addBasicDetailsSignup();
                    }
                  },
                  child: const Text("Next"),
                )
              ],
            ),
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget buildField(TextEditingController controller, String hint,
      {TextInputType type = TextInputType.text, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
