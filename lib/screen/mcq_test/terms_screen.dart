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
import 'package:shopperxm_flutter/screen/mcq_test/test_mcq1.dart';
import 'package:shopperxm_flutter/screen/self_training/training_step3.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:video_player/video_player.dart';

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../widgets/appbar_widget.dart';


class MCQTermsScreen extends StatefulWidget {
  final String trainingID;
  MCQTermsScreen(this.trainingID);
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MCQTermsScreen> {
  int selectedRadioIndex=9999;
  VideoPlayerController? _controller;
  late final chewieController;
  bool isLoading=false;
  Map<String,dynamic> trainingData={};
  bool pageNavigator=false;
  bool check=false;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body: Column(
          children: [
            AppBarWidget(trainingData.isEmpty?"":trainingData["training_name"]),



            Expanded(
              child:
              isLoading?

                  Center(
                    child:Loader()
                  ):


              ListView(
                padding: EdgeInsets.symmetric(horizontal: 13),
                children: [

                  SizedBox(height: 5),

                  Row(
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
                            trainingData.isEmpty?"":trainingData["training_name"],
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
                            trainingData.isEmpty?"":(trainingData["questions"].length*2).toString()+' Mins',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF7C00)
                            ),

                          ),



                        ],
                      ),
                    ],
                  ),


                  SizedBox(height: 5),


                 SizedBox(
                   height: 210,
                   child:  Center(
                     child:Lottie.asset("assets/test_anim.json") ,
                   ),
                 ),

                  SizedBox(height: 25),
                  Row(
                    children: [

                      Container(
                        width: 35.22,
                        height: 21,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF00407E),width: 2)
                        ),

                        child: Row(

                          children: [

                            Expanded(child: Center(
                              child:   Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            )),



                            Container(
                              height: 21,
                              width: 2,
                              color:Color(0xFF00407E)
                            ),



                            Expanded(child: Center(
                              child:   Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            ))



                          ],
                        ),

                      ),


                      SizedBox(width: 15),
                      
                      Expanded(child: Text(
                        trainingData.isEmpty?"":
                        'Maximum '+trainingData["max_attempt_allowed"].toString()+  ' attempts are allowed to complete the test',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),

                      ))


                    ],
                  ),


                  SizedBox(height: 7),

                  Row(
                    children: [

                      Container(
                        width: 35.22,
                        height: 21,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF00407E),width: 2)
                        ),

                        child: Row(

                          children: [

                            Expanded(child: Center(
                              child:   Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            )),



                            Container(
                                height: 21,
                                width: 2,
                                color:Color(0xFF00407E)
                            ),



                            Expanded(child: Center(
                              child:   Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            ))



                          ],
                        ),

                      ),


                      SizedBox(width: 15),

                      Expanded(child: Text(
                        trainingData.isEmpty?"":
                        'Attempts Remaining : '+trainingData["remaining_attempt"].toString(),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),

                      ))


                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [

                      Container(
                        width: 35.22,
                        height: 21,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF00407E),width: 2)
                        ),

                        child: Row(

                          children: [

                            Expanded(child: Center(
                              child:   Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            )),



                            Container(
                                height: 21,
                                width: 2,
                                color:Color(0xFF00407E)
                            ),



                            Expanded(child: Center(
                              child:   Text(
                                '3',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            ))



                          ],
                        ),

                      ),


                      SizedBox(width: 15),

                      Text(
                        'Valid from : ',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),

                      ),


                      Text(
                        trainingData.isEmpty?"":trainingData["valid_from"],
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),

                      )



                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [

                      Container(
                        width: 35.22,
                        height: 21,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF00407E),width: 2)
                        ),

                        child: Row(

                          children: [

                            Expanded(child: Center(
                              child:   Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            )),



                            Container(
                                height: 21,
                                width: 2,
                                color:Color(0xFF00407E)
                            ),



                            Expanded(child: Center(
                              child:   Text(
                                '4',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            ))



                          ],
                        ),

                      ),


                      SizedBox(width: 15),

                      Text(
                        'Valid up to : ',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),

                      ),


                      Text(
                        trainingData.isEmpty?"":trainingData["valid_till"],
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),

                      )



                    ],
                  ),




                  SizedBox(height: 12),

                  Row(
                    children: [

                      Container(
                        width: 35.22,
                        height: 21,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF00407E),width: 2)
                        ),

                        child: Row(

                          children: [

                            Expanded(child: Center(
                              child:   Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            )),



                            Container(
                                height: 21,
                                width: 2,
                                color:Color(0xFF00407E)
                            ),



                            Expanded(child: Center(
                              child:   Text(
                                '5',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            ))



                          ],
                        ),

                      ),


                      SizedBox(width: 15),

                      Text(
                        'Last attempted : ',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),

                      ),


                      Text(
                        trainingData.isEmpty?"":trainingData["last_attempt_date"],
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),

                      )



                    ],
                  ),

                  SizedBox(height: 15),
                  Text(
                    'Achieve highest percentage within given number of attempts to increase chances of assigning audits for you.',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),

                  ),

                  SizedBox(height: 15),



                  Text(
                    trainingData.isEmpty?"":
                    'Total Questions : '+trainingData["questions"].length.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),

                  ),
                  SizedBox(height: 15),

                  Text(
                    'Please Confirm',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.themeColor,
                    ),

                  ),
                  SizedBox(height: 15),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: 35.22,
                        height: 21,
                        margin: EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF00407E),width: 2)
                        ),

                        child: Row(

                          children: [

                            Expanded(child: Center(
                              child:   Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            )),



                            Container(
                                height: 21,
                                width: 2,
                                color:Color(0xFF00407E)
                            ),



                            Expanded(child: Center(
                              child:   Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            ))



                          ],
                        ),

                      ),


                      SizedBox(width: 15),

                      Expanded(child: Text(
                        'Make sure you have a good internet connectivity (Test might included images and videos)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),

                      ))


                    ],
                  ),


                  SizedBox(height: 7),

                  Row(
                    children: [

                      Container(
                        width: 35.22,
                        height: 21,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF00407E),width: 2)
                        ),

                        child: Row(

                          children: [

                            Expanded(child: Center(
                              child:   Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            )),



                            Container(
                                height: 21,
                                width: 2,
                                color:Color(0xFF00407E)
                            ),



                            Expanded(child: Center(
                              child:   Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),

                              ),
                            ))



                          ],
                        ),

                      ),


                      SizedBox(width: 15),

                      Expanded(child: Text(
                        'Submit test before closing app',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),

                      ))


                    ],
                  ),

                  SizedBox(height: 18),




                  Container(
                    height: 47,
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: AppTheme.themeColor.withOpacity(0.10)
                    ),

                    child: Row(
                      children: [

                        InkWell(
                          onTap:(){

                            setState(() {
                              check=!check;
                            });
                  },
                          child: Container(

                              child:

                              check?
                                  Icon(Icons.check_box,color: Color(0xFF00376A)):

                              Icon(Icons.check_box_outline_blank)),
                        ),

                        SizedBox(width: 12),


                        Expanded(child: Text(
                          'I\'ve read all instructions carefully',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),

                        ))




                      ],
                    ),



                  ),

                  SizedBox(height: 16),

                  InkWell(
                    onTap: (){

                      if(check)
                        {
                          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: MCQTest1Screen(widget.trainingID)));

                        }
                    },
                    child: Container(
                      height: 57,
                      color: AppTheme.themeColor,
                      child: Row(
                        children: [

                          SizedBox(width: 25),

                          SizedBox(
                              width:47,
                              height: 47,
                              child: Lottie.asset("assets/play_anim.json")),




                          SizedBox(width: 5),


                          Expanded(child: Center(child:   Text(
                            'Start Test',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),

                          ))),


                          SizedBox(width: 55),


                        ],
                      ),
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
    getTrainingDetails(context);

  }

  getTrainingDetails(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
      "training_id":widget.trainingID

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getTrainingQuiz', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    trainingData=responseJSON["data"];
    setState(() {

    });



  }


}
