import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/app_theme.dart';
import '../feedback/feedback_details_screen.dart';

class FeedbackTab extends StatefulWidget {
  MenuState createState() => MenuState();
}

class MenuState extends State<FeedbackTab> {

  int selectedIndex=9999;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  ListView.builder(
          itemCount: 4,
          padding: EdgeInsets.only(bottom: 75,top: 6,left: 12,right: 12),
          shrinkWrap: true,
          itemBuilder: (BuildContext context,int pos)
          {
            return Column(
              children: [
                SizedBox(height: 27),
                Container(
                  //height: 274,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.symmetric(horizontal: 4),
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
                    children: [

                      SizedBox(height: 8),
                      Row(
                        children: [
                          Spacer(),
                          Image.asset("assets/calender_ic.png",
                              width: 15, height: 15),

                          SizedBox(width: 12),
                          Text("2023-02-23",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF494F66),
                              )),
                        ],
                      ),

                      SizedBox(height: 10),

                     Row(
                       children: [

                         Image.asset("assets/ola_ic.png",width: 35,height: 35,),
                         SizedBox(width: 15),

                         Expanded(
                           child: Text(
                               "VS_RAJ_0021 (Vodaphone idea Ltd.)",
                               style: TextStyle(
                                 fontSize: 13,
                                 fontWeight: FontWeight.w700,
                                 color: Colors.black,
                               )),
                         ),

                       ],
                     ),

                      SizedBox(height: 10),

//
                      Row(
                        children: [
                          SizedBox(width: 6),
                          Image.asset("assets/home_clock.png",
                              width: 22.29, height: 27.85),
                          SizedBox(width: 20),

                          Expanded(
                            child: Text(
                                "Vi Store Silver Jublee Road",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                )),
                          ),

                        ],
                      ),

                      SizedBox(height: 15),


                      Row(
                        children: [
                          SizedBox(width: 8),
                          Image.asset("assets/feedback_icon.png",
                              width: 18, height: 18),
                          SizedBox(width: 23),

                          Expanded(
                            child: Text(
                                "Lorem Ipsum",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                )),
                          ),

                        ],
                      ),

                      SizedBox(height: 15),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedbackDetailsScreen()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 1),
                          height:40,
                          width: 158,
                          //  padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF00407E),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color:
                                Colors.black12.withOpacity(0.3),
                                offset: const Offset(0.0, 5.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text("Feedback",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),


                              SizedBox(width: 20),

                              Image.asset("assets/assign2.png",width: 27,height: 27),


                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20)
                    ],
                  ),
                ),

                SizedBox(height: 15)


              ],
            );
          }


      ),
    );
  }
}
