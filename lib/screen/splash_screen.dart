

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopperxm_flutter/screen/faq_term_and_condition/terms_screen.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/login_screen.dart';
import 'package:shopperxm_flutter/screen/profile_details/basic_information.dart';
import 'package:shopperxm_flutter/screen/remainder_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/audit_form.dart';
import 'package:shopperxm_flutter/screen/start_audit/fill_audit_screen.dart';

import '../network/api_dialog.dart';
import 'audits/record_video_screen.dart';
import 'chunk_upload_screen.dart';

class SplashScreen extends StatefulWidget
{
  final String token;
  SplashScreen(this.token);
  SplashState createState()=>SplashState();
}
class SplashState extends State<SplashScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/app_logo.png",width: MediaQuery.of(context).size.width*0.6),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  _navigateUser() async {
    if(widget.token!='')
    {
     /* Timer(
          Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => UploadFilesScreen(1, 1,1, "168452", "20270"))));*/
      Timer(
          Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LandingScreen())));

    }
    else
    {
      Timer(
          Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen())));
    }
  }
}
