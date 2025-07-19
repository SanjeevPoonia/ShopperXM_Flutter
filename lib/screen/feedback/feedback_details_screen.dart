import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;


class FeedbackDetailsScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<FeedbackDetailsScreen> {
  int selectedRadioIndex=9999;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body: Column(
          children: [


            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
              ),
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
                        child:Icon(Icons.keyboard_backspace_rounded)),


                    Text("Feedback",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),

                    Image.asset("assets/bell_ic.png",width: 23,height: 23)


                  ],
                ),
              ),
            ),


            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [

                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 6),
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
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Stack(
                            children: [
                              Container(
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFF7C00).withOpacity(0.30)
                                ),


                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 10),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Text(
                                          "Parameter",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          )),
                                    ),

                                    SizedBox(height: 5),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Text(
                                          "Cleanliness",
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          )),
                                    ),

                                  ],

                                ),




                              ),


                              Container(
                                height: 112,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Lottie.asset("assets/feedback_anim.json"),
                                ),
                              )
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                                "Sub-Parameter",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF00407E),
                                )),
                          ),

                          SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                                "Entrance Gate",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                )),
                          ),

                          SizedBox(height: 15),


                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                                "Sub-Parameter",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF00407E),
                                )),
                          ),

                          SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                                "Were COVID-19 guidelines followed? *",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                )),
                          ),


                          SizedBox(height: 16),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 53,
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                                color: Color(0xFFFF7C00).withOpacity(0.20),
                                borderRadius: BorderRadius.circular(4)
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  children: [

                                    Container(child:

                                    selectedRadioIndex==0?
                                    Icon(Icons.radio_button_on_sharp,color: AppTheme.orangeColor):




                                    GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectedRadioIndex=0;
                                          });
                                        },

                                        child: Icon(Icons.radio_button_off_outlined))),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                          "YES",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:  selectedRadioIndex==0?FontWeight.w700:FontWeight.w500,
                                            color:
                                            selectedRadioIndex==0?AppTheme.orangeColor:
                                            Color(0xFF708096),
                                          )),
                                    ),


                                  ],
                                ),


                                Row(
                                  children: [

                                    Container(child:

                                    selectedRadioIndex==1?
                                    Icon(Icons.radio_button_on_sharp,color: AppTheme.orangeColor):




                                    GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectedRadioIndex=1;
                                          });
                                        },

                                        child: Icon(Icons.radio_button_off_outlined))),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                          "NO",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:  selectedRadioIndex==1?FontWeight.w700:FontWeight.w500,
                                            color:
                                            selectedRadioIndex==1?AppTheme.orangeColor:
                                            Color(0xFF708096),
                                          )),
                                    ),


                                  ],
                                ),

                                Row(
                                  children: [

                                    Container(child:

                                    selectedRadioIndex==2?
                                    Icon(Icons.radio_button_on_sharp,color: AppTheme.orangeColor):




                                    GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectedRadioIndex=2;
                                          });
                                        },

                                        child: Icon(Icons.radio_button_off_outlined))),


                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                          "N/A",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:  selectedRadioIndex==2?FontWeight.w700:FontWeight.w500,
                                            color:
                                            selectedRadioIndex==2?AppTheme.orangeColor:
                                            Color(0xFF708096),
                                          )),
                                    ),


                                  ],
                                )





                              ],
                            ),


                          ),

                          SizedBox(height: 18),

                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                                "Artifact",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF00407E),
                                )),
                          ),

                          SizedBox(height: 10),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            child:  Image.asset("assets/ola_dummy.png"),
                          ),

                          SizedBox(height: 20),




                          Row(
                            children: [

                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Text(
                                          "Score/Scorable",
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 0.5,
                                            color: Color(0xFF00407E),
                                          )),
                                    ),

                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "5/5",
                                            hintStyle: TextStyle(
                                                fontSize: 14
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),





                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Text(
                                          "Score",
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 0.5,
                                            color: Color(0xFF00407E),
                                          )),
                                    ),

                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 14),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "5",
                                            hintStyle: TextStyle(
                                                fontSize: 14
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),





                          SizedBox(height: 22),


                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                                "Remark",
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 0.5,
                                  color: Color(0xFF00407E),
                                )),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: "Enter Remark",
                                  hintStyle: TextStyle(
                                      fontSize: 14
                                  )
                              ),
                            ),
                          ),


                          SizedBox(height: 22),


                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                                "Remark by QC",
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 0.5,
                                  color: Color(0xFF00407E),
                                )),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: "Lorem ipsum",
                                  hintStyle: TextStyle(
                                      fontSize: 14
                                  )
                              ),
                            ),
                          ),


                          SizedBox(height: 22),


                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                                "Feedback",
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 0.5,
                                  color: Color(0xFF00407E),
                                )),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            child: TextFormField(
                              maxLines: 2,
                              decoration: const InputDecoration(
                                  hintText: "Lorem ipsum",
                                  hintStyle: TextStyle(
                                      fontSize: 14
                                  )
                              ),
                            ),
                          ),



                          SizedBox(height: 18),
                        ],
                      )


                  ),
                  SizedBox(height: 20),

                  Card(
                    elevation: 4,
                    shadowColor:Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 47,
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
                          successBottomSheet(context);

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

                  SizedBox(height: 25)

                ],
              )
            ),













          ],
        )
      ),
    );
  }

  void successBottomSheet(BuildContext context) {
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

                    Text("Feedback sent\n successfully",
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


                SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: OverflowBox(
                    minHeight: 170,
                    maxHeight: 170,
                    child:  Lottie.asset("assets/check_animation.json"),
                  ),
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



              ],
            ),
          );
        }

        );

      },
    );
  }
}
