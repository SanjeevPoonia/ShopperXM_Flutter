import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopperxm_flutter/screen/profile_details/address_details_screen.dart';
import 'package:shopperxm_flutter/screen/profile_freefancer/freelancer_address_details.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_theme.dart';


class FreelancerBasicInfoScreen extends StatefulWidget {
  Map<String,dynamic> basicInfo={};
  String email = '';
  String mob = '';
  FreelancerBasicInfoScreen(this.basicInfo,this.email,this.mob);
  FreelancerBasicInfoState createState() => FreelancerBasicInfoState();
}

class FreelancerBasicInfoState extends State<FreelancerBasicInfoScreen> {
  var usernameController = TextEditingController();
  var userEmailController = TextEditingController();
  var userMobNoController = TextEditingController();
  bool scrollStart = false;
  int selectedRadio = 0;
  String? selectedDate;
  int selectedIndex=9999;
  String maritalStatus = '';
  String strGender = '';
  bool isLoading=false;

  ScrollController _scrollController = new ScrollController();
  List<String> genderList=[
    "Single",
    "Married",
    "Divorced",
    "Widowed",
  ];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "RobotoFlex",

      ),
      home:
      Scaffold(
        body:
        Stack(
          children: [

            Container(
              margin: EdgeInsets.only(top: 60),
              child:
              Expanded(
                child: Stack(
                  children: [
                    NotificationListener(
                        child: ListView(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      // Your Image
                                      Container(
                                        height: 175,
                                        color: Colors.white, // Adjust the opacity as needed
                                      ),
                                      Image.asset("assets/top_back.png"),
                                      Positioned(
                                        top: 90,
                                        // left: 20,// Adjust the position as needed
                                        child:  GestureDetector(
                                            onTap: () {
                                              print('Hello');
                                            },
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor: Colors.grey.shade200,
                                                    child: CircleAvatar(
                                                      radius: 40,
                                                      child: ClipOval(
                                                        child: Container(
                                                          height: 80.0,
                                                          width: 80.0,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.white,
                                                              width: 2.0,
                                                            ),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child:Image.network(widget.basicInfo["profile_pic"]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 1,
                                                    right: 1,
                                                    child: Container(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(0.0),
                                                        child: Image.asset("assets/camera.png",
                                                          width: 20,
                                                          height: 20,),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 0,
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                              50,
                                                            ),
                                                          ),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset: Offset(2, 4),
                                                              color: Colors.black.withOpacity(
                                                                0.3,
                                                              ),
                                                              blurRadius: 3,
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 25,right: 25),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 16),
                                        Container(
                                          child: TextFormField(
                                            controller: usernameController,
                                            // validator: checkEmptyString,
                                            keyboardType: TextInputType.name,
                                            decoration: const InputDecoration(
                                              hintText: "Enter Full Name",
                                              label: Text("Full Name",
                                                style: TextStyle(
                                                    color: Color(0xFF00376A)
                                                ),
                                              ),

                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Container(
                                          child: TextFormField(
                                            controller: userEmailController,
                                            // validator: checkEmptyString,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              hintText: "Email Address",
                                              label: Text("Email Address",
                                                style: TextStyle(
                                                    color: Color(0xFF00376A)
                                                ),
                                              ),

                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Container(
                                          child: TextFormField(
                                            controller: userMobNoController,
                                            // validator: checkEmptyString,
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              hintText: "Enter Mobile Number",
                                              label: Text("Mobile Number",
                                                style: TextStyle(
                                                    color: Color(0xFF00376A)
                                                ),
                                              ),

                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        InkWell(
                                          onTap: () {
                                            selectMaritalBottomSheet(context);
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Padding(padding: EdgeInsets.only(left: 0,right: 0,top: 6,bottom: 4),child:  Text('Marital Status',style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 16,
                                                      color:Color(0xFF00376A)
                                                  )),)
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(

                                                    child: Text(maritalStatus,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 15,
                                                            color: Color(0xFF000000)
                                                        )),
                                                  ),
                                                  Container(

                                                    child: Image.asset(
                                                      'assets/down_arrow.png', // Replace with your image URL
                                                      width: 12,
                                                      height: 12,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 12),
                                        Container(
                                          height: 1,
                                          color: Color(0xFF707070),
                                        ),
                                        SizedBox(height: 16),
                                        GestureDetector(
                                          onTap: () async {
                                            DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1950),
                                                //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime(2100));

                                            if (pickedDate != null) {
                                              String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                              selectedDate = formattedDate.toString();
                                              setState(() {});
                                            }
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Padding(padding: EdgeInsets.only(left: 0,right: 0,top: 6,bottom: 4),child:  Text('Date of Birth',style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 16,
                                                      color:Color(0xFF00376A)
                                                  )),)
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(

                                                    child: Text(selectedDate.toString(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 15,
                                                            color: Color(0xFF000000)
                                                        )),
                                                  ),
                                                  Container(

                                                    child: Image.asset(
                                                      'assets/calender.png', // Replace with your image URL
                                                      width: 12,
                                                      height: 12,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Container(
                                          height: 1,
                                          color: Color(0xFF707070),
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedRadio = 1;
                                                  strGender = "MALE";
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
                                            Text('Male',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF1D2226)
                                              ),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedRadio = 2;
                                                  strGender = "Female";
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
                                            Text('Female',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF1D2226)
                                              ),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedRadio = 3;
                                                  strGender = "Transgender";
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
                                                    border: selectedRadio == 3 ?Border.all(color: Color(0xFFFF8500)):Border.all(color: Colors.black),
                                                  ),
                                                  child: selectedRadio == 3
                                                      ? Image.asset("assets/radio_sel.png", width: 20,
                                                      height: 20)
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            Text('Transgender',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF1D2226)
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        InkWell(
                                          onTap: () {
                                            updateBasicInfoData(context);
                                          },
                                          child: Container(

                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF00376A),
                                                  borderRadius: BorderRadius.circular(5)),
                                              height: 45,
                                              child: const Center(
                                                child: Text('Update',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white)),
                                              )),
                                        ),
                                        SizedBox(height: 50),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
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
                      spreadRadius: 0,
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
                          child:Text("Basic Information",textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black))),

                      SizedBox(width: 10),
                    ],
                  ),
                )),


          ],
        ),
      ),
    );
  }
  void selectMaritalBottomSheet(BuildContext context) {
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

                    Text("Select Marital Status",
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
                    itemCount: genderList.length,
                    itemBuilder: (BuildContext context,int pos)
                    {
                      return InkWell(
                        onTap: (){
                          bottomSheetState(() {
                            selectedIndex=pos;
                            maritalStatus = genderList[pos];
                            Navigator.pop(context);
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
                                    child: Text(genderList[pos],
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

              ],
            ),
          );
        }

        );

      },
    );
  }
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.basicInfo["full_name"] ?? "NA");
    userEmailController = TextEditingController(text: widget.email ?? "NA");
    userMobNoController = TextEditingController(text: widget.mob ?? "NA");
    maritalStatus = widget.basicInfo["marital_status"] ?? "NA";
    selectedDate = widget.basicInfo["dob"] ?? "NA";
    if (widget.basicInfo["gender"] == "MALE"){
      selectedRadio = 1;
    }else if (widget.basicInfo["gender"] == "Female"){
      selectedRadio = 2;
    }else if (widget.basicInfo["gender"] == "Transgender"){
      selectedRadio = 3;
    }

    // strGender = selectedRadio == 1 ? "MALE": selectedRadio == 2 ? "Female" : selectedRadio == 3 ? "Transgender":"NA";
  }

  updateBasicInfoData(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Updating...');
    var data = {
      "full_name" : usernameController.text,
      "email" : userEmailController.text,
      "mobile_no" : userMobNoController.text,
      "marital_status" : maritalStatus,
      "dob" : selectedDate,
      "gender" : strGender

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('editBasicInfo', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    if(responseJSON["status"]==1)
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context,'Hello');

    }
    else
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    print(responseJSON);



  }

}
