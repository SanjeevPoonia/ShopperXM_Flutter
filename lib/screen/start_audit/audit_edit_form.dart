import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/audits/record_video_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/fill_audit_edit_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/fill_audit_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../widgets/textfield_profile_widget.dart';
import '../../widgets/textfield_widget.dart';

class AuditEditFormScreen extends StatefulWidget {
  final String beatPlanID;
  final String storeID;

  AuditEditFormScreen(this.beatPlanID, this.storeID);

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<AuditEditFormScreen> {
  int selectedRadioIndex = 9999;
  int selectedIndex = 9999;
  bool isLoading = false;
  int isVideoRequired = 0;
  int isImageRequired = 0;
  int isAudioRequired = 0;
  var contactNameController = TextEditingController();
  var mobileController = TextEditingController();
  var auditTypeController = TextEditingController();
  var customerTypeController = TextEditingController();
  int selectedScenarioIndex = 9999;
  int selectedAuditTypeIndex = 9999;
  List<dynamic> questionList = [];
  List<dynamic> parentList = [];
  List<dynamic> scenarioDataList = [];
  List<dynamic> auditModeDataList = [];
  List<String> scenarioList = [];

  List<String> audioModeList = [];

  List<String> customerTypeList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
          body: Form(
        key: _formKey,
        child: Column(
          children: [
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
            Expanded(
              child: isLoading
                  ? Center(
                      child: Loader(),
                    )
                  : ListView(
                      children: [
                        SizedBox(height: 10),
                        TextFieldProfileWidget(
                            'Contact Name',
                            'Enter Contact name',
                            contactNameController,
                            nameValidator),
                        SizedBox(height: 17),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          child: Text("Senario",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.themeColor,
                              )),
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          height: 36,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      selectedScenarioIndex == 9999
                                          ? "Select Scenario"
                                          : scenarioList[selectedScenarioIndex],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      selectScenarioBottomSheet(context);
                                    },
                                    child: Text("Select",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.themeColor,
                                        )),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                child: Divider(
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 17),
                        PhoneTextFieldAuditWidget("Mobile", "Enter mobile",
                            mobileController, phoneValidator),
                        SizedBox(height: 17),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          child: Text("Audit Mode",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.themeColor,
                              )),
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          height: 36,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      selectedAuditTypeIndex == 9999
                                          ? "Select Audit Mode"
                                          : audioModeList[
                                              selectedAuditTypeIndex],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      selectAuditModeBottomSheet(context);
                                    },
                                    child: Text("Select",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.themeColor,
                                        )),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                child: Divider(
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 17),
                        TextFieldProfileWidget('Audit Type', 'Enter audit type',
                            auditTypeController, auditTypeValidator),
                        SizedBox(height: 17),

                        /*  Container(
                        margin: EdgeInsets.symmetric(horizontal: 13),
                        child: Text("Customer Type",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.themeColor,
                            )),
                      ),

                      SizedBox(height: 5),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 13),
                        height: 36,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Text(selectedCustomerTypeIndex == 9999
                                    ? "Select Customer Type"
                                    : customerTypeList[selectedCustomerTypeIndex],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),

                                Spacer(),

                                InkWell(
                                  onTap: () {
                                    selectCustomerBottomSheet(context);
                                  },
                                  child: Text("Select",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.themeColor,
                                      )),
                                ),


                              ],
                            ),

                            Spacer(),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              child: Divider(
                                color: Color(0xFF8C8C8C),
                              ),
                            ),


                          ],
                        ),
                      ),


                      SizedBox(height: 17),*/

                        TextFieldProfileWidget(
                            'Customer Category',
                            'Enter here',
                            customerTypeController,
                            customerTypeValidator),
                        SizedBox(height: 38),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              /*   Expanded(child: Card(
                          elevation: 2,
                          shadowColor:Colors.grey,
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
                        ),flex: 1),


                        SizedBox(width: 15),*/

                              Expanded(
                                  child: Card(
                                    elevation: 2,
                                    shadowColor: Colors.grey,
                                    // margin: EdgeInsets.symmetric(horizontal: 13),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      height: 48,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Colors.white), // background
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(AppTheme
                                                        .themeColor), // fore
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ))),
                                        onPressed: () {
                                          _submitHandler(context);
                                          /*   Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            FillAuditScreen()));*/
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
                                  flex: 1),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
            ),
          ],
        ),
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

  void selectScenarioBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    Text("Select Scenario",
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
                Container(
                  height: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: scenarioList.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return InkWell(
                          onTap: () {
                            bottomSheetState(() {
                              selectedScenarioIndex = pos;
                            });
                            setState(() {});
                          },
                          child: Container(
                            height: 57,
                            color: selectedScenarioIndex == pos
                                ? Color(0xFFFF7C00).withOpacity(0.10)
                                : Colors.white,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(scenarioList[pos],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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
                    height: 53,
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
                        if (selectedScenarioIndex != 9999) {
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      child: const Text(
                        'Apply',
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

  void selectAuditModeBottomSheet(BuildContext context) {
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
                    Text("Select Audit Mode",
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
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: audioModeList.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return InkWell(
                          onTap: () {
                            bottomSheetState(() {
                              selectedAuditTypeIndex = pos;
                            });
                            setState(() {});
                          },
                          child: Container(
                            height: 57,
                            color: selectedAuditTypeIndex == pos
                                ? Color(0xFFFF7C00).withOpacity(0.10)
                                : Colors.white,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(audioModeList[pos],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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
                    height: 53,
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
                        if (selectedAuditTypeIndex != 9999) {
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      child: const Text(
                        'Apply',
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

  /* void selectCustomerBottomSheet(BuildContext context) {
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

                    Text("Select Customer Type",
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
                        child: Image.asset(
                            "assets/cross_ic.png", width: 38, height: 38)),
                    SizedBox(width: 4),
                  ],
                ),

                Container(
                  height: 250,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: customerTypeList.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return InkWell(
                          onTap: () {
                            bottomSheetState(() {
                              selectedCustomerTypeIndex = pos;
                            });
                            setState(() {

                            });
                          },
                          child: Container(
                            height: 57,
                            color: selectedCustomerTypeIndex == pos ? Color(
                                0xFFFF7C00).withOpacity(0.10) : Colors.white,
                            child: Row(
                              children: [

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(customerTypeList[pos],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      }


                  ),
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
                    height: 53,
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
                        if (selectedCustomerTypeIndex != 9999) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Apply',
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
  }*/

  getQuestionList(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var data = {"store_id": widget.storeID};
    log(data.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeaderProd('getAuditData', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading = false;
    });

    scenarioDataList = responseJSON["data"]["scenario"];
    auditModeDataList = responseJSON["data"]["audit_mode_list"];
    // customerTypeDataList = responseJSON["data"]["customer_type_list"];

    for (int i = 0; i < scenarioDataList.length; i++) {
      scenarioList.add(scenarioDataList[i]["scenario_name"]);
    }

    for (int i = 0; i < auditModeDataList.length; i++) {
      audioModeList.add(auditModeDataList[i]["mode_name"]);
    }

    /* for (int i = 0; i < customerTypeDataList.length; i++) {
      customerTypeList.add(customerTypeDataList[i]["cust_type"]);
    }*/

    auditTypeController.text = responseJSON["data"]["audit_type"];

    questionList = responseJSON["data"]["questions"];
    parentList = responseJSON["data"]["parent_group"];

    isVideoRequired = responseJSON["data"]["allow_overall_video"];
    isImageRequired = responseJSON["data"]["is_multiple_image_required"];
    isAudioRequired = responseJSON["data"]["is_audio_required"];

    //SET DATA

    contactNameController.text = responseJSON["data"]["cce_name"];
    customerTypeController.text = responseJSON["data"]["cust_cat"];
    mobileController.text = responseJSON["data"]["contact_number"].toString();

    String scenarioID = responseJSON["data"]["scenario_id"].toString();

    for (int i = 0; i < scenarioDataList.length; i++) {
      if (scenarioID == scenarioDataList[i]["id"].toString()) {
        selectedScenarioIndex = i;
        break;
      }
    }

    String auditModeID = responseJSON["data"]["audit_mode"].toString();

    for (int i = 0; i < auditModeDataList.length; i++) {
      if (auditModeID == auditModeDataList[i]["id"].toString()) {
        selectedAuditTypeIndex = i;
        break;
      }
    }

    /*  String customerTypeID = responseJSON["data"]["cust_type"].toString();

    for(int i=0;i<customerTypeDataList.length;i++)
    {
      if(customerTypeID==customerTypeDataList[i]["id"].toString())
      {
        selectedCustomerTypeIndex=i;
        break;
      }
    }*/

    log("List IS " + parentList.length.toString());

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("INIT TRIGGRERD");
    getQuestionList(context);
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    validateValues();
  }

  validateValues() {
//Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressDetailsScreen()));

    if (selectedScenarioIndex == 9999) {
      Toast.show("Please select scenario",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedAuditTypeIndex == 9999) {
      Toast.show("Please select Audit Mode",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    /*  else if (selectedCustomerTypeIndex == 9999) {
      Toast.show("Please select Customer Type",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }*/

    else {
      // All Validations Passed

      String storeID = widget.storeID;
      String cceName = contactNameController.text;
      String contactNumber = mobileController.text.toString();
      String customerCategoryName = contactNameController.text;
      String scenarioID =
          scenarioDataList[selectedScenarioIndex]["id"].toString();
      String auditMode =
          auditModeDataList[selectedAuditTypeIndex]["id"].toString();
      //  String customerTypeID=customerTypeDataList[selectedCustomerTypeIndex]["id"].toString();

      log(scenarioID);
      // log(customerTypeID);

      log("LIST LENGTH " + parentList.length.toString());
      log("LIST LENGTH " + questionList.length.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FillAuditEditScreen(
                  questionList,
                  parentList,
                  storeID,
                  cceName,
                  customerCategoryName,
                  scenarioID,
                  auditMode,
                  "",
                  contactNumber.toString(),
                  widget.beatPlanID,
                  isVideoRequired,
                  isImageRequired,
                  isAudioRequired)));
    }
  }

  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Contact name is required';
    }
    return null;
  }

  String? auditTypeValidator(String? value) {
    if (value!.isEmpty) {
      return 'Audit type is required';
    }
    return null;
  }

  String? customerTypeValidator(String? value) {
    if (value!.isEmpty) {
      return 'Customer category is required';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (value!.toString().length != 10) {
      return 'Mobile number must be of 10 digits';
    }
    return null;
  }
}
