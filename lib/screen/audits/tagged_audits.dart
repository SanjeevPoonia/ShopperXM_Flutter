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
import 'package:shopperxm_flutter/screen/audits/record_audio_screen.dart';
import 'package:shopperxm_flutter/screen/audits/record_video_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/audit_form.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';
import '../start_audit/audit_intro_screen.dart';


class TaggedAuditsScreen extends StatefulWidget {
  bool showBack;
  TaggedAuditsScreen(this.showBack);
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<TaggedAuditsScreen> {
  int selectedRadioIndex=9999;
  int selectedIndex=9999;
  bool isLoading=false;
  String Latitude_Str="75.8049537";
  String Longitude_Str="26.852436";
  List<dynamic> taggedList=[];
  List<dynamic> searchList=[];
  TextEditingController _searchController = TextEditingController();

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

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            widget.showBack?

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


                    Text("Tagged Audits",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),

                    Image.asset("assets/bell_ic.png",width: 23,height: 23)


                  ],
                ),
              ),
            ):Container(),


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
                  controller: _searchController,
                  onChanged: (value) {
                    _runFilter(value);
                  },
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
              isLoading?Center(child:Loader()):


              taggedList.length==0?


              Center(
                child: Text("No Audits found!"),
              ):



              searchList.length != 0 ||
                  _searchController.text.isNotEmpty?

              ListView.builder(
                  itemCount: searchList.length,
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

                                              getDistance(double.parse(searchList[pos]["distance"].toString()))+


                                                  " Km",
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

                              SizedBox(height: 5,),

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
                                    horizontal: 7, vertical: 5),
                                child: Row(
                                  children: [
                                    Image.asset("assets/filter_ic.png",
                                        width: 16.53, height: 22.75),
                                    SizedBox(width: 15),






                                    Text(AppModel.userType=="2" && searchList[pos]["show_price"]==1?
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
                                    SizedBox(width: 15),
                                    Text(searchList[pos]["audit_date"],
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF494F66),
                                        )),

                                    SizedBox(width: 15),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex:1,
                                    child: InkWell(
                                      onTap: (){

                                        if((searchList[pos]["tag_location"]==0 && searchList[pos]["selfie_required"]==0 && searchList[pos]["is_store_image"]==0) || searchList[pos]["is_tagged_all"]==2)
                                        {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditFormScreen(searchList[pos]["beat_plan_id"].toString(),searchList[pos]["store_id"].toString(),"tagged")));
                                        }
                                        else
                                        {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditIntroScreen(searchList[pos]["store_id"].toString(),searchList[pos]["store_name"])));
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 1),
                                        height:48,
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

                                            Text("Start Audit",
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
                                  ),

                                  SizedBox(width: 13),

                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: RecordVideoScreen(searchList[pos]['store_code']+"("+searchList[pos]["client_name"]+")" ?? '',searchList[pos]['store_name'] ?? '',searchList[pos]['store_address'] ?? '',searchList[pos]["store_id"].toString())));

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 1),
                                        height:48,
                                        //  padding: EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
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
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Image.asset("assets/video_ic.png",width: 27,height: 18.17),
                                            ),

                                            SizedBox(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: Text("Record Video",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.themeColor,
                                                  )),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),


                              SizedBox(height: 10),


                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: RecordAudioScreen(searchList[pos]['store_code']+"("+searchList[pos]["client_name"]+")" ?? '',searchList[pos]['store_name'] ?? '',searchList[pos]['store_address'] ?? '',searchList[pos]["store_id"].toString())));

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 1),
                                        height:48,
                                        //  padding: EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
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
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Icon(Icons.audiotrack,color: AppTheme.themeColor)
                                            ),

                                            SizedBox(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: Text("Record Audio",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.themeColor,
                                                  )),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 13),

                                  Expanded(
                                      flex: 1,
                                      child: Container()
                                  )
                                ],
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
                  itemCount: taggedList.length,
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

                                              getDistance(double.parse(taggedList[pos]["distance"].toString()))+


                                                  " Km",
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

                              SizedBox(height: 5,),

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
                                        taggedList[pos]["store_code"]+"("+taggedList[pos]["client_name"]+")",
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
                                        taggedList[pos]["store_name"]??"NA",
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
                                        taggedList[pos]["store_address"]??"NA",
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
                                    horizontal: 7, vertical: 5),
                                child: Row(
                                  children: [
                                    Image.asset("assets/filter_ic.png",
                                        width: 16.53, height: 22.75),
                                    SizedBox(width: 15),






                                    Text(AppModel.userType=="2" && taggedList[pos]["show_price"]==1?
                                    "₹"+taggedList[pos]["price"].toString():


                                    "1 Hrs",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF494F66),
                                        )),
                                    Spacer(),
                                    Image.asset("assets/calender_ic.png",
                                        width: 15, height: 15),
                                    SizedBox(width: 15),
                                    Text(taggedList[pos]["audit_date"],
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF494F66),
                                        )),

                                    SizedBox(width: 15),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex:1,
                                    child: InkWell(
                                      onTap: (){

                                        if((taggedList[pos]["tag_location"]==0 && taggedList[pos]["selfie_required"]==0 && taggedList[pos]["is_store_image"]==0) || taggedList[pos]["is_tagged_all"]==2)
                                        {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditFormScreen(taggedList[pos]["beat_plan_id"].toString(),taggedList[pos]["store_id"].toString(),"tagged")));
                                        }
                                        else
                                        {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditIntroScreen(taggedList[pos]["store_id"].toString(),taggedList[pos]["store_name"])));
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 1),
                                        height:48,
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

                                            Text("Start Audit",
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
                                  ),

                                  SizedBox(width: 13),

                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: RecordVideoScreen(taggedList[pos]['store_code']+"("+taggedList[pos]["client_name"]+")" ?? '',taggedList[pos]['store_name'] ?? '',taggedList[pos]['store_address'] ?? '',taggedList[pos]["store_id"].toString())));

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 1),
                                        height:48,
                                        //  padding: EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
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
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Image.asset("assets/video_ic.png",width: 27,height: 18.17),
                                            ),

                                            SizedBox(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: Text("Record Video",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.themeColor,
                                                  )),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),


                              SizedBox(height: 10),


                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: RecordAudioScreen(taggedList[pos]['store_code']+"("+taggedList[pos]["client_name"]+")" ?? '',taggedList[pos]['store_name'] ?? '',taggedList[pos]['store_address'] ?? '',taggedList[pos]["store_id"].toString())));

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 1),
                                        height:48,
                                        //  padding: EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
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
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Icon(Icons.audiotrack,color: AppTheme.themeColor)
                                            ),

                                            SizedBox(width: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: Text("Record Audio",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.themeColor,
                                                  )),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 13),

                                  Expanded(
                                    flex: 1,
                                    child: Container()
                                  )
                                ],
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


                       // Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: AuditFormScreen()));



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
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = taggedList;
    } else {

      if(selectedIndex==0)
      {
        results = taggedList
            .where((audit) => audit['client_name']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else if(selectedIndex==1)
      {
        results = taggedList
            .where((audit) => audit['store_name']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else if(selectedIndex==2)
      {
        results = taggedList
            .where((audit) => audit['audit_date']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else if(selectedIndex==3)
      {
        results = taggedList
            .where((audit) => audit['store_address']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else
      {
        results = taggedList
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

                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 45,
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

  getTaggedAuditList(BuildContext context) async {

    setState(() {
      isLoading=true;
    });
    var data = {
      "latitude":Latitude_Str,
      "longitude": Longitude_Str,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getTaggedAuditList', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON['data']);
    taggedList = responseJSON['data'];
    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaggedAuditList(context);
  }
  String getDistance(double distance)
  {
    double distanceAsInt=distance/1000;
    int dis=distanceAsInt.toInt();
    return dis.toString();

  }



}
