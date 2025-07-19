import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/audits/record_video_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/recording_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/upload_files_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:workmanager/workmanager.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';
import '../../widgets/textfield_profile_widget.dart';
import '../../widgets/textfield_widget.dart';
import '../audits/record_audio_screen.dart';

class FillAuditScreen extends StatefulWidget {
  final List<dynamic> questionList;
  final List<dynamic> parentList;
  final String storeID;
  final String cceName;
  final String customerCategoryName;
  final String scenarioID;
  final String auditMode;
  final String customerTypeID;
  final String contactNumber;
  final String beatPlanID;
  final int isVideoRequired;
  final int isImageRequired;
  final int isAudioRequired;
  final String auditType;
  FillAuditScreen(this.questionList,this.parentList,this.storeID,this.cceName,this.customerCategoryName,this.scenarioID,this.auditMode,this.customerTypeID,this.contactNumber,this.beatPlanID,this.isVideoRequired,this.isImageRequired,this.isAudioRequired,this.auditType);
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<FillAuditScreen> {

  TimeOfDay initialTime = TimeOfDay.now();
  List<dynamic> questionList =[];
  List<dynamic> artifactList=[];
  List<String> imagePathList = [];
  List<int> radioSelectionList = [];
  List<String> startTimeList = [];
  List<String> endTimeList = [];
  List<TextEditingController> remarkList = [];

  List<dynamic> parentList = [

  ];

  List<dynamic> currentQuestionList = [];
  int currentIndex = 0;
  int selectedRadioIndex = 9999;
  int selectedIndex = 9999;
  List<String> scenarioList = [
    "Vehicle Enquiry",
    "Ola EV Enquiry",
    "OLA Compliance Audit",
    "Service Informed Audit"
  ];

  List<String> audioModeList = [
    "Mystery Audit",
    "Compliance Audit",
    "Informed Audit",
  ];

  List<String> customerTypeList = [
    "Mystery",
    "Infra Audit",
    "Informed",
  ];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 135,
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 25),
                width: double.infinity,
                color: Color(0xFFFF7C00),
                child: Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Parameter " + (currentIndex + 1).toString(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                          Text("Total Sub-Parameter",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(parentList[currentIndex]["group_name"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppTheme.themeColor,
                            ),
                            child: Center(
                              child: Text(currentQuestionList.length.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Container(
                  height: 69,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.keyboard_backspace_rounded)),
                      Text("Audit",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      Image.asset("assets/bell_ic.png", width: 23, height: 23)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 15),
              /*  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Image.asset("assets/arrow_left.png",
                            width: 12, height: 12),
                        SizedBox(width: 7),
                        GestureDetector(
                          onTap: () {
                            if (currentIndex != 0) {
                              currentIndex = currentIndex - 1;
                              setState(() {});
                              updateValues();
                            }
                          },
                          child: Text("PREVIOUS",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: currentIndex == 0
                                    ? Color(0xFF708096)
                                    : AppTheme.themeColor,
                              )),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (currentIndex != parentList.length - 1) {
                              currentIndex = currentIndex + 1;
                              setState(() {});
                              updateValues();
                            }
                          },
                          child: Text("NEXT",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: currentIndex == parentList.length - 1
                                    ? Color(0xFF708096)
                                    : AppTheme.themeColor,
                              )),
                        ),
                        SizedBox(width: 7),
                        Image.asset("assets/arrow_right.png",
                            width: 12, height: 12),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 9),*/
                ListView.builder(
                    itemCount: currentQuestionList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int pos) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.3),
                                    offset: const Offset(0.0, 5.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 13),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14),
                                        child: Text("Sub-Parameter",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF00407E),
                                            )),
                                      ),
                                      Spacer(),
                                      InkWell(
                                          onTap: () {
                                            selectInfoBottomSheet(
                                                context,
                                                currentQuestionList[pos]
                                                    ["question"]);
                                          },
                                          child: Image.asset(
                                              "assets/info_ic.png",
                                              width: 22,
                                              height: 22)),
                                      SizedBox(width: 12),
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: AppTheme.themeColor,
                                        ),
                                        child: Center(
                                          child: Text((pos + 1).toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                      SizedBox(width: 14),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: Text(
                                        currentQuestionList[pos]["question"],
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                  ),
                                  SizedBox(height: 7),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 53,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xFFFF7C00).withOpacity(0.20),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                        itemCount: currentQuestionList[pos]["options"].length,
                                        itemBuilder: (BuildContext context,int pos22)
                                    {
                                      return  Row(

                                        children: [
                                          Container(
                                              child: radioSelectionList[pos] == currentQuestionList[pos]["options"][pos22]["option_id"]
                                                  ? Icon(
                                                  Icons
                                                      .radio_button_on_sharp,
                                                  color: AppTheme
                                                      .orangeColor)
                                                  : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      radioSelectionList[pos] =
                                                      currentQuestionList[pos]["options"][pos22]["option_id"];
                                                    });
                                                  },
                                                  child: Icon(Icons
                                                      .radio_button_off_outlined))),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12),
                                            child: Text(currentQuestionList[pos]["options"][pos22]["option"],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  radioSelectionList[pos] == currentQuestionList[pos]["options"][pos22]["option_id"]
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                  color: radioSelectionList[pos] == currentQuestionList[pos]["options"][pos22]["option_id"]
                                                      ? AppTheme.orangeColor
                                                      : Color(0xFF708096),
                                                )),
                                          ),

                                          SizedBox(width: 25)
                                        ],
                                      );
                                    }


                                    )
                                  ),
                                  SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: Text("Capture Selfie with Store",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF00407E),
                                        )),
                                  ),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      _showPictureDialog(pos);
                                    },
                                    child: Container(
                                      height: 100,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 14),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFEFEFEF),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: DottedBorder(
                                        color: Colors.black,
                                        radius: Radius.circular(5),
                                        strokeWidth: 1,
                                        child: Center(
                                          child:

                      imagePathList[pos]!=""?
                                          Image.file(
                                            File(imagePathList[pos]),

                                            height: 100,
                                            fit: BoxFit.fill,
                                          ):


                                          Image.asset(
                                            'assets/demo_img.png',
                                            opacity:
                                                const AlwaysStoppedAnimation(
                                                    .3),
                                            height: 100,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14),
                                              child: Text("Start Time",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    height: 0.5,
                                                    color: Color(0xFF00407E),
                                                  )),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 14),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 3),
                                                  child: Image.asset(
                                                      "assets/time_start.png",
                                                      width: 20,
                                                      height: 20),
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {

                                                      print("Click Triggered");
                                                      TimeOfDay? pickedTime = await showTimePicker(
                                                        context: context,
                                                        initialTime: initialTime,
                                                      );

                                                      if(pickedTime!=null)
                                                      {
                                                        log(pickedTime.toString());
                                                        startTimeList[pos]=pickedTime.hour.toString()+":"+pickedTime.minute.toString();
                                                        setState(() {

                                                        });
                                                      }


                                                    },
                                                    child: Container(

                                                        margin:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 14),
                                                        child: GestureDetector(

                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(height: 14),
                                                              Text(startTimeList[pos]==""?"Select Time":startTimeList[pos],
                                                                  style: TextStyle(
                                                                      fontSize:startTimeList[pos]==""? 12:14,
                                                                      fontWeight:
                                                                      startTimeList[pos]==""?FontWeight.w500:
                                                                          FontWeight
                                                                              .w600,
                                                                      color:
                                                                      startTimeList[pos]==""?Colors.grey.withOpacity(0.6):

                                                                      AppTheme
                                                                          .orangeColor)),
                                                              Divider(),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      /*  TextFormField(
                                      enabled: false,
                                      decoration:  InputDecoration(
                                          hintText: "",
                                          contentPadding: EdgeInsets.only(top: 15),
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.orangeColor
                                          )
                                      ),
                                    ),*/

                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14),
                                              child: Text("End Time",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    height: 0.5,
                                                    color: Color(0xFF00407E),
                                                  )),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 14),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 3),
                                                  child: Image.asset(
                                                      "assets/time_end.png",
                                                      width: 20,
                                                      height: 20),
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {

                                                      print("Click Triggered");
                                                      TimeOfDay? pickedTime = await showTimePicker(
                                                        context: context,
                                                        initialTime: initialTime,
                                                      );

                                                      if(pickedTime!=null)
                                                      {
                                                        log(pickedTime.toString());
                                                        endTimeList[pos]=pickedTime.hour.toString()+":"+pickedTime.minute.toString();
                                                        setState(() {

                                                        });
                                                      }


                                                    },
                                                    child: Container(

                                                        margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 14),
                                                        child: GestureDetector(

                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              SizedBox(height: 14),
                                                              Text(endTimeList[pos]==""?"Select Time":endTimeList[pos],
                                                                  style: TextStyle(
                                                                      fontSize:endTimeList[pos]==""? 12:14,
                                                                      fontWeight:
                                                                      endTimeList[pos]==""?FontWeight.w500:
                                                                      FontWeight
                                                                          .w600,
                                                                      color:
                                                                      endTimeList[pos]==""?Colors.grey.withOpacity(0.6):

                                                                      AppTheme
                                                                          .orangeColor)),
                                                              Divider(),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 13),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: Text("Remark",
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 0.5,
                                          color: Color(0xFF00407E),
                                        )),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    child: TextFormField(
                                      controller: remarkList[pos],
                                      decoration: const InputDecoration(
                                          hintText: "Enter Remark",
                                          hintStyle: TextStyle(fontSize: 14)),
                                    ),
                                  ),


                                  SizedBox(height: 17),

                                  Center(
                                    child: GestureDetector(
                                        onTap: (){




                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordAudioScreen2(widget.beatPlanID,widget.storeID)));
                                        },


                                        child: Image.asset("assets/voice.png",width: 55,height: 55)),
                                  ),


                                  SizedBox(height: 25),
                                ],
                              )),
                          SizedBox(height: 4)
                        ],
                      );
                    }),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                          child: Card(
                            elevation: 2,
                            shadowColor: Colors.grey,
                            //  margin: EdgeInsets.symmetric(horizontal: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
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
                                            Color(0xFF708096)), // fore
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Back to Details',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          flex: 1),
                      SizedBox(width: 10),
                      Expanded(
                          child: Card(
                            elevation: 4,
                            shadowColor: Colors.grey,
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
                                  validateValues();
                                 // uploadFilesBottomSheet(context);
                                },
                                child:  Text(

                                  currentIndex==parentList.length-1?

                                  'Submit':"Next",
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
                          flex: 1),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  void successBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child: Column(
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
                    Text("Feedback sent\n successfully",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",
                            width: 38, height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: OverflowBox(
                    minHeight: 170,
                    maxHeight: 170,
                    child: Lottie.asset("assets/check_animation.json"),
                  ),
                ),
                SizedBox(height: 25),
                Card(
                  elevation: 4,
                  shadowColor: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Next',
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
                Row(
                  children: [
                    Expanded(
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.grey,
                          //  margin: EdgeInsets.symmetric(horizontal: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
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
                                          Color(0xFF708096)), // fore
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ))),
                              onPressed: () {
                                // Navigator.pop(context);
                              },
                              child: const Text(
                                'Previous',
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
                        flex: 1),
                    SizedBox(width: 15),
                    Expanded(
                        child: Card(
                          elevation: 4,
                          shadowColor: Colors.grey,
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
                                validateValues();

                              },
                              child: const Text(
                                'Submit',
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
                        flex: 1),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

  _showPictureDialog(int pos) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, dialogState) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 80, height: 3, color: Color(0xFFAAAAAA)),
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.black),
                            child: Center(
                              child: Icon(Icons.close_sharp,
                                  color: Colors.white, size: 13.5),
                            ),
                          ),
                        ),
                        SizedBox(width: 15)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Select Picture',
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 15),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text('Camera',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.5)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ))),
                          onPressed: () {
                            Navigator.pop(context);
                            _fetchImageFromCamera(context, pos,currentQuestionList[pos]["question_id"].toString());
                          }),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 15),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: Text('Photos',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.5)),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppTheme.themeColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ))),
                          onPressed: () {
                            Navigator.pop(context);
                            _fetchImage(pos,currentQuestionList[pos]["question_id"].toString());
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, false ? -1 : 1), end: Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  void uploadFilesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child: Column(
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
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",
                            width: 38, height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    children: [
                      Text("Upload Video",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      Spacer(),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        child: Container(
                          height: 29,
                          //  width: 95,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white), // background
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFFFF8500)), // fore
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            onPressed: () {},
                            child: const Text(
                              'Browse',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  child: Divider(),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    children: [
                      Text("Upload Audio",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      Spacer(),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        child: Container(
                          height: 29,
                          //  width: 95,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white), // background
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFFFF8500)), // fore
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            onPressed: () {},
                            child: const Text(
                              'Browse',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  child: Divider(),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    children: [
                      Text("Upload Image",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      Spacer(),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        child: Container(
                          height: 29,
                          //  width: 95,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white), // background
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFFFF8500)), // fore
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            onPressed: () {},
                            child: const Text(
                              'Browse',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  child: Divider(),
                ),
                SizedBox(height: 15),
                Card(
                  elevation: 4,
                  shadowColor: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 47,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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
        });
      },
    );
  }

  void selectInfoBottomSheet(BuildContext context, String question) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child: Column(
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
                  children: [
                    SizedBox(width: 10),
                    Text("Info",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",
                            width: 38, height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Text(question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFf708096),
                      )),
                ),
                SizedBox(height: 18),
                Card(
                  elevation: 4,
                  shadowColor: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 47,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.auditType=="tagged")
    {
      fetchLocalData();
    }
    questionList=widget.questionList;
    parentList=widget.parentList;
    log("ID IS"+parentList.length.toString());
    updateValues();
  }

  updateValues() {
    currentQuestionList.clear();
    setState(() {});

    String parentGroupID = parentList[currentIndex]["group_id"].toString();

    print("Current group id " + parentGroupID);

    for (int i = 0; i < questionList.length; i++) {
      if (questionList[i]["parent_group_id"].toString() == parentGroupID) {
        currentQuestionList.add(questionList[i]);
      }
    }
    radioSelectionList.clear();
    imagePathList.clear();
    startTimeList.clear();
    endTimeList.clear();
    remarkList.clear();


    setState(() {});

    for (int i = 0; i < currentQuestionList.length; i++) {
      radioSelectionList.add(9999);
      imagePathList.add("");
      startTimeList.add("");
      endTimeList.add("");
      remarkList.add(TextEditingController());
    }

    setState(() {});
  }

  showTimeDialog(int type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            SizedBox(
              child: TimePickerDialog(
                initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                cancelText: "",
                confirmText: "",
              ),
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Perform an action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  validateValues(){
    bool radioData=true;
    bool remarkData=true;
    for(int i=0;i<radioSelectionList.length;i++)
      {
        if(radioSelectionList[i]==9999)
          {
            Toast.show("Please answer Question "+(i+1).toString(),
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
            radioData=false;
            break;
          }
      }

    if(radioData)
      {





        for(int i=0;i<remarkList.length;i++)
        {
          if(remarkList[i].text=="")
          {
            Toast.show("Please enter remark for Question "+(i+1).toString(),
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
            remarkData=false;
            break;
          }
        }



      }


    if(radioData && remarkData)
      {

        print("All validations Passed");
        // All validations passed
        submitAnswers(context);
      }








  }




  _fetchImage(int pos,questionID) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      imagePathList[pos] = image.path.toString();
      setState(() {});
      uploadImage(questionID, pos);
    }
  }






  uploadImage(String questionID,int pos) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Uploading image...');
    log("Function called");
    log(imagePathList[pos]);

    String storeImageAsBase64="";

    File file1 = File(imagePathList[pos]);

    List<int> imageBytes = file1.readAsBytesSync();

    storeImageAsBase64=base64Encode(imageBytes);
    log(storeImageAsBase64);
    FormData formData = FormData.fromMap({
      "user_id": AppModel.userID,
      "type": "0",
      "Orignal_Name": imagePathList[pos].split('/').last,
      "fileCount": "1",
      "store_id":widget.storeID,
      "ques_id":questionID,
      "img_from":"1",
      "base_img":storeImageAsBase64

    });
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "saveArtifact");
    var response = await dio.post(AppConstant.appBaseURL + "saveArtifact",
        data: formData);
    log(response.data);
    var responseJSON = jsonDecode(response.data.toString());
    Navigator.pop(context);
    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }



  submitAnswers(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Submitting answers...');
    List<dynamic> auditData=[];

    for(int i=0;i<currentQuestionList.length;i++)
      {
        auditData.add({
          "question_id": currentQuestionList[i]["question_id"].toString(),
          "answer_id":radioSelectionList[i].toString(),
          "remark": remarkList[i].text.toString(),
          "start_time": startTimeList[i].toString(),
          "end_time": endTimeList[i].toString(),
          "category_id": parentList[currentIndex]["group_id"].toString(),
          "beatplan_id": widget.beatPlanID,
          "user_id": AppModel.userID,
          "Filedata": imagePathList[i],
          "token":AppModel.token,
        });
      }


    Map<String,dynamic> dataObj={
      json.encode("audit_data"):json.encode(auditData)
    };

    log("Audit DAt   "+auditData.toString());

    var data = {
      "store_id":widget.storeID,
      "is_all_submit":currentIndex==currentQuestionList.length-1?"1":"0",
      "response":dataObj.toString(),
      "scenario_id":widget.scenarioID,
      "audit_id":"0",
      "audit_mode":widget.auditMode,
      "cce_name":widget.cceName,
      "contact_number":widget.contactNumber,
      "overall_observation":"",
      "red_alert":"",
      "customer_type":widget.customerTypeID,
      "customer_category":widget.customerCategoryName,

    };
    print("PAYLOAD");
    log(data.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeaderProd('saveAudit', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);


      if(currentIndex!=currentQuestionList.length-1)
        {
          currentIndex=currentIndex+1;
          setState(() {

          });
          updateValues();
        }

      else if(currentIndex==currentQuestionList.length-1)
        {


          APIDialog.showAlertDialog(context, "Fetching Files");


          for(int i=0;i<artifactList.length;i++)
            {

              if(i==0)
                {
                  Toast.show("Captured files are uploading in background...",
                      duration: Toast.lengthLong,
                      gravity: Toast.bottom,
                      backgroundColor: Colors.blue);


                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.setString("file_list", null!);

                }

              if(lookupMimeType(artifactList[i]["path"])
                  .toString()
                  .startsWith('video/'))
                {
                  uploadInBackground("2", artifactList[i]["path"]);
                }
              else{

                uploadInBackground("1", artifactList[i]["path"]);


              }


            }





          Navigator.pop(context);



          // Files Upload service


          if(widget.isAudioRequired==1 || widget.isImageRequired==1 || widget.isVideoRequired==1)
            {

              Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadFilesScreen(widget.isVideoRequired,widget.isImageRequired,widget.isAudioRequired,widget.storeID,widget.beatPlanID)));

            }





        }





    } else {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }

  uploadInBackground(String fileType,String filePath) async {
    await Workmanager().registerOneOffTask(
      "id1" + DateTime.now().millisecondsSinceEpoch.toString(),
      "uploadFileTask12" + DateTime.now().millisecondsSinceEpoch.toString(),
      inputData: <String, dynamic>{
        'filesPath': filePath,
        'beat_id': widget.beatPlanID,
        'store_id': widget.storeID,
        'user_id':AppModel.userID,
        'token':AppModel.token,
        'file_type':fileType
      },
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      existingWorkPolicy: ExistingWorkPolicy.append,
    );
  }
  fetchLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString("file_list");
    print("Data");
    print(data.toString());
    if(data!=null)
    {
      List<dynamic> list2 = jsonDecode(data);

      for(int i=0;i<list2.length;i++)
        {
          if(list2[i]["id"].toString()==widget.storeID)
            {
              artifactList.add(list2[i]);
            }
        }


      artifactList=list2;
      print(list2.toString());
    }

    setState(() {

    });
  }
  _fetchImageFromCamera(BuildContext context,int pos,String questionID) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      imagePathList[pos] = image.path.toString();
      setState(() {});

      uploadImage(questionID, pos);
    }
  }
}
