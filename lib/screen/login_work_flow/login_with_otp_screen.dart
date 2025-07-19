
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/screen/remainder_screen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';



class LoginWithOtpScreen extends StatefulWidget{

  LoginWithOtpScreen();
  LoginWithOtpState createState()=> LoginWithOtpState();
}
class LoginWithOtpState extends State<LoginWithOtpScreen> {
  var usernameController = TextEditingController();
  var userMobNoController = TextEditingController();
  bool passwordVisible=true;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String otpText = '';
  final _formKey = GlobalKey<FormState>();
  int _start = 30;
  Timer? _timer;
  bool otpSend = false;
  bool onClickSend = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
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
                                Text('Login with OTP',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black
                                  ),

                                ),
                                SizedBox(height: 2),
                                Text('Please login to your account.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.60)
                                  ),

                                ),
                                const SizedBox(height: 35),
                                Row(
                                  children: [
                                    Text('Mobile Number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF00376A)
                                      ),

                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Country Flag Icon
                                    GestureDetector(
                                      onTap: () {
                                        print('Hello');
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(0.0),
                                            child: Image.asset(
                                              'assets/india.png', // Replace with your flag icon
                                              width: 20.0,
                                              height: 20.0,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(Icons.keyboard_arrow_down),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text('|',
                                      style: TextStyle(
                                        fontSize: 25
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextFormField(
                                        controller: userMobNoController,
                                        validator: phoneValidator,
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          hintText: "Enter mobile number",
                                          border: InputBorder.none,
                                          suffixIcon: Icon(
                                            Icons.phone_android_outlined,color: Color(0xFF00376A),
                                          ),

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 1,
                                  color: Color(0xFF707070),
                                ),
                                onClickSend == false ? Column(
                                  children: [
                                    const SizedBox(height: 35),
                                    InkWell(
                                      onTap: () {
                                     _submitHandler(context);
                                      },
                                      child: Container(

                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Color(0xFF00376A),
                                              borderRadius: BorderRadius.circular(5)),
                                          height: 45,
                                          child: const Center(
                                            child: Text('SEND OTP',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white)),
                                          )),
                                    ),
                                    const SizedBox(height: 35),
                                  ],
                                ):
                                Column(
                                  children: [
                                  /*  SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(child: InkWell(
                                          onTap: () {


                                          },
                                          child: Text(
                                            'Change Mobile Number',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFF47320),
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xFFF47320),
                                            ),
                                          ),
                                        ),),
                                      ],
                                    ),*/
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text('Mobile Verifaction Code',
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
                                            sendOTP(context);

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
                                    const SizedBox(height: 35),
                                    InkWell(
                                      onTap: () {

                                        if(otpText.length==4)
                                          {
                                            verifyOTP(context);
                                          }




                                      },
                                      child: Container(

                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Color(0xFF00376A),
                                              borderRadius: BorderRadius.circular(5)),
                                          height: 45,
                                          child: const Center(
                                            child: Text('Login',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white)),
                                          )),
                                    ),
                                  ],
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
      ),
    );
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


  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value!)) {
      return 'Please enter valid Mobile number, it must be of 10 digits and begins with 6, 7, 8 or 9.';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    sendOTP(context);
  }

  sendOTP(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Sending OTP...');
    var data = {
      "mobile_no": userMobNoController.text.toString(),
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('sendMobileOtp', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if(responseJSON["status"]==1)
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      onClickSend=true;
      startTimer();
      setState(() {

      });
    }
    else
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }




  }

  verifyOTP(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Verify OTP...');
    var data = {
      "mobile_no": userMobNoController.text.toString(),
      "mobile_otp": otpText
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appVerifyOtp', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if(responseJSON["status"]==1)
    {

      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      AppModel.setTokenValue(responseJSON['auth_key']);
      MyUtils.saveSharedPreferences(
          'access_token', responseJSON['auth_key']);

      AppModel.setUserID("");

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => LandingScreen()));

    }
    else
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }




  }


}

