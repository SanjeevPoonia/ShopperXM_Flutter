import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shopperxm_flutter/screen/profile_details/payment_details_screen.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';

class AddressDetailsScreen extends StatefulWidget {
  final String email;
  final Map<String,dynamic> profileData;

  AddressDetailsScreen(this.email,this.profileData);

  AddressDetailsState createState() => AddressDetailsState();
}

class AddressDetailsState extends State<AddressDetailsScreen> {
  var userAdd1Controller = TextEditingController();
  var userAdd3Controller = TextEditingController();
  var userAdd4Controller = TextEditingController();
  String cityName1 = "";
  String stateName1 = "";
  String countryName1 = "";
  String cityName2 = "";
  String stateName2 = "";
  String countryName2 = "";
  var userAdd2Controller = TextEditingController();
  var userAadharController = TextEditingController();
  var pinCodeController = TextEditingController();
  var pinCodeController2 = TextEditingController();
  bool isChecked = false;
  XFile? frontAadharImage;
  XFile? backAadharImage;
  final _formKey = GlobalKey<FormState>();
  bool scrollStart = false;
  ScrollController _scrollController = new ScrollController();
  int selectedRadio = 0;
  bool _isVisible = true;

  @override
  void _toggleContainer() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "RobotoFlex",
      ),
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            // padding: EdgeInsets.zero,
            children: [
              Container(
                  height: 110,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      // Set the radius for bottom-left corner
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset("assets/back_arrow.png",
                              width: 20, height: 20),
                        ),
                        Expanded(
                            child: Text("Address Details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.black))),
                        SizedBox(width: 10),
                      ],
                    ),
                  )),
              Expanded(
                child: Stack(
                  children: [
                    NotificationListener(
                        child: ListView(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                'Living Status',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF00376A),
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedRadio = 1;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: selectedRadio == 1
                                              ? Border.all(
                                                  color: Color(0xFFFF8500))
                                              : Border.all(color: Colors.black),
                                        ),
                                        child: selectedRadio == 1
                                            ? Image.asset(
                                                "assets/radio_sel.png",
                                                width: 20,
                                                height: 20)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Own House',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF1D2226)),
                                  ),
                                  SizedBox(width: 30),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedRadio = 2;
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: selectedRadio == 2
                                              ? Border.all(
                                                  color: Color(0xFFFF8500))
                                              : Border.all(color: Colors.black),
                                        ),
                                        child: selectedRadio == 2
                                            ? Image.asset(
                                                "assets/radio_sel.png",
                                                width: 20,
                                                height: 20)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Renter',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF1D2226)),
                                  )
                                ],
                              ),
                              Container(
                                  child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: userAadharController,
                                      validator: validateAadharCard,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Enter Aadhaar Number",
                                        suffix: InkWell(
                                          onTap: () {
                                            if (validateAadharCard(
                                                    userAadharController.text
                                                        .toString()) !=
                                                null) {
                                              validateAadhaar(context);
                                            }

                                            //_aadharPopup(context);
                                          },
                                          child: Text(
                                            'Verify',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFF47320),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  Color(0xFFF47320),
                                            ),
                                          ),
                                        ),
                                        label: Text(
                                          "Aadhaar Card Details",
                                          style: TextStyle(
                                              color: Color(0xFF00376A)),
                                        ),
                                        //border: InputBorder.none
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                              /*    Container(
                                    height: 1,
                                    color: Color(0xFF707070),
                                  ),*/
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  frontAadharImage != null
                                      ? Expanded(
                                          child: _buildFileImageView(
                                              frontAadharImage))
                                      : Expanded(
                                          child: _buildImageView(
                                            'assets/demo_img.png',
                                          ),
                                        ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  backAadharImage != null
                                      ? Expanded(
                                          child: _buildFileImageView(
                                              backAadharImage))
                                      : Expanded(
                                          child: _buildImageView(
                                              'assets/demo_img.png'),
                                        ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Front Side',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xFF00376A)),
                                  )),
                                  Expanded(
                                      child: Text(
                                    'Back Side',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xFF00376A)),
                                  )),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _fetchFrontImage(context);
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 30, right: 30),
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFF8500),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height: 30,
                                          child: const Center(
                                            child: Text('Upload',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white)),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        _fetchBackImage(context);
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 30, right: 30),
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFF8500),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height: 30,
                                          child: const Center(
                                            child: Text('Upload',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white)),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xFF00376A).withOpacity(0.88),
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 45,
                                    child: Row(
                                      children: [
                                        Text('Permanent Address',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                        Spacer(),
                                        Image.asset(
                                          'assets/down_arrow.png',
                                          // Replace with your image URL
                                          width: 12,
                                          height: 12,
                                          fit: BoxFit.cover,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 6, bottom: 16),
                                color: Color(0xFFF3F3F3),
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        controller: userAdd1Controller,
                                        validator: checkEmptyString,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Address Deatils",
                                          label: Text(
                                            "Address Line 1",
                                            style: TextStyle(
                                                color: Color(0xFF00376A)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF707070))),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        controller: userAdd2Controller,
                                        //validator: checkEmptyString,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Address Details",
                                          label: Text(
                                            "Address Line 2",
                                            style: TextStyle(
                                                color: Color(0xFF00376A)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF707070))),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        controller: pinCodeController,
                                        validator: checkPincode,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        onChanged: (value) {
                                          if (value.length == 6) {
                                            validatePinCode(
                                                context, value.toString(), 1);
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "Enter Pin Code",
                                          label: Text(
                                            "Pin Code",
                                            style: TextStyle(
                                                color: Color(0xFF00376A)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF707070))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        print('Hello');
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 6,
                                                    bottom: 4),
                                                child: Text('Country',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF00376A))),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Text(countryName1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15,
                                                        color: Colors.black)),
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
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        print('Hello');
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 6,
                                                    bottom: 4),
                                                child: Text('State',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF00376A))),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Text(stateName1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15,
                                                        color: Colors.black)),
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
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        print('Hello');
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 6,
                                                    bottom: 4),
                                                child: Text('City',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xFF00376A))),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Text(cityName1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15,
                                                        color: Colors.black)),
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
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              InkWell(
                                onTap: () {
                                  _toggleContainer();
                                },
                                child: Container(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color:
                                            Color(0xFF00376A).withOpacity(0.88),
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 45,
                                    child: Row(
                                      children: [
                                        Text('Current Address',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                        Spacer(),
                                        Image.asset(
                                          'assets/down_arrow.png',
                                          // Replace with your image URL
                                          width: 12,
                                          height: 12,
                                          fit: BoxFit.cover,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )),
                              ),
                              _isVisible
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 6,
                                          bottom: 16),
                                      color: Color(0xFFF3F3F3),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isChecked = !isChecked;
                                                  });

                                                  if (isChecked) {
                                                    userAdd3Controller.text =
                                                        userAdd1Controller.text;
                                                    userAdd4Controller.text =
                                                        userAdd2Controller.text;
                                                    pinCodeController2.text =
                                                        pinCodeController.text
                                                            .toString();
                                                    countryName2 = countryName1;
                                                    stateName2 = stateName1;
                                                    cityName2 = cityName1;

                                                    setState(() {});
                                                  } else {
                                                    userAdd3Controller.text =
                                                        "";
                                                    userAdd4Controller.text =
                                                        "";
                                                    pinCodeController2.text =
                                                        "";
                                                    countryName2 = "";
                                                    stateName2 = "";
                                                    cityName2 = "";

                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors
                                                          .black, // Change the border color as needed
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    // Adjust the border radius
                                                    color: isChecked
                                                        ? Color(0xFF00376A)
                                                        : Colors.transparent,
                                                  ),
                                                  child: isChecked
                                                      ? Icon(
                                                          Icons.check,
                                                          size: 18.0,
                                                          color: Colors
                                                              .white, // Change the check icon color
                                                        )
                                                      : null,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Same as Permanent Address',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(0xFF00376A)),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: TextFormField(
                                              controller: userAdd3Controller,
                                              validator: checkEmptyString,
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    "Enter Address Deatils",
                                                label: Text(
                                                  "Address Line 1",
                                                  style: TextStyle(
                                                      color: Color(0xFF00376A)),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF707070))),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: TextFormField(
                                              controller: userAdd4Controller,
                                              //validator: checkEmptyString,
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    "Enter Address Deatils",
                                                label: Text(
                                                  "Address Line 2",
                                                  style: TextStyle(
                                                      color: Color(0xFF00376A)),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF707070))),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: TextFormField(
                                              controller: pinCodeController2,
                                              validator: checkPincode,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 6,
                                              onChanged: (value) {
                                                if (value.length == 6) {
                                                  validatePinCode(context,
                                                      value.toString(), 2);
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "Enter Pin Code",
                                                label: Text(
                                                  "Pin Code",
                                                  style: TextStyle(
                                                      color: Color(0xFF00376A)),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFF707070))),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () {
                                              print('Hello');
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0,
                                                          right: 0,
                                                          top: 6,
                                                          bottom: 4),
                                                      child: Text('Country',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xFF00376A))),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(countryName2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black)),
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
                                          SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () {
                                              print('Hello');
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0,
                                                          right: 0,
                                                          top: 6,
                                                          bottom: 4),
                                                      child: Text('State',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xFF00376A))),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(stateName2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black)),
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
                                          SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () {
                                              print('Hello');
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0,
                                                          right: 0,
                                                          top: 6,
                                                          bottom: 4),
                                                      child: Text('City',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xFF00376A))),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(cityName2,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black)),
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
                                        ],
                                      ),
                                    ),
                              SizedBox(height: 30),
                              InkWell(
                                onTap: () {
                                  _submitHandler(context);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentDetailsScreen()));
                                },
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00376A),
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 45,
                                    child: const Center(
                                      child: Text('SAVE DETAILS',
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
      ),
    );
  }

  Widget _buildImageView(String imagePath) {
    return Container(
      height: 100,
      color: Color(0xFFEFEFEF),
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        child: Center(
          child: Image.asset(
            imagePath,
            opacity: const AlwaysStoppedAnimation(.3),
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildFileImageView(XFile? image) {
    return Container(
      height: 100,
      color: Color(0xFFEFEFEF),
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        child: Center(
          child: Image.file(
            File(image!.path),
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.profileData.isNotEmpty)
      {
        if(widget.profileData["living_status"]=="Own House")
          {
            selectedRadio=1;
          }
        else if(widget.profileData["living_status"]=="Renter")
          {
            selectedRadio=2;
          }
        userAadharController.text=widget.profileData["aadhaar_number"]??"";

        userAdd3Controller.text=widget.profileData["current_address_line_1"]??"";
        userAdd4Controller.text=widget.profileData["current_address_line_2"]??"";
        countryName2=widget.profileData["current_country"];
        stateName2=widget.profileData["current_state"];
        cityName2=widget.profileData["current_city"];
        pinCodeController2.text=widget.profileData["current_pincode"].toString();
        userAdd1Controller.text=widget.profileData["permanent_address_line_1"]??"";
        userAdd2Controller.text=widget.profileData["permanent_address_line_2"]??"";
        countryName1=widget.profileData["permanent_country"];
        stateName1=widget.profileData["permanent_state"];
        cityName1=widget.profileData["permanent_city"];
        pinCodeController.text=widget.profileData["permanent_pincode"].toString();


      }
  }





  void _aadharPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/close.png',
                                          // Replace with your image path
                                          width: 16, // Set the desired width
                                          height: 16, // Set the desired height
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Lottie.asset(
                            'assets/verified.json',
                            width: 160.0, // Adjust the image width as needed
                            height: 160.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Aadhaar Verified',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2226)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You have successfully verified Aadhaar',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2226).withOpacity(0.60)),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicInformationScreen()));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Color(
                          0xFF00376A), // Set the background color of the button
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'BACK',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _fetchFrontImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      frontAadharImage = image;
      setState(() {});
    }
  }

  validatePinCode(BuildContext context, String pinCode, addressCount) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Validating pincode...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get(
        'https://api.postalpincode.in/pincode/' + pinCode, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    List<dynamic> postOfficeList = [];

    postOfficeList = responseJSON;

    if (postOfficeList[0]["PostOffice"] == null) {
      Toast.show(postOfficeList[0]["PostOffice"]["Message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      if (addressCount == 1) {
        cityName1 = "";
        countryName1 = "";
        stateName1 = "";
      } else {
        cityName2 = "";
        countryName2 = "";
        stateName2 = "";
      }

      setState(() {});
    } else {
      if (addressCount == 1) {
        cityName1 = postOfficeList[0]["PostOffice"][0]["District"];
        countryName1 = postOfficeList[0]["PostOffice"][0]["Country"];
        stateName1 = postOfficeList[0]["PostOffice"][0]["State"];
      } else {
        cityName2 = postOfficeList[0]["PostOffice"][0]["District"];
        countryName2 = postOfficeList[0]["PostOffice"][0]["Country"];
        stateName2 = postOfficeList[0]["PostOffice"][0]["State"];
      }

      setState(() {});
    }
  }

  validateAadhaar(BuildContext context) async {
    String authKey =
        "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYzNTMzMzk2NywianRpIjoiMTQzNmY1MjQtMWY3Zi00MjQ2LWIzODgtYzY5MmRkZWI4NGE2IiwidHlwZSI6ImFjY2VzcyIsImlkZW50aXR5IjoiZGV2LnFkZWdyZWVzQGFhZGhhYXJhcGkuaW8iLCJuYmYiOjE2MzUzMzM5NjcsImV4cCI6MTk1MDY5Mzk2NywidXNlcl9jbGFpbXMiOnsic2NvcGVzIjpbInJlYWQiXX19.MaT1P2eR31wpoXKBwjG8yJkSmDGHzxDFb0zRCDaj7qg";
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Validating Aadhaar...');
    ApiBaseHelper helper = ApiBaseHelper();
    var data = {"id_number": userAadharController.text.toString()};
    var response = await helper.aadhaarOTPAPI(
        'https://kyc-api.surepass.io/api/v1/aadhaar-v2/generate-otp',
        data,
        context,
        authKey);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
  }

  String? validateAadharCard(String? value) {
    String pattern = r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty || value.length < 12) {
      return 'Please Enter Aadhar card Number';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    validateValues();
  }

  validateValues() {
    if (selectedRadio == 0) {
      Toast.show("Please select Living status",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (frontAadharImage == null) {
      Toast.show("Please upload Front image for IDProof",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (countryName1 == "" || countryName2 == "") {
      Toast.show("Country,state and city cannot be left as blank",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      submitAddressDetails();
    }
  }

  submitAddressDetails() async {
    APIDialog.showAlertDialog(context, 'Submitting Details...');
    FormData formData = FormData.fromMap({
      "living_status": selectedRadio == 1 ? "Own House" : "Renter",
      "c_address_line_1": userAdd3Controller.text,
      "c_address_line_2": userAdd4Controller.text,
      "c_country": countryName2,
      "c_state": stateName2,
      "c_city": cityName2,
      "c_pincode": pinCodeController2.text.toString(),
      "p_address_line_1": userAdd1Controller.text,
      "p_address_line_2": userAdd2Controller.text,
      "p_country": countryName1,
      "p_state": stateName1,
      "p_city": cityName1,
      "p_pincode": pinCodeController.text.toString(),
      "address_proof_type": "Aadhaar",
      "latitude": "75.7835492",
      "longitude": "26.9111319",
      "email": widget.email,
      "user_id": AppModel.userID,
      "Orignal_Name": frontAadharImage!.path.split('/').last,
      "fileCount": "1",
      "aadhaar_number": userAadharController.text.toString(),
      "file_name": await MultipartFile.fromFile(frontAadharImage!.path),
    });
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "addAddress");
    var response =
        await dio.post(AppConstant.appBaseURL + "addAddress", data: formData);
    log(response.data);
    var responseJSON = jsonDecode(response.data.toString());
    Navigator.pop(context);
    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);


      if(widget.profileData.isNotEmpty)
        {
          Navigator.pop(context,"refresh");
        }
      else
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => PaymentDetailsScreen({})));
        }


    } else {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be left as empty';
    }
    return null;
  }

  String? checkPincode(String? value) {
    if (value!.isEmpty) {
      return "Pin code is required";
    } else if (!RegExp(r'(^[1-9][0-9]{5}$)').hasMatch(value)) {
      return 'Invalid Pin code';
    }
    return null;
  }

  _fetchBackImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      backAadharImage = image;
      setState(() {});
    }
  }
}
