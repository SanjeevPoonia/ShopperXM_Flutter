
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/login_with_otp_screen.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/otp_verification_screen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';



class AccountCreateScreen extends StatefulWidget{

  AccountCreateScreen();
  AccountCreateState createState()=> AccountCreateState();
}
class AccountCreateState extends State<AccountCreateScreen> {
  var usernameController = TextEditingController();
  var userMobNoController = TextEditingController();
  final _formKeyLogin = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.themeColor,
      body: Form(
        key: _formKeyLogin,
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
                                Text('Validate Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black
                                  ),

                                ),
                                SizedBox(height: 2),
                                Text('Please enter your details\nto verify details.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.60)
                                  ),

                                ),
                                const SizedBox(height: 16),
                                Container(
                                  child: TextFormField(
                                    controller: usernameController,
                                    validator: emailValidator,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: "Email Address",
                                      label: Text("Email Address",
                                        style: TextStyle(
                                            color: Color(0xFF00376A)
                                        ),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.email_outlined,color: Color(0xFF00376A),
                                      ),
                                      enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:Color(0xFF00376A))),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text('Mobile Number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
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
                                SizedBox(height: 50),

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
                                        child: Text('VALIDATE',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),
                                SizedBox(height: 50),
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
  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }
  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value!)) {
      return 'Please enter valid Mobile number, it must be of 10 digits and begins with 6, 7, 8 or 9.';
    }
    return null;
  }


  void _submitHandler(BuildContext context) async {
    if (!_formKeyLogin.currentState!.validate()) {
      return;
    }
    _formKeyLogin.currentState!.save();
    validateUser(context);

  }

  validateUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Validating user...');
    var data = {
      "email": usernameController.text,
      "mobile_no":userMobNoController.text
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('validateUser', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);

    if(responseJSON["status"]==1)
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

       Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerificationScreen(usernameController.text,userMobNoController.text)));
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
  String? checkEmptyString(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    //if (value!.isEmpty || !regex.hasMatch(value)) {
    if (value!.isEmpty) {
      return 'Please enter Your Email or Employee Code';
    }
    return null;
  }

}
