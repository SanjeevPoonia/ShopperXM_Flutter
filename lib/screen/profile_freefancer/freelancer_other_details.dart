import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopperxm_flutter/network/api_dialog.dart';
import 'package:toast/toast.dart';

import '../../network/api_helper.dart';
import '../../network/loader.dart';



class FreelancerOtherScreen extends StatefulWidget {
  FreelancerOtherState createState() => FreelancerOtherState();
}

class FreelancerOtherState extends State<FreelancerOtherScreen> {

  bool scrollStart = false;
  ScrollController _scrollController = ScrollController();
  int selectedRadio = 0;
  int selectedCamera = 0;
  bool isLoading=false;


  @override


  Widget build(BuildContext context) {
    ToastContext().init(context);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: "RobotoFlex",

      ),
      home: Scaffold(
        body:


        Column(
          // padding: EdgeInsets.zero,
          children: [
            Container(
                height: 110,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),  // Set the radius for bottom-left corner
                    bottomRight: Radius.circular(20.0),
                    // Set the radius for bottom-right corner
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

                child:   Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    children: [

                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/back_arrow.png", width: 20,
                            height: 20),
                      ),
                      Expanded(
                          child:Text("Other Details",textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black))),

                      SizedBox(width: 10),
                    ],
                  ),
                )),
            Expanded(
              child:

              isLoading?

              Center(
                child: Loader(),
              ):


              Stack(
                children: [
                  NotificationListener(
                      child: ListView(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20,right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.only(left: 4,right: 4,top: 6,bottom: 6),
                                  // color: Color(0xFFF3F3F3),
                                  child: Column(
                                    children: [
                                      Text('Do you have an Android or IOS mobile phone with good quality audio and video recording feature?',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF708096)
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Color(0xFF708096).withOpacity(0.10),
                                            padding: EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 0),
                                            child:  Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedRadio = 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      margin: EdgeInsets.only(right: 8),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: selectedRadio == 1 ?Border.all(color: Color(0xFFFF8500)):Border.all(color: Colors.black),
                                                      ),
                                                      child: selectedRadio == 1
                                                          ? Image.asset("assets/radio_sel.png", width: 20,
                                                          height: 20)
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text('Yes',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xFF1D2226)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(height: 12),
                                          Container(
                                            color: Color(0xFF708096).withOpacity(0.10),
                                            padding: EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedRadio = 2;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      margin: EdgeInsets.only(right: 8),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: selectedRadio == 2 ?Border.all(color: Color(0xFFFF8500)):Border.all(color: Colors.black),
                                                      ),
                                                      child: selectedRadio == 2
                                                          ? Image.asset("assets/radio_sel.png", width: 20,
                                                          height: 20)
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text('No',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xFF1D2226)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                      SizedBox(height: 25),
                                      Text('Camera Quality of your Android IOS Mobile Device?',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF708096)
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Color(0xFF708096).withOpacity(0.10),
                                            padding: EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 0),
                                            child:  Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedCamera = 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      margin: EdgeInsets.only(right: 8),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: selectedCamera == 1 ?Border.all(color: Color(0xFFFF8500)):Border.all(color: Colors.black),
                                                      ),
                                                      child: selectedCamera == 1
                                                          ? Image.asset("assets/radio_sel.png", width: 20,
                                                          height: 20)
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text('5 MP',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xFF1D2226)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            color: Color(0xFF708096).withOpacity(0.10),
                                            padding: EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedCamera = 2;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      margin: EdgeInsets.only(right: 8),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: selectedCamera == 2 ?Border.all(color: Color(0xFFFF8500)):Border.all(color: Colors.black),
                                                      ),
                                                      child: selectedCamera == 2
                                                          ? Image.asset("assets/radio_sel.png", width: 20,
                                                          height: 20)
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text('10 MP',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xFF1D2226)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            color: Color(0xFF708096).withOpacity(0.10),
                                            padding: EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedCamera = 3;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      margin: EdgeInsets.only(right: 8),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: selectedCamera == 3 ?Border.all(color: Color(0xFFFF8500)):Border.all(color: Colors.black),
                                                      ),
                                                      child: selectedCamera == 3
                                                          ? Image.asset("assets/radio_sel.png", width: 20,
                                                          height: 20)
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text('15 MP',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xFF1D2226)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            color: Color(0xFF708096).withOpacity(0.10),
                                            padding: EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedCamera = 4;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      margin: EdgeInsets.only(right: 8),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: selectedCamera == 4 ?Border.all(color: Color(0xFFFF8500)):Border.all(color: Colors.black),
                                                      ),
                                                      child: selectedCamera == 4
                                                          ? Image.asset("assets/radio_sel.png", width: 20,
                                                          height: 20)
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text('Not mentioned',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(0xFF1D2226)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 16),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                InkWell(
                                  onTap: () {

                                    validateValues();
                                  },
                                  child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF00376A),
                                          borderRadius: BorderRadius.circular(5)),
                                      height: 45,
                                      child: const Center(
                                        child: Text('Submit',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),
                                SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getProfileData(context);

  }



  getProfileData(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getUserAllInfo', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    int otherDetailsStatus=responseJSON["data"]["has_other_detail"];

    if(otherDetailsStatus==1)
    {

     Map<String,dynamic> infoData=responseJSON["data"]["other_detail"];

     if(infoData["have_phone"]=="No")
       {
         selectedRadio=2;
       }
     else if(infoData["have_phone"]=="Yes")
       {
         selectedRadio=1;
       }


     if(infoData["camera_quality"]=="5 MP")
     {
       selectedCamera=1;
     }
     else if(infoData["camera_quality"]=="10 MP")
     {
       selectedCamera=2;
     }

     else if(infoData["camera_quality"]=="15 MP")
     {
       selectedCamera=3;
     }










    }



    setState(() {

    });


  }




  validateValues() {
    if(selectedRadio==0)

      {
        Toast.show("Please answer Question 1",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    else if(selectedCamera==0)
      {
        Toast.show("Please answer Question 2",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    else
      {
        submitAnswersData(context);
      }


  }


  submitAnswersData(BuildContext context) async {

    APIDialog.showAlertDialog(context, "Please wait...");
    var data = {

      "have_phone":selectedRadio==1?"Yes":"No",
      "camera_quality":selectedCamera==1?"5 MP":selectedCamera==2?"10 MP":selectedCamera==3?"15 MP":""

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('addOtherDetail', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    Navigator.pop(context);

    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);


      Navigator.pop(context);



    } else {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }





      setState(() {

      });





    }




  }




