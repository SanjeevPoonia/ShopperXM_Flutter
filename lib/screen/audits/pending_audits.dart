import 'dart:convert';
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
import 'package:shopperxm_flutter/screen/start_audit/audit_edit_form.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';
import '../start_audit/audit_form.dart';
import '../start_audit/fill_audit_screen.dart';


class PendingAuditsScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<PendingAuditsScreen> {
  int selectedRadioIndex=9999;
  int selectedIndex=9999;
  bool isLoading=false;
  List<dynamic> pendingAuditList=[];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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


                      Text("Pending Audits",
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
                child:
                isLoading?

                Center(
                  child: Loader(),
                ):

                pendingAuditList.length==0?


                Center(
                  child: Text("No Audits found!"),
                ):
                ListView.builder(
                    itemCount: pendingAuditList.length,
                    padding: const EdgeInsets.only(bottom: 70,top: 6,left: 12,right: 12),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context,int pos)
                    {
                      return Column(
                        children: [

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
                                Container(
                                  width: 184, height: 41,
                                  child: Stack(
                                    children: [
                                      Image.asset("assets/rect.png",
                                          width: 184, height: 41),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Image.asset("assets/loc_3.png",
                                                width: 16, height: 20),

                                            SizedBox(width: 14),

                                            Text(


                                                pendingAuditList[pos]["distance"]!=null?


                                                    getDistance(double.parse(pendingAuditList[pos]["distance"].toString()))+


                                                    " Km":"NA",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                )),

                                          ],
                                        ),
                                      )


                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 60,
                                        ),
                                        SizedBox(height: 15),


                                        Image.asset("assets/home_clock.png",
                                            width: 22.29, height: 27.85),

                                       // SizedBox(height: 15),
                                        Divider(),
                                        Image.asset("assets/loc_blue.png",
                                            width: 22.29, height: 27.85),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 30),

                                          SizedBox(

                                            child: Text(
                                                pendingAuditList[pos]["store_code"] ?? 'NA',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF494F66),
                                                ),maxLines: 1),
                                          ),
                                          Divider(),


                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text(
                                                pendingAuditList[pos]["store_name"]??"NA",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                )),
                                          ),
                                          Divider(),

                                          Text(
                                            pendingAuditList[pos]["store_address"]??"NA",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF494F66),
                                            ),maxLines: 2,
                                            overflow: TextOverflow.ellipsis,

                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/filter_ic.png",
                                          width: 16.53, height: 22.75),
                                      SizedBox(width: 27),
                                      Text(

                                          AppModel.userType=="2" && pendingAuditList[pos]["show_price"]==1?
                                          "₹"+pendingAuditList[pos]["price"].toString():

                                          "1 Hrs",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF494F66),
                                          )),
                                      Spacer(),
                                      Image.asset("assets/calender_ic.png",
                                          width: 15, height: 15),
                                      SizedBox(width: 27),
                                      Text(pendingAuditList[pos]["audit_date"],
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF494F66),
                                          )),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditEditFormScreen(pendingAuditList[pos]["beat_plan_id"].toString(),pendingAuditList[pos]["store_id"].toString())));

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 1),
                                    height:48,
                                    width: 155,
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

                                        Text("Continue",
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
              )













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
  void selectCategoryBottomSheet(BuildContext context) {
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


                  children: [
                    SizedBox(width: 10),

                    Text("Select Search Category",
                        style: TextStyle(
                          fontSize: 17,
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

                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (BuildContext context,int pos)
                    {
                      return InkWell(
                        onTap: (){
                          bottomSheetState(() {
                            selectedIndex=pos;
                          });
                        },
                        child: Container(
                          height: 57,
                          color: selectedIndex==pos?Color(0xFFFF7C00).withOpacity(0.10):Colors.white,
                          child: Row(
                            children: [

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text("Client Name",
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

                SizedBox(height: 15),


                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
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


                      },
                      child: const Text(
                        'Save',
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



  getPendingAuditList(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getIncompleteAuditList', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    pendingAuditList=responseJSON["data"];
    setState(() {

    });



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPendingAuditList(context);
  }
  String getDistance(double distance)
  {
    double distanceAsInt=distance/1000;
    int dis=distanceAsInt.toInt();
    return dis.toString();

  }
}
