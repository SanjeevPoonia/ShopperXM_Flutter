import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../screen/login_work_flow/login_screen.dart';

class ShopperOtpVerificationScreen extends StatefulWidget {
  final String userId;
  final String authKey;
  final String mobileOtp;
  final String emailOtp;

  const ShopperOtpVerificationScreen({
    required this.userId,
    required this.authKey,
    required this.mobileOtp,
    required this.emailOtp,
  });

  @override
  State<ShopperOtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<ShopperOtpVerificationScreen> {

  // Controllers
  List<TextEditingController> mobileOtp = List.generate(4, (_) => TextEditingController());
  List<TextEditingController> emailOtp = List.generate(4, (_) => TextEditingController());

  List<FocusNode> mobileFocus = List.generate(4, (_) => FocusNode());
  List<FocusNode> emailFocus = List.generate(4, (_) => FocusNode());

  int emailTimer = 30;
  int mobileTimer = 30;

  Timer? emailCountdown;
  Timer? mobileCountdown;

  bool showEmailResend = false;
  bool showMobileResend = false;

  bool isLoading = false;

  String verifyApi = "YOUR_VERIFY_API";
  String resendApi = "YOUR_RESEND_API";

  @override
  void initState() {
    super.initState();
    startTimers();
    prefillOtp();
  }

  // ================= PREFILL =================
  void prefillOtp() {
    if (widget.mobileOtp.length == 4) {
      for (int i = 0; i < 4; i++) {
        mobileOtp[i].text = widget.mobileOtp[i];
      }
    }
  }

  // ================= TIMER =================
  void startTimers() {
    emailCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (emailTimer == 0) {
        setState(() {
          showEmailResend = true;
        });
        timer.cancel();
      } else {
        setState(() => emailTimer--);
      }
    });

    mobileCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mobileTimer == 0) {
        setState(() {
          showMobileResend = true;
        });
        timer.cancel();
      } else {
        setState(() => mobileTimer--);
      }
    });
  }

  // ================= VALIDATE =================
  bool validate() {
    String mobile = mobileOtp.map((e) => e.text).join();
    String email = emailOtp.map((e) => e.text).join();

    if (mobile.length != 4 || email.length != 4) {
      showMsg("Please enter a 4-digit OTP");
      return false;
    }
    return true;
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= VERIFY API =================
  verifyOTP() async{
    APIDialog.showAlertDialog(context, 'Please wait...');
    try{
      final body = {
        "user_id": widget.userId,
        "otp_code_mobile": mobileOtp.map((e) => e.text).join(),
        "otp_code_email": emailOtp.map((e) => e.text).join(),
      };

      print(body);
      final helper = ApiBaseHelper();
      final response = await helper.postAPI('verify-freelancer-otp', body, context);
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
      if (code == 200) {
        showSuccessDialog(msg);
      }

      // ❌ All failure cases
      showError();



    }catch(e){
      Navigator.of(context).pop();
      Toast.show("Unexpected error occurred",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }


  // ================= RESEND =================
  Future<void> resendOTP(String type) async {
    setState(() => isLoading = true);

    final body = {
      "user_id": widget.userId,
      "otp_type": type, // 1 = mobile, 2 = email
    };

    try {
      print(body);
      final helper = ApiBaseHelper();
      final response = await helper.postAPI('resend-freelancer-otp', body, context);
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
        if (type == "1") {
          String newOtp = responseJSON['mobile_otp'];
          for (int i = 0; i < 4; i++) {
            mobileOtp[i].text = newOtp[i];
          }
          mobileTimer = 30;
          showMobileResend = false;
          startTimers();
        } else {
          emailTimer = 30;
          showEmailResend = false;
          startTimers();
        }
      }

      // ❌ All failure cases
      showError();
    } catch (e) {
      showMsg("Resend failed");
    }

    setState(() => isLoading = false);
  }

  // ================= DIALOG =================
  void showSuccessDialog(String msg) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/shopper_otp_anim.json', height: 120),
              Text(msg),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                  );// back to dashboard
                },
                child: const Text("Continue"),
              )
            ],
          ),
        );
      },
    );
  }

  // ================= OTP BOX =================
  Widget buildOtpBox(
      TextEditingController controller,
      FocusNode focusNode,
      FocusNode? next,
      FocusNode? prev) {

    return Container(
      width: 45,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        onChanged: (val) {
          if (val.isNotEmpty) {
            next?.requestFocus();
          } else {
            prev?.requestFocus();
          }
        },
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF00376A),
      body: Stack(
        children: [
          // 🔹 Background Image
          Image.asset(
            "assets/login_background.png",
            width: double.infinity,
            fit: BoxFit.fill,
          ),

          // 🔹 Main Card
          Column(
            children: [
              const Spacer(),

              Container(
                width: screenWidth,
                margin: const EdgeInsets.only(bottom: 30, left: 25, right: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [

                      const SizedBox(height: 16),

                      const Text(
                        'OTP Verification',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Please enter the OTP sent on\nyour mobile and email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ================= EMAIL =================
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email Verification Code',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00376A),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (i) {
                          return buildOtpBox(
                            emailOtp[i],
                            emailFocus[i],
                            i < 3 ? emailFocus[i + 1] : null,
                            i > 0 ? emailFocus[i - 1] : null,
                          );
                        }),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Resend OTP in 00:${emailTimer.toString().padLeft(2, '0')} sec",
                        style: const TextStyle(color: Colors.red),
                      ),

                      if (showEmailResend)
                        TextButton(
                          onPressed: () => resendOTP("2"),
                          child: const Text("Resend"),
                        ),

                      const SizedBox(height: 20),

                      // ================= MOBILE =================
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mobile Verification Code',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00376A),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (i) {
                          return buildOtpBox(
                            mobileOtp[i],
                            mobileFocus[i],
                            i < 3 ? mobileFocus[i + 1] : null,
                            i > 0 ? mobileFocus[i - 1] : null,
                          );
                        }),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Resend OTP in 00:${mobileTimer.toString().padLeft(2, '0')} sec",
                        style: const TextStyle(color: Colors.red),
                      ),

                      if (showMobileResend)
                        TextButton(
                          onPressed: () => resendOTP("1"),
                          child: const Text("Resend"),
                        ),

                      const SizedBox(height: 30),

                      // 🔥 VALIDATE BUTTON (Styled)
                      InkWell(
                        onTap: () {
                          if (validate()) verifyOTP();
                        },
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00376A),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              "VALIDATE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Image.asset("assets/qdegrees_logo.png",
                          width: 150, height: 16),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}