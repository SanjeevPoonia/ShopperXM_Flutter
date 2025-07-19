import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/self_training/play_video_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:url_launcher/url_launcher.dart';

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../widgets/appbar_widget.dart';
import '../mcq_test/terms_screen.dart';


class StartTestScreen extends StatefulWidget {
  final String trainingID;
  StartTestScreen(this.trainingID);
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<StartTestScreen> {
  int selectedRadioIndex=9999;
  bool isLoading=false;
  Map<String,dynamic> trainingData={};
  List<dynamic> contentList=[];
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
                    child: Loader(),
                  ):


              ListView(
                padding: EdgeInsets.zero,
                children: [



                  SizedBox(height: 17),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      "Company Name",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          trainingData.isEmpty?"":
                          trainingData["company_name"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 10),


                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          trainingData.isEmpty?"":
                          trainingData["about_certification"],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),



                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MCQTermsScreen(widget.trainingID)));
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
                                'Start Test',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),

                              ),








                          /*    Text(
                                'Chapter 3 . PDF',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFB5B6B7),
                                ),

                              ),*/



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



                        ListView.builder(
                            itemCount: contentList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            itemBuilder: (BuildContext context,int pos)

                            {
                              return GestureDetector(
                                onTap: (){
                                  print(contentList[pos]["file_path"]);
                                  _launchBrowser(contentList[pos]["file_path"]);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [
                                        Image.asset("assets/pdf_ic.png",width: 28,height: 38),

                                        SizedBox(width: 5),

                                        Expanded(
                                          child: Text(contentList[pos]["file_path"].toString().split('/').last,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF00407E),
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





                                  ],
                                ),
                              );
                            }


                        ),



                        SizedBox(height: 5),
                        Divider(
                          color: Color(0xFF707070).withOpacity(0.20),
                        ),


                        SizedBox(height: 5),


                        Text(
                          'Content',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),

                        ),



                        SizedBox(height: 5),



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
                  padding:  EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Certification attempts(Maximum "+trainingData["user_certify_detail"]["max_attempt_allowed"].toString()+" attempts are allowed",
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
                 height: 250,
                 child: ListView.builder(
                      itemCount: contentList.length,
                     padding: EdgeInsets.symmetric(horizontal: 5),
                     itemBuilder: (BuildContext context,int pos)

                 {
                   return GestureDetector(
                     onTap: (){
                       print(contentList[pos]["file_path"]);
                       _launchBrowser(contentList[pos]["file_path"]);
                     },
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [

                         Row(
                           children: [
                             Icon(Icons.check_circle,color: Color(0xFfFF7C00),size: 16),

                             SizedBox(width: 5),

                             Text("Chapter "+(pos+1).toString(),
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
                               child: Text(contentList[pos]["description"],
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



                         Text(contentList[pos]["content_type"]==1?"PDF":"PDF",
                             style: TextStyle(
                               fontSize: 11,
                               fontWeight: FontWeight.w400,
                               color: Colors.black,
                             )),

                         SizedBox(height: 15)

                       ],
                     ),
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
    getTrainingDetails(context);
    getTrainingContent(context);
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
    var response = await helper.postAPIWithHeader('getTrainingDetail', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    trainingData=responseJSON["data"];
    setState(() {

    });



  }

  getTrainingContent(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
      "training_id":widget.trainingID

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getTrainingContent', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    contentList=responseJSON["data"]["content"];
    setState(() {

    });



  }


}
