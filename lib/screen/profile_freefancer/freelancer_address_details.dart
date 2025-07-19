import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shopperxm_flutter/screen/profile_details/payment_details_screen.dart';


class FreelancerAddressScreen extends StatefulWidget {
  FreelancerAddressState createState() => FreelancerAddressState();
}

class FreelancerAddressState extends State<FreelancerAddressScreen> {
  var userAdd1Controller = TextEditingController();
  var userAdd2Controller = TextEditingController();
  var userAadharController = TextEditingController();
  var pinCodeController = TextEditingController();
  bool isChecked = false;
  bool scrollStart = false;
  ScrollController _scrollController = new ScrollController();
  int selectedRadio = 0;
  bool _isVisible = true;
  final ImagePicker _imagePicker = ImagePicker();

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
        body: Column(
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
                        child: Image.asset("assets/back_arrow.png", width: 20,
                            height: 20),
                      ),
                      Expanded(
                          child: Text(
                              "Address Details", textAlign: TextAlign.center,
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
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          margin: EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: selectedRadio == 1
                                                ? Border.all(
                                                color: Color(0xFFFF8500))
                                                : Border.all(
                                                color: Colors.black),
                                          ),
                                          child: selectedRadio == 1
                                              ? Image.asset(
                                              "assets/radio_sel.png", width: 20,
                                              height: 20)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Text('Own House',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF1D2226)
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedRadio = 2;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          margin: EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: selectedRadio == 2
                                                ? Border.all(
                                                color: Color(0xFFFF8500))
                                                : Border.all(
                                                color: Colors.black),
                                          ),
                                          child: selectedRadio == 2
                                              ? Image.asset(
                                              "assets/radio_sel.png", width: 20,
                                              height: 20)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Text('Rented',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF1D2226)
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                    child: Row(
                                      children: [
                                        Expanded(child: TextFormField(
                                          controller: userAadharController,
                                          // validator: checkEmptyString,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Aadhaar Deatils",
                                              label: Text(
                                                "Aadhaar Card Details",
                                                style: TextStyle(
                                                    color: Color(0xFF00376A)
                                                ),
                                              ),
                                              border: InputBorder.none

                                          ),
                                        ),),
                                      ],
                                    )
                                ),
                                Container(
                                  height: 1,
                                  color: Color(0xFF707070),
                                ),

                                SizedBox(height: 25),
                                InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 16, right: 16),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF00376A).withOpacity(
                                              0.88),
                                          borderRadius: BorderRadius.circular(
                                              5)),
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
                                          //validator: checkEmptyString,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Address Deatils",
                                            label: Text("Address Line 1",
                                              style: TextStyle(
                                                  color: Color(0xFF00376A)
                                              ),
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
                                            hintText: "Enter Address Deatils",
                                            label: Text("Address Line 2",
                                              style: TextStyle(
                                                  color: Color(0xFF00376A)
                                              ),
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
                                          //validator: checkEmptyString,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Pin Code",
                                            label: Text("Pin Code",
                                              style: TextStyle(
                                                  color: Color(0xFF00376A)
                                              ),
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
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xFF00376A)
                                                      )),)
                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(

                                                  child: Text('select',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xFFC2C2C2)
                                                      )),
                                                ),
                                                Container(

                                                  child: Image.asset(
                                                    'assets/down_arrow.png',
                                                    // Replace with your image URL
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
                                                  child: Text(
                                                      'State', style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .normal,
                                                      fontSize: 16,
                                                      color: Color(0xFF00376A)
                                                  )),)
                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(

                                                  child: Text('select',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xFFC2C2C2)
                                                      )),
                                                ),
                                                Container(

                                                  child: Image.asset(
                                                    'assets/down_arrow.png',
                                                    // Replace with your image URL
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
                                                  child: Text(
                                                      'City', style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .normal,
                                                      fontSize: 16,
                                                      color: Color(0xFF00376A)
                                                  )),)
                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(

                                                  child: Text('select',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xFFC2C2C2)
                                                      )),
                                                ),
                                                Container(

                                                  child: Image.asset(
                                                    'assets/down_arrow.png',
                                                    // Replace with your image URL
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
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                InkWell(
                                  onTap: () {
                                    _toggleContainer();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 16, right: 16),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF00376A).withOpacity(
                                              0.88),
                                          borderRadius: BorderRadius.circular(
                                              5)),
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
                                _isVisible ? Container() :
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, top: 6, bottom: 16),
                                  color: Color(0xFFF3F3F3),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isChecked = !isChecked;
                                              });
                                            },
                                            child: Container(
                                              width: 20.0,
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors
                                                      .black, // Change the border color as needed
                                                ),
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                                // Adjust the border radius
                                                color: isChecked ? Color(
                                                    0xFF00376A) : Colors
                                                    .transparent,
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
                                          Text('Same as Permanent Address',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xFF00376A)
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: TextFormField(
                                          controller: userAdd1Controller,
                                          //validator: checkEmptyString,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Address Deatils",
                                            label: Text("Address Line 1",
                                              style: TextStyle(
                                                  color: Color(0xFF00376A)
                                              ),
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
                                            hintText: "Enter Address Deatils",
                                            label: Text("Address Line 2",
                                              style: TextStyle(
                                                  color: Color(0xFF00376A)
                                              ),
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
                                          //validator: checkEmptyString,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Pin Code",
                                            label: Text("Pin Code",
                                              style: TextStyle(
                                                  color: Color(0xFF00376A)
                                              ),
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
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontSize: 16,
                                                          color: Color(
                                                              0xFF00376A)
                                                      )),)
                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(

                                                  child: Text('select',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xFFC2C2C2)
                                                      )),
                                                ),
                                                Container(

                                                  child: Image.asset(
                                                    'assets/down_arrow.png',
                                                    // Replace with your image URL
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
                                                  child: Text(
                                                      'State', style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .normal,
                                                      fontSize: 16,
                                                      color: Color(0xFF00376A)
                                                  )),)
                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(

                                                  child: Text('select',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xFFC2C2C2)
                                                      )),
                                                ),
                                                Container(

                                                  child: Image.asset(
                                                    'assets/down_arrow.png',
                                                    // Replace with your image URL
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
                                                  child: Text(
                                                      'City', style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .normal,
                                                      fontSize: 16,
                                                      color: Color(0xFF00376A)
                                                  )),)
                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Container(

                                                  child: Text('select',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xFFC2C2C2)
                                                      )),
                                                ),
                                                Container(

                                                  child: Image.asset(
                                                    'assets/down_arrow.png',
                                                    // Replace with your image URL
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
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: _buildImageView(
                                      'assets/demo_img.png',),),
                                  ],
                                ),
                                SizedBox(height: 30),
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentDetailsScreen()));
                                  },
                                  child: Container(

                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF00376A),
                                          borderRadius: BorderRadius.circular(
                                              5)),
                                      height: 45,
                                      child: const Center(
                                        child: Text('Update',
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

  Widget _buildImageView(String imagePath) {
    return Container(
        height: 180,
        color: Color(0xFFEFEFEF),

        child: Stack(
          children: [
            DottedBorder(
              color: Colors.black,
              strokeWidth: 1,
              child: Center(
                child: Image.asset(
                  imagePath,
                  opacity: const AlwaysStoppedAnimation(.3),
                  height: 175,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _openImagePicker(context);
                  });
                },
                child: Container(

                    width: 100,
                    decoration: BoxDecoration(
                        color: Color(0xFF494F66).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)),
                    height: 45,
                    child: const Center(
                      child: Text('Browse',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    )),
              ),
            ),

          ],
        )

    );
  }

  @override
  void initState() {
    super.initState();
  }


  Future<void> _openImagePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 29.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Take a picture'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? pickedFile = await _imagePicker.pickImage(
                        source: ImageSource.camera);
                    if (pickedFile != null) {
                      // Process the picked image, for example, display it or upload it to a server
                      print('Selected Image Path: ${pickedFile.path}');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Choose from gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? pickedFile = await _imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (pickedFile != null) {
                      // Process the picked image, for example, display it or upload it to a server
                      print('Selected Image Path: ${pickedFile.path}');
                    }
                  },
                ),
              ],
            ),
          ),
        );
        // return Container(
        //   child: Wrap(
        //     children: <Widget>[
        //       ListTile(
        //         leading: Icon(Icons.camera),
        //         title: Text('Take a picture'),
        //         onTap: () async {
        //           Navigator.pop(context);
        //           final XFile? pickedFile = await _imagePicker.pickImage(
        //               source: ImageSource.camera);
        //           if (pickedFile != null) {
        //             // Process the picked image, for example, display it or upload it to a server
        //             print('Selected Image Path: ${pickedFile.path}');
        //           }
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.photo),
        //         title: Text('Choose from gallery'),
        //         onTap: () async {
        //           Navigator.pop(context);
        //           final XFile? pickedFile = await _imagePicker.pickImage(
        //               source: ImageSource.gallery);
        //           if (pickedFile != null) {
        //             // Process the picked image, for example, display it or upload it to a server
        //             print('Selected Image Path: ${pickedFile.path}');
        //           }
        //         },
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }
}
