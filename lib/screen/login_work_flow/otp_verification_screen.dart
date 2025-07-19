
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/login_screen.dart';
import 'package:shopperxm_flutter/screen/profile_details/basic_information.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';



class OtpVerificationScreen extends StatefulWidget{

  final String email;
  final String phone;


  OtpVerificationScreen(this.email,this.phone);
  OtpVerificationState createState()=> OtpVerificationState();
}
class OtpVerificationState extends State<OtpVerificationScreen> {
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool passwordVisible=true;
  bool confirmPasswordVisible=true;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingControllerMob = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String otpText = '';
  String otpTextMob = '';
  final _formKey = GlobalKey<FormState>();
  int _start = 30;
  Timer? _timer;
  bool otpSend = false;
  int _start_mob = 30;
  Timer? _timer_mob;
  bool otpSendMob = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    startTimerMob();
  }

  Widget build(BuildContext context) {
    ToastContext().init(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.themeColor,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    //transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    padding: const EdgeInsets.only(top: 2),
                    child: Image.asset("assets/login_background.png",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          width: screenWidth,
                          margin: EdgeInsets.only(bottom: 30,left: 25,right: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20,right: 20),
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                Text('OTP Verifaction',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black
                                  ),

                                ),
                                SizedBox(height: 2),
                                Text('Please enter the OTP sent on\nyour mobile',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.60)
                                  ),

                                ),
                                const SizedBox(height: 10),
                                /*   Row(
                                children: [
                                  Text('Email Verification Code',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xFF00376A)
                                    ),

                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                height: 50,
                                child: Center(
                                    child:

                                    PinCodeTextField(
                                      length: 4,
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      animationType: AnimationType.fade,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        borderWidth: 1,
                                        borderRadius: BorderRadius.circular(5),
                                        fieldHeight: 50,
                                        selectedColor:AppTheme.themeColor,
                                        selectedFillColor: Colors.white,
                                        fieldWidth: 40,
                                        activeFillColor: Colors.white,
                                        activeColor: Colors.green,
                                        inactiveFillColor: AppTheme.otpColor,
                                        inactiveColor: AppTheme.otpColor,
                                        disabledColor:  AppTheme.otpColor,
                                        errorBorderColor: Colors.red,
                                      ),
                                      animationDuration: Duration(milliseconds: 300),
                                      backgroundColor: Colors.white,
                                      enableActiveFill: true,
                                      errorAnimationController: errorController,
                                      controller: textEditingController,
                                      enablePinAutofill: false,
                                      onCompleted: (v) {
                                        print("Completed");
                                        print(v);
                                        otpText =
                                            v;

                                      },
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          otpText =
                                              value;
                                        });
                                      },
                                      appContext: context,
                                    )

                                ),
                              ),*/
                                /*  const SizedBox(height: 25),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                      children: <TextSpan>[
                                        const TextSpan(
                                            text: 'Resend OTP in '),
                                        TextSpan(
                                          text: _start < 10
                                              ? '00:0' +
                                              _start.toString()
                                              : '00:' +
                                              _start.toString(),
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                        const TextSpan(
                                            text: ' seconds '),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text('Didn\'t receive the OTP ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
                                      )),
                                  _start == 0
                                      ? GestureDetector(
                                    onTap: () {
                                      startTimer();
                                    },
                                    child: Text('Resend',
                                        style: TextStyle(
                                            fontSize: 15,
                                            decoration:
                                            TextDecoration
                                                .underline,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: AppTheme
                                                .themeColor)),
                                  )
                                      : Text('Resend',
                                      style: TextStyle(
                                          fontSize: 15,
                                          decoration:
                                          TextDecoration
                                              .underline,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: Colors.grey)),
                                ],
                              ),
                              SizedBox(height: 30),*/
                                Row(
                                  children: [

                                    SizedBox(width: 10),
                                    Text('Mobile Verification Code',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF00376A)
                                      ),

                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  height: 50,
                                  child: Center(
                                      child:

                                      PinCodeTextField(
                                        length: 4,
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        animationType: AnimationType.fade,
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.box,
                                          borderWidth: 1,
                                          borderRadius: BorderRadius.circular(5),
                                          fieldHeight: 50,
                                          selectedColor:AppTheme.themeColor,
                                          selectedFillColor: Colors.white,
                                          fieldWidth: 40,
                                          activeFillColor: Colors.white,
                                          activeColor: Colors.green,
                                          inactiveFillColor: AppTheme.otpColor,
                                          inactiveColor: AppTheme.otpColor,
                                          disabledColor:  AppTheme.otpColor,
                                          errorBorderColor: Colors.red,
                                        ),
                                        animationDuration: Duration(milliseconds: 300),
                                        backgroundColor: Colors.white,
                                        enableActiveFill: true,
                                        errorAnimationController: errorController,
                                        controller: textEditingControllerMob,
                                        enablePinAutofill: false,
                                        onCompleted: (v) {
                                          print("Completed");
                                          print(v);
                                          otpTextMob =
                                              v;

                                        },
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            otpTextMob =
                                                value;
                                          });
                                        },
                                        appContext: context,
                                      )

                                  ),
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                        children: <TextSpan>[
                                          const TextSpan(
                                              text: 'Resend OTP in '),
                                          TextSpan(
                                            text: _start_mob < 10
                                                ? '00:0' +
                                                _start_mob.toString()
                                                : '00:' +
                                                _start_mob.toString(),
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                          const TextSpan(
                                              text: ' seconds '),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text('Didn\'t receive the OTP ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A1A1A),
                                        )),
                                    _start_mob == 0
                                        ? GestureDetector(
                                      onTap: () {
                                        resendOTP(context);
                                      },
                                      child: Text('Resend',
                                          style: TextStyle(
                                              fontSize: 15,
                                              decoration:
                                              TextDecoration
                                                  .underline,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: AppTheme
                                                  .themeColor)),
                                    )
                                        : Text('Resend',
                                        style: TextStyle(
                                            fontSize: 15,
                                            decoration:
                                            TextDecoration
                                                .underline,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: Colors.grey)),
                                  ],
                                ),


                                SizedBox(height: 15),



                                Container(
                                  child: TextFormField(
                                    validator: checkPasswordValidator,
                                    controller: passwordController,
                                    obscureText: passwordVisible,
                                    decoration: InputDecoration(
                                      hintText: "Enter Password",
                                      label: const Text("Enter New Password here",
                                        style: TextStyle(
                                            color: Color(0xFF00376A)
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility, color: Color(0xFF00376A),),
                                        onPressed: () {
                                          setState(
                                                () {
                                              passwordVisible = !passwordVisible;
                                            },
                                          );
                                        },
                                      ),
                                      alignLabelWithHint: false,
                                      filled: false,
                                      enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:Color(0xFF00376A))),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,

                                  ),

                                ),
                                const SizedBox(height: 13),
                                Container(
                                  child: TextFormField(
                                    validator: checkConfirmPasswordValidator,
                                    controller: confirmPasswordController,
                                    obscureText: confirmPasswordVisible,
                                    decoration: InputDecoration(
                                      hintText: "Enter Password",
                                      label: const Text("Confirm Password here",
                                        style: TextStyle(
                                            color: Color(0xFF00376A)
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(confirmPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility, color: Color(0xFF00376A),),
                                        onPressed: () {
                                          setState(
                                                () {
                                              confirmPasswordVisible = !confirmPasswordVisible;
                                            },
                                          );
                                        },
                                      ),
                                      alignLabelWithHint: false,
                                      filled: false,
                                      enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:Color(0xFF00376A))),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,

                                  ),

                                ),




                                const SizedBox(height: 35),
                                InkWell(
                                  onTap: () {

                                    if(otpTextMob.length!=4)
                                      {
                                        Toast.show("Please enter a valid OTP",
                                            duration: Toast.lengthLong,
                                            gravity: Toast.bottom,
                                            backgroundColor: Colors.red);
                                      }
                                    else
                                      {
                                        _submitHandler(context);
                                      }




                                 //   _showCenterPopup(context);
                                  },
                                  child: Container(

                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF00376A),
                                          borderRadius: BorderRadius.circular(5)),
                                      height: 45,
                                      child: const Center(
                                        child: Text('VALIDATE',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),
                                SizedBox(height: 20),
                                Image.asset("assets/qdegrees_logo.png", width:150 ,
                                    height: 16),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      )
    );
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    verifyOTP(context);

  }


  verifyOTP(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Verifying OTP...');
    var data = {
      "email": widget.email,
      "mobile_otp":otpTextMob,
      "password":passwordController.text
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('verifyOtp', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);

    if(responseJSON["status"]==1)
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

     _showCenterPopup(context);


    }
    else
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


    print(responseJSON);

  }



  resendOTP(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Sending OTP...');
    var data = {
      "mobile_no": widget.phone,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('resendMobileOtp', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);

    if(responseJSON["status"]==1)
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      startTimer();


    }
    else
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


    print(responseJSON);

  }


  String? checkPasswordValidator(String? value) {
    if (value!.isEmpty || value.toString().length<6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

  String? checkConfirmPasswordValidator(String? value) {
    if (value!=passwordController.text.toString()) {
      return 'Password and Confirm password should be same';
    }
    return null;
  }
  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  void startTimerMob() {
    _start_mob = 30;
    const oneSec = const Duration(seconds: 1);
    _timer_mob = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start_mob == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start_mob--;
          });
        }
      },
    );
  }

  void _showCenterPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1, child: Container(
                        child: Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/close.png', // Replace with your image path
                                      width: 16, // Set the desired width
                                      height: 16, // Set the desired height
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Lottie.asset('assets/otp_verified.json',
                            width: 160.0, // Adjust the image width as needed
                            height: 160.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text('OTP Verified',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D2226)

                    ),
                  ),
                  SizedBox(height: 20),
                  Text('You have successfully verified OTP',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2226).withOpacity(0.60)

                    ),
                  ),

                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {

                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Color(0xFF00376A), // Set the background color of the button
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text('NEXT STEP',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

