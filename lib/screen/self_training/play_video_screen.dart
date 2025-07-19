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
import 'package:shopperxm_flutter/screen/self_training/training_step2.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:video_player/video_player.dart';

import '../../network/loader.dart';
import '../../widgets/appbar_widget.dart';
import '../payment_earned/payment_earned_screen.dart';


class VideoScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<VideoScreen> {
  int selectedRadioIndex=9999;
  VideoPlayerController? _controller;
  late final chewieController;
  bool pageNavigator=false;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body: Column(
          children: [
            Stack(
              children: [

                _controller!.value.isInitialized?
                Container(
                  margin: EdgeInsets.only(top:25),
                    height: 260,
                    width: double.infinity,
                    child:Chewie(
                      controller: chewieController,
                    ),




                ):


                Container(
                    height:224,
                    child:Center(
                      child: Loader(),

                    )
                ),



                AppBarWidget("Dr Batra Training"),
              ],
            ),



            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [












                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'Lorem Ipsum is simply dummy text of the',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),

                    ),
                  ),


                  SizedBox(height: 5),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'Lorem Ipsum',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),

                    ),
                  ),
                  SizedBox(height: 15),



                  InkWell(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: TrainingStep2Screen()));

                    },
                    child: Container(
                      height: 61,
                      color: AppTheme.themeColor,
                      margin: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [

                          SizedBox(width: 25),

                          SizedBox(
                              width:47,
                              height: 47,
                              child: Lottie.asset("assets/play_anim.json")),




                          SizedBox(width: 35),



                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [



                              Text(
                                'Next Chapter',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),

                              ),








                              Text(
                                'Chapter 3 . PDF',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFB5B6B7),
                                ),

                              ),



                            ],
                          )


                        ],
                      ),
                    ),
                  ),



                  SizedBox(height: 14),



                  Container(
                    color: Color(0xFFF9F9F9),
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [





                        Text(
                          'Resources',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),

                        ),

                        GestureDetector(
                          onTap: (){
                            courseContentBottomSheet(context);

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [



                                Text(
                                  '0 Resources',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),

                                ),

                                Spacer(),


                                Image.asset("assets/navigate_ic.png",width: 10.1,height:10.1),


                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Color(0xFF707070).withOpacity(0.20),
                        ),









                      GestureDetector(
                        onTap: (){
                          courseContentBottomSheet(context);

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [

                              Image.asset("assets/tr_ic1.png",width: 28,height: 26),

                              SizedBox(width: 10),



                              Text(
                                'Course content',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),

                              ),

                              Spacer(),


                              Image.asset("assets/navigate_ic.png",width: 10.1,height:10.1),


                            ],
                          ),
                        ),
                      ),


                        GestureDetector(
                          onTap: (){
                            certificateBottomSheet(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [

                                Image.asset("assets/tr_ic2.png",width: 20,height: 28),

                                SizedBox(width: 17),



                                Text(
                                  'Certificate',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),

                                ),

                                Spacer(),


                                Image.asset("assets/navigate_ic.png",width: 10.1,height:10.1),


                              ],
                            ),
                          ),
                        ),


                        GestureDetector(
                          onTap: (){
                            aboutTrainingBottomSheet(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [

                                Image.asset("assets/tr_ic3.png",width: 26.59,height: 26.59),

                                SizedBox(width: 10),



                                Text(
                                  'About this Course',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),

                                ),

                                Spacer(),


                                Image.asset("assets/navigate_ic.png",width: 10.1,height:10.1),


                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                  )





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
                  child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
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


  prepareVideo() async {
    _controller=VideoPlayerController.networkUrl(
        Uri.parse("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"));
    await _controller!.initialize();

    print("Code moved");

    chewieController=ChewieController(
      videoPlayerController: _controller!,
      autoPlay: true,
      looping: false,
    );
    setState(() {

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prepareVideo();
  }
  @override
  void dispose() {

    _controller!.pause();
    _controller!.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
