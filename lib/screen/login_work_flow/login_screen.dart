
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopperxm_flutter/screen/faq_term_and_condition/terms_screen.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/account_create_screen.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/glueple_register_screen.dart';
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
import 'basic_information_sign_up_screen.dart';
import 'forgot_password.dart';



class LoginScreen extends StatefulWidget{
  LoginState createState()=> LoginState();
}
class LoginState extends State<LoginScreen> {
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
                                Text('Hello',
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
                                SizedBox(height: 10),
                                Container(
                                  child: TextFormField(
                                    validator: checkPasswordValidator,
                                    controller: passwordController,
                                    obscureText: passwordVisible,
                                    decoration: InputDecoration(
                                      hintText: "Enter Password",
                                      label: const Text("Password",
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
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(child: InkWell(
                                      onTap: () {



                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));

                                      },
                                      child: Text(
                                        'Forget Password?',
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
                                    Expanded(child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithOtpScreen()));

                                      },
                                      child: Text(
                                        'Login with OTP',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFF47320),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xFFF47320),
                                        ),
                                      ),
                                    ),)

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
                                        child: Text('Login',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),
                                SizedBox(height: 20),
                                Text('Don not have an account yet ?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: Colors.black
                                  ),

                                ),
                                SizedBox(height: 4),
                                InkWell(
                                  onTap: () {
                                    registerBottomSheet(context);
                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreateScreen()));
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicInformationSignUpScreen({},"","")));
                                  },
                                  child: Text(
                                    'Create An Account',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFF47320),
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFFF47320),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                RichText(
                                  text: TextSpan(
                                    text: 'By continuing, you agree to our ',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 11
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'T&Cs',
                                        style: TextStyle(
                                          color: Color(0xFFFF8500),
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launchUrl(Uri.parse("https://retailanalytics.qdegrees.com/terms_conditions.html"));

                                          },
                                      ),
                                      TextSpan(
                                        text: ' and ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Color(0xFFFF8500),
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launchUrl(Uri.parse("https://retailanalytics.qdegrees.com/privacy_policy.html"));
                                          },
                                      ),
                                    ],
                                  ),
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
    loginUser(context);

  }
  void registerBottomSheet(BuildContext context) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,


                  children: [
                    SizedBox(width: 100),

                    Text("Create Account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),

                    Spacer(),

                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",width: 38,height: 38)),
                    SizedBox(width: 4),
                  ],
                ),




                SizedBox(height: 15),



                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 48,
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
                      onPressed: () {

                        Navigator.pop(context);

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>GlupleRegisterScreen()));

                      },
                      child: Row(
                        children: [

                            //user_register
                          Image.asset("assets/gluple_ic.png",width: 30,height: 30),

                          SizedBox(width: 15),





                          Text(
                            'Sign Up with Gluple',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 48,
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
                      onPressed: () {

                        Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicInformationSignUpScreen({},"","")));



                      },
                      child: Row(
                        children: [

                          //user_register
                          Image.asset("assets/user_register.png",width: 30,height: 30),

                          SizedBox(width: 15),





                          Text(
                            'Normal signup',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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

  loginUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Logging in...');
    var data = {
      "email": usernameController.text,
      "password": passwordController.text,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('loginUser', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);

    if(responseJSON["status"]==1)
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      AppModel.setTokenValue(responseJSON['auth_key']);
      
      if(usernameController.text.toString().contains("@qdegrees.com") || usernameController.text.toString().contains("@qdegrees.org"))
        {
          AppModel.setUserType("1");
          MyUtils.saveSharedPreferences("usertype", "1");
        }
      else
        {
          AppModel.setUserType("2");
          MyUtils.saveSharedPreferences("usertype", "2");
        }
      
      
      MyUtils.saveSharedPreferences(
          'access_token', responseJSON['auth_key']);
      MyUtils.saveSharedPreferences(
          'user_id', responseJSON['user_id'].toString());
      MyUtils.saveSharedPreferences(
          'email', usernameController.text);
      AppModel.setUserID(responseJSON['user_id'].toString());
      if(responseJSON["overall_status"]==1)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LandingScreen()));
      }
      else if(responseJSON["overall_status"]==0 && responseJSON["form_submit_level"]==7)
      {
        Toast.show("Your Account Is Pending Please wait For Approval!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }

      else if(responseJSON["form_submit_level"]==0)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BasicInformationScreen({},usernameController.text,responseJSON["mobile_no"].toString())));
      }

      else if(responseJSON["form_submit_level"]==1)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => AddressDetailsScreen("",{})));
      }

      else if(responseJSON["form_submit_level"]==3)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => PaymentDetailsScreen({})));
      }
      else if(responseJSON["form_submit_level"]==5)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => TermsScreen()));
      }
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
