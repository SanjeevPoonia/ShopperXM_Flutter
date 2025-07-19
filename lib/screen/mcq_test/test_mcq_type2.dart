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
import 'package:shopperxm_flutter/screen/mcq_test/test_mcq_type3.dart';
import 'package:shopperxm_flutter/screen/self_training/training_step3.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:video_player/video_player.dart';

import '../../network/loader.dart';
import '../../widgets/appbar_widget.dart';


class MCQTestType2Screen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MCQTestType2Screen> {
  int selectedRadioIndex=9999;
  bool pageNavigator=false;
  bool check=false;
  int selectedOption=0;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget("Dr Batra Training"),



            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Test Code',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),

                      ),


                      Text(
                        'Dr batra',
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
                        'Test Time',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),

                      ),


                      Text(
                        '20 Mins',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF7C00)
                        ),

                      ),



                    ],
                  ),

                  SizedBox(width: 10),

                  SizedBox(
                    height: 55,
                    child:  Center(
                      child:Lottie.asset("assets/clock_anim.json") ,
                    ),
                  ),



                ],
              ),
            ),


            Padding(padding: EdgeInsets.symmetric(horizontal: 13),

            child: Divider(
              thickness: 1.4,

            ),

            ),



            SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Text(
                'Question 1',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),

              ),
            ),
            SizedBox(height: 3),

            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),

              ),
            ),

            SizedBox(height: 12),

            InkWell(
              onTap: (){
                setState(() {
                  selectedOption=1;
                });

              },
              child: Container(
                height: 90,
                margin: EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: selectedOption==1?Color(0xFFFFF1E4):Color(0xFFF2F2F2),
                  border: Border.all(color: Color(0xFF707070),width: 0.3)
                ),

                child: Row(
                  children: [

                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 8),
                     child: Image.asset("assets/medi.png",width: 130,height: 72),
                   ),

                    Expanded(child: Text(
                      'Homeopathy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:selectedOption==1? FontWeight.w600:FontWeight.w500,
                        color: selectedOption==1?Color(0xFFFF7C00):Color(0xFF708096),
                      ),

                    ))


                  ],
                ),
              ),
            ),


            SizedBox(height: 10),

            InkWell(
              onTap: (){
                setState(() {
                  selectedOption=2;
                });

              },
              child: Container(
                height: 90,
                margin: EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: selectedOption==2?Color(0xFFFFF1E4):Color(0xFFF2F2F2),
                    border: Border.all(color: Color(0xFF707070),width: 0.3)
                ),

                child: Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.asset("assets/medi.png",width: 130,height: 72),
                    ),

                    Expanded(child: Text(
                      'Allopathy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:selectedOption==2? FontWeight.w600:FontWeight.w500,
                        color: selectedOption==2?Color(0xFFFF7C00):Color(0xFF708096),
                      ),

                    ))


                  ],
                ),
              ),
            ),


            SizedBox(height: 10),

            InkWell(
              onTap: (){
                setState(() {
                  selectedOption=3;
                });

              },
              child: Container(
                height: 90,
                margin: EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: selectedOption==3?Color(0xFFFFF1E4):Color(0xFFF2F2F2),
                    border: Border.all(color: Color(0xFF707070),width: 0.3)
                ),

                child: Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.asset("assets/medi.png",width: 130,height: 72),
                    ),

                    Expanded(child: Text(
                      'Both Homeopathy and Allopathy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:selectedOption==3? FontWeight.w600:FontWeight.w500,
                        color: selectedOption==3?Color(0xFFFF7C00):Color(0xFF708096),
                      ),

                    ))


                  ],
                ),
              ),
            ),





            Spacer(),

            InkWell(
              onTap: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: MCQTestType3Screen()));

              },
              child: Container(
                height: 57,
                margin: const EdgeInsets.symmetric(horizontal: 13),
                color: AppTheme.themeColor,
                child: Center(child:   Text(
                  'Next',
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
        ),
      ),
    );
  }

  void certificateBottomSheet(BuildContext context) {
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

                    SizedBox(width: 15),


                    Text("Certificate",
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



                SizedBox(
                  height: 160,
                  child: OverflowBox(
                    minHeight: 240,
                    maxHeight: 240,
                    child:  Lottie.asset("assets/cloud_anim.json"),
                  ),
                ),




                Text("Complete training to view or download certificate",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),textAlign: TextAlign.center),


                SizedBox(height: 25),



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


                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
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


  void aboutTrainingBottomSheet(BuildContext context) {
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

                    SizedBox(width: 5),


                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("About Training",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                    ),

                    Spacer(),

                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",width: 38,height: 38)),
                    SizedBox(width: 4),
                  ],
                ),


                SizedBox(height: 20),



                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),textAlign: TextAlign.center),
                ),


                SizedBox(height: 25),



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


                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
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


  void courseContentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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

                    Text("Course Content",
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


               Container(
                 height: 360,
                 child: ListView.builder(
                      itemCount: 4,
                     itemBuilder: (BuildContext context,int pos)

                 {
                   return Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                       Row(
                         children: [
                           Icon(Icons.check_circle,color: Color(0xFfFF7C00),size: 16),

                           SizedBox(width: 5),

                           Text("Chapter 1",
                               style: TextStyle(
                                 fontSize: 11,
                                 fontWeight: FontWeight.w700,
                                 color: Color(0xFF00407E),
                               )),

                           Spacer(),




                         ],
                       ),



                       Row(
                         children: [
                           Expanded(
                             child: Text("Lorem Ipsum is simply dummy text of",
                                 style: TextStyle(
                                   fontSize: 15,
                                   fontWeight: FontWeight.w600,
                                   color: Colors.black,
                                 )),
                           ),


                           SizedBox(
                             width: 60,
                             height: 60,
                             child: OverflowBox(
                                 minHeight: 60,
                                 maxHeight: 60,
                                 child:   Lottie.asset("assets/download_anim.json")
                             ),
                           ),





                         ],
                       ),



                       Text("PDF",
                           style: TextStyle(
                             fontSize: 11,
                             fontWeight: FontWeight.w400,
                             color: Colors.black,
                           )),

                       SizedBox(height: 15)

                     ],
                   );
                 }


                 ),
               ),






                SizedBox(height: 25),







              ],
            ),
          );
        }

        );

      },
    );
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
}
