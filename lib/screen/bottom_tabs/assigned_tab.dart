import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopperxm_flutter/network/loader.dart';
import 'package:shopperxm_flutter/screen/start_audit/audit_form.dart';

import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';
import '../start_audit/audit_intro_screen.dart';
import '../start_audit/fill_audit_screen.dart';

class AssignedTab extends StatefulWidget {
  bool showBack;
  AssignedTab(this.showBack);
  MenuState createState() => MenuState();
}

class MenuState extends State<AssignedTab> {

  int selectedIndex=9999;
  bool isLoading=false;
  List<dynamic> assignedList=[];
  List<dynamic> searchList=[];

  var searchController=TextEditingController();

  List<String> categoryList=[
    "Client Name",
    "Name",
    "Audit Date",
    "Address",
    "Code",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:



      Container(
        child:

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            widget.showBack?

            Card(
              elevation: 4,
              margin: EdgeInsets.only(top: 27),
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


                    Text("Assigned Audits",
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




            SizedBox(height: 27),





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
                      Text(selectedIndex==9999?"Select category":categoryList[selectedIndex],
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
                  controller: searchController,
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

              isLoading?
              Center(
                child: Loader(),
              ):


              assignedList.length==0?


              Center(
                child: Text("No Audits found!"),
              ):



              searchList.length != 0 ||
                  searchController.text.isNotEmpty?

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
                              InkWell(
                                onTap: (){

                                  if((searchList[pos]["tag_location"]==0 && searchList[pos]["selfie_required"]==0 && searchList[pos]["is_store_image"]==0) || searchList[pos]["is_tagged_all"]==2)
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditFormScreen(searchList[pos]["beat_plan_id"].toString(),searchList[pos]["store_id"].toString(),"assigned")));
                                  }
                                  else
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditIntroScreen(searchList[pos]["store_id"].toString(),searchList[pos]["store_name"])));
                                  }
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
                  itemCount: assignedList.length,
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

                                              getDistance(double.parse(assignedList[pos]["distance"].toString()))+
                                            
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
                                       assignedList[pos]["store_code"]+"("+assignedList[pos]["client_name"]+")",
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
                                        assignedList[pos]["store_name"]??"NA",
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
                                        assignedList[pos]["store_address"]??"NA",
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






                                    Text(AppModel.userType=="2" && assignedList[pos]["show_price"]==1?
                                    "₹"+assignedList[pos]["price"].toString():


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
                                    Text(assignedList[pos]["audit_date"],
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
                              InkWell(
                                onTap: (){

                                  if((assignedList[pos]["tag_location"]==0 && assignedList[pos]["selfie_required"]==0 && assignedList[pos]["is_store_image"]==0) || assignedList[pos]["is_tagged_all"]==2)
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditFormScreen(assignedList[pos]["beat_plan_id"].toString(),assignedList[pos]["store_id"].toString(),"assigned")));
                                    }
                                  else
                                    {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AuditIntroScreen(assignedList[pos]["store_id"].toString(),assignedList[pos]["store_name"])));
                                    }
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
        ),
      ),

    );
  }

  void selectCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
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
                    },
                    child: Container(
                      height: 57,
                      color: selectedIndex==pos?Color(0xFFFF7C00).withOpacity(0.10):Colors.white,
                      child: Row(
                        children: [

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
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


  getAssignedAuditList(BuildContext context) async {
    String distance="300";
    setState(() {
      isLoading=true;
    });
    var data = {

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getMyAuditList', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    assignedList=responseJSON["data"];
    setState(() {

    });



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssignedAuditList(context);
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
      results = assignedList;
    } else {
     
      if(selectedIndex==0)
        {
          results = assignedList
              .where((audit) => audit['client_name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
              .toList();
        }
      
      else if(selectedIndex==1)
        {
          results = assignedList
              .where((audit) => audit['store_name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
              .toList();
        }

      else if(selectedIndex==2)
      {
        results = assignedList
            .where((audit) => audit['audit_date']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      else if(selectedIndex==3)
      {
        results = assignedList
            .where((audit) => audit['store_address']
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
            .toList();
      }
      
      else
        {
          results = assignedList
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
