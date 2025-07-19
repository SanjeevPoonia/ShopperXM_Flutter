import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/screen/mcq_test/test_mcq1.dart';
import 'package:shopperxm_flutter/screen/self_training/training_step3.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../network/loader.dart';
import '../../widgets/appbar_widget.dart';


class FinalResultScreen extends StatefulWidget {
  Map<String,dynamic> resultData;
  FinalResultScreen(this.resultData);
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<FinalResultScreen> {
  int selectedRadioIndex=9999;
  bool pageNavigator=false;
  bool check=false;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body: Column(
          children: [
            AppBarWidget("Dr Batra Training"),



            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 13),
                children: [

                  SizedBox(height: 5),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Test',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),

                          ),


                          Text(
                            '5fhfhu44627hf',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),

                          ),



                        ],
                      ),

                      Spacer(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          Text(
                            'Result',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),

                          ),


                          Text(
                            widget.resultData["is_passed"]==1?
                            'Passed':"Failed",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: widget.resultData["is_passed"]==1?Color(0xFF2FAE67):Colors.red
                            ),

                          ),



                        ],
                      ),
                    ],
                  ),


                  SizedBox(height: 5),

                 Divider(
                   thickness: 1.5,
                 ),




                 SizedBox(
                   height: 240,
                   child:  Center(
                     child:Lottie.asset("assets/pass_anim.json") ,
                   ),
                 ),


                  Row(
                    children: [
                     Expanded(child:  Padding(
                       padding: const EdgeInsets.only(right: 10),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [

                           Text(
                             'Questions Attempted',
                             style: TextStyle(
                               fontSize: 12,
                               fontWeight: FontWeight.w600,
                               color: Color(0xFF708096),
                             ),

                           ),

                           SizedBox(height: 7),


                           Text(
                             widget.resultData["attempted_ques"].toString(),
                             style: TextStyle(
                               fontSize: 17,
                               fontWeight: FontWeight.w700,
                               color: Colors.black,
                             ),

                           ),



                         ],
                       ),
                     ),flex: 1),



                    Container(
                      width: 1.5,
                      height: 55,
                      color: Color(0x1F000000),
                    ),

                    

                    Expanded(child:   Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            'Unanswered Questions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF708096),
                            ),

                          ),
                          SizedBox(height: 7),

                          Text(
                            widget.resultData["un_attempted_ques"].toString(),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black
                            ),

                          ),



                        ],
                      ),
                    ),flex: 1)
                    ],
                  ),

                  Container(
                    height: 1.5,
                    color: Color(0x1F000000),
                  ),



                  SizedBox(height: 17),





                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Congrats!! you have scored '),
                         TextSpan(
                            text:  widget.resultData["percentage"].toString()+'% ',
                            style: TextStyle(
                              color: Color(0xFF2FAE67)
                            )

                        ),


                        const TextSpan(
                            text: 'marks'),
                      ],
                    ),
                  ),

                  SizedBox(height: 13),


                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Now you are certified to apply on audits that require'),
                        const TextSpan(
                            text: ' Dr Batra ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,

                            )

                        ),


                        const TextSpan(
                            text: 'certification '),
                      ],
                    ),
                  ),
                  SizedBox(height: 13),
                  Text(
                    'You can score more percentage by re-attempting the centification',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,

                  ),



                  SizedBox(height: 13),
                  Text(
                    'Attempt remaining : '+widget.resultData["attempt_remaining"].toString()+ ' (Questions will change in each attempt)',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,

                  ),
                  SizedBox(height: 15),





                  widget.resultData["is_passed"]==1?
                  InkWell(
                    onTap: (){

                      _launchBrowser(widget.resultData["certificate_url"]);



                     // Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: MCQTest1Screen()));

                    },
                    child: Container(
                      height: 57,
                      color: AppTheme.themeColor,
                      child: Center(child:   Text(
                        'Download Certificate',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),

                      ))
                    ),
                  ):Container(),
                  SizedBox(height: 13),


                  InkWell(
                    onTap: (){

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LandingScreen()),
                              (Route<dynamic> route) => false);


                     // Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: MCQTest1Screen()));

                    },
                    child: Container(
                        height: 57,
                        color: Color(0xFF708096),
                        child: Center(child:   Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),

                        ))
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              )
            ),













          ],
        )
      ),
    );
  }




  _launchBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
          Uri.parse(url), mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw 'Could not launch $url';
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
}
