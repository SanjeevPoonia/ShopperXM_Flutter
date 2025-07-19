
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopperxm_flutter/screen/faq_term_and_condition/terms_screen.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/account_create_screen.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/login_with_otp_screen.dart';
import 'package:shopperxm_flutter/screen/profile_details/address_details_screen.dart';
import 'package:shopperxm_flutter/screen/profile_details/payment_details_screen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';
import '../profile_details/basic_information.dart';
import '../remainder_screen.dart';



class GlupleRegisterScreen extends StatefulWidget{
  LoginState createState()=> LoginState();
}
class LoginState extends State<GlupleRegisterScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  bool passwordVisible=true;
  final _formKeyLogin = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    ToastContext().init(context);
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



                                Image.asset("assets/gluple_ic.png",width: 50,height: 50),

                                SizedBox(height: 15),



                                Text('Hello',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black
                                  ),

                                ),
                                SizedBox(height: 2),
                                Text('Create an account with Glueple',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.60)
                                  ),
                                  textAlign: TextAlign.center,

                                ),
                                const SizedBox(height: 16),
                                Container(
                                  child: TextFormField(
                                    controller: usernameController,
                                    validator: emailValidator,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: "Official Email Address",
                                      label: Text("Official Email Address",
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


                                SizedBox(height: 15),

                                Row(
                                  children: [

                                    Text('Already registered? Sign in to continue ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color: Colors.black.withOpacity(0.60)
                                      ),

                                    ),

                                  ],
                                ),

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
                                        child: Text('VERIFY EMAIL',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),

                                SizedBox(height: 35),
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

  String? checkPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
  void _submitHandler(BuildContext context) async {
    if (!_formKeyLogin.currentState!.validate()) {
      return;
    }
    _formKeyLogin.currentState!.save();
    forgotPassword(context);

  }


  forgotPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please wait...');
    var data = {
      "email": usernameController.text,

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('resetPassword', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);

    if(responseJSON["status"]==1)
      {
        Toast.show(responseJSON["message"],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        Navigator.pop(context);

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






}
