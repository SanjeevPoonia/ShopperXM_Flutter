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
import 'package:shopperxm_flutter/screen/audits/transaction_claim_screen.dart';
import 'package:shopperxm_flutter/screen/faq_term_and_condition/guidelines_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/audit_form.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';


class CompletedAuditsScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<CompletedAuditsScreen> {
  TextEditingController _searchController = TextEditingController();
  int selectedRadioIndex=9999;
  int selectedIndex=9999;
  bool isLoading=false;
  List<dynamic> completedAuditList=[];
  List<dynamic> searchList=[];
  List<String> categoryList=[
    "Client Name",
    "Name",
    "Audit Date",
    "Address",
    "Code",
  ];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body:

        Column(
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


                    Text("Completed Audits",
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


            Container(
              margin: EdgeInsets.symmetric(horizontal: 13),
              child: Text("Select Search Category",
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
                      Text(selectedIndex == 0 ? "Client Name":selectedIndex == 1 ? "Name":selectedIndex == 2 ? "Audit Date":selectedIndex == 3 ? "Address":selectedIndex == 4 ? "Code":"Select Category",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),

                      Spacer(),

                      InkWell(
                        onTap: (){
                          selectCategoryBottomSheet(context);
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
            selectedIndex != 9999 ?

            Container(
              height: 45,
              //color: selectedIndex==pos?Color(0xFFFF7C00).withOpacity(0.10):Colors.white,
              child:Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: TextField(
                  onChanged: (value) {
                    _runFilter(value);
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ):Container(),
            SizedBox(height: 5),
            Expanded(


              child:
              isLoading?

              Center(
                child: Loader(),
              ):

              completedAuditList.length==0?


              Center(
                child: Text("No Audits found!"),
              ):



              searchList.length != 0 ||
                  _searchController.text.isNotEmpty?
              ListView.builder(
                  itemCount: searchList.length,
                  padding: EdgeInsets.only(bottom: 70,top: 6,left: 12,right: 12),
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
                                    searchList[pos]["status"]==1?

                                    Image.asset("assets/rect.png",
                                        width: 184, height: 41,
                                        color:
                                        Color(0xFFFF7C00)

                                    ):

                                    searchList[pos]["status"]==2?
                                    Image.asset("assets/rect.png",
                                        width: 184, height: 41,
                                        color:
                                        Color(0xFF2FAE67)):

                                    Image.asset("assets/rect.png",
                                        width: 184, height: 41,
                                        color:
                                        Color(0xFFE32C2C))

                                    ,

                                    Padding(
                                      padding: const EdgeInsets.only(top: 10,left: 6,right: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [


                                          Text(

                                              searchList[pos]["status"]==1?
                                              "Approval Pending":

                                              searchList[pos]["status"]==2?
                                              "Approved":

                                              "Rejected"

                                              ,
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
                                children: [

                                  // Image.asset("assets/ola_ic.png"),
                                  Container(
                                    width: 40,
                                    height: 40,
                                  ),



                                  Expanded(child:    Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                        searchList[pos]["store_code"]+"("+searchList[pos]["client_name"]+")",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF494F66),
                                        ),maxLines: 1),
                                  ),)


                                ],
                              ),


                              Container(
                                  margin: EdgeInsets.only(left: 40),
                                  child: Divider()),


                              Row(
                                children: [
                                  SizedBox(width: 5),

                                  // Image.asset("assets/ola_ic.png"),
                                  Image.asset("assets/home_clock.png",
                                      width: 22.29, height: 27.85),


                                  SizedBox(width:13),


                                  Expanded(child:        Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                        searchList[pos]["store_name"]??"NA",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                  ),)


                                ],
                              ),

                              Divider(),

                              Padding(
                                padding: const EdgeInsets.only(top: 4,bottom: 4),
                                child: Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Image.asset("assets/loc_blue.png",
                                        width: 22.29, height: 27.85),
                                    SizedBox(width:13),
                                    Expanded(child:            Text(
                                        searchList[pos]["store_address"]??"NA",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF494F66),
                                        )),)


                                  ],
                                ),
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

                                        AppModel.userType=="2" && searchList[pos]["show_price"]==1?
                                        "₹"+searchList[pos]["price"].toString():

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
                                    Text(searchList[pos]["audit_date"].toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF494F66),
                                        )),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10),




                           /*   searchList[pos]["status"]==222?
                              InkWell(
                                onTap: (){

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ClaimScreen(searchList[pos]["campaign_id"],searchList[pos]["store_id"])));

                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 1),
                                  height:48,
                                  width: 180,
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

                                      Text("Transaction Claim",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )),


                                      SizedBox(width: 10),

                                      Image.asset("assets/assign2.png",width: 27,height: 27),


                                    ],
                                  ),
                                ),
                              ):*/
                              searchList[pos]["status"]==2 || searchList[pos]["status"]==1 || searchList[pos]["status"]==4?

                              InkWell(
                                onTap: (){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: GuidelinesScreen(searchList[pos]["store_id"].toString(),searchList[pos]["beat_plan_id"].toString(),searchList[pos]["des_document"])));
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

                                      Text("Guidelines",
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
                              ):

                              InkWell(
                                onTap: (){
                                  //   locationBottomSheet(context);
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

                                      Text("Raise Invoice",
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

              ):

              ListView.builder(
                  itemCount: completedAuditList.length,
                  padding: EdgeInsets.only(bottom: 70,top: 6,left: 12,right: 12),
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
                                completedAuditList[pos]["status"]==1?

                                Image.asset("assets/rect.png",
                                    width: 184, height: 41,
                                    color:
                                    Color(0xFFFF7C00)

                    ):

                              completedAuditList[pos]["status"]==2?
                              Image.asset("assets/rect.png",
                              width: 184, height: 41,
                              color:
                              Color(0xFF2FAE67)):

                              Image.asset("assets/rect.png",
                                  width: 184, height: 41,
                                  color:
                                  Color(0xFFE32C2C))

                                    ,

                                    Padding(
                                      padding: const EdgeInsets.only(top: 10,left: 6,right: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [


                                          Text(

                                            completedAuditList[pos]["status"]==1?
                                              "Approval Pending":

                                            completedAuditList[pos]["status"]==2?
                                            "Approved":

                                              "Rejected"

                                              ,
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
                                children: [

                                  // Image.asset("assets/ola_ic.png"),
                                  Container(
                                    width: 40,
                                    height: 40,
                                  ),



                                  Expanded(child:    Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                        completedAuditList[pos]["store_code"]+"("+completedAuditList[pos]["client_name"]+")",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF494F66),
                                        ),maxLines: 1),
                                  ),)


                                ],
                              ),


                              Container(
                                  margin: EdgeInsets.only(left: 40),
                                  child: Divider()),


                              Row(
                                children: [
                                  SizedBox(width: 5),

                                  // Image.asset("assets/ola_ic.png"),
                                  Image.asset("assets/home_clock.png",
                                      width: 22.29, height: 27.85),


                                  SizedBox(width:13),


                                  Expanded(child:        Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                        completedAuditList[pos]["store_name"]??"NA",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                  ),)


                                ],
                              ),

                              Divider(),

                              Padding(
                                padding: const EdgeInsets.only(top: 4,bottom: 4),
                                child: Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Image.asset("assets/loc_blue.png",
                                        width: 22.29, height: 27.85),
                                    SizedBox(width:13),
                                    Expanded(child:            Text(
                                        completedAuditList[pos]["store_address"]??"NA",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF494F66),
                                        )),)


                                  ],
                                ),
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
                                        AppModel.userType=="2" && completedAuditList[pos]["show_price"]==1?
                                        "₹"+completedAuditList[pos]["price"].toString():


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
                                    Text(completedAuditList[pos]["audit_date"].toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF494F66),
                                        )),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10),





                              completedAuditList[pos]["status"]==2 || completedAuditList[pos]["status"]==1 || completedAuditList[pos]["status"]==4?
                              InkWell(
                                onTap: (){


                                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: GuidelinesScreen(completedAuditList[pos]["store_id"].toString(),completedAuditList[pos]["beat_plan_id"].toString(),completedAuditList[pos]["des_document"])));


                                  //   locationBottomSheet(context);
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

                                      Text("Guidelines",
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
                              ):

                              InkWell(
                                onTap: (){
                                  //   locationBottomSheet(context);
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

                                      Text("Raise Invoice",
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



  void locationBottomSheet(BuildContext context) {
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
                 //   SizedBox(width: 100),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12,left: 16),
                        child: Text("Please be in the 100 meter range to Continue",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),textAlign: TextAlign.center),
                      ),
                    ),



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
                    child:  Lottie.asset("assets/loc_anim.json"),
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


                      //  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: AuditFormScreen()));



                      },
                      child: const Text(
                        'Continue',
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
                    itemCount: categoryList.length,
                    itemBuilder: (BuildContext context,int pos)
                    {
                      return InkWell(
                        onTap: (){
                          bottomSheetState(() {
                            selectedIndex=pos;
                          });
                          setState(() {

                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 45,
                              color: selectedIndex==pos?Color(0xFFFF7C00).withOpacity(0.10):Colors.white,
                              child: Row(
                                children: [

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(categoryList[pos],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                        Navigator.pop(context);
                        setState(() {

                        });

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
      "myAudit":"myAudit",
      "user_id":AppModel.userID

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getCompletedAuditList', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    completedAuditList=responseJSON["data"];
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


  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = completedAuditList;
    } else {

      if(selectedIndex==0)
      {
        results = completedAuditList
            .where((audit) => audit['client_name']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else if(selectedIndex==1)
      {
        results = completedAuditList
            .where((audit) => audit['store_name']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else if(selectedIndex==2)
      {
        results = completedAuditList
            .where((audit) => audit['audit_date']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else if(selectedIndex==3)
      {
        results = completedAuditList
            .where((audit) => audit['store_address']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else
      {
        results = completedAuditList
            .where((audit) => audit['store_code']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }



      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchList = results;
    });
  }
}
