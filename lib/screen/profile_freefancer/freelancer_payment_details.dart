import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';


class FreelancerPaymentDetailsScreen extends StatefulWidget {
  FreelancerPaymentDetailsState createState() => FreelancerPaymentDetailsState();
}

class FreelancerPaymentDetailsState extends State<FreelancerPaymentDetailsScreen> {
  var userAccountNoController = TextEditingController();
  var userNameController = TextEditingController();
  var userIfscController = TextEditingController();
  var panCardCodeController = TextEditingController();
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
                          child:Text("Payment Details",textAlign: TextAlign.center,
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
                            margin: EdgeInsets.only(left: 20,right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Container(
                                    padding: EdgeInsets.only(left: 16,right: 16),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00376A).withOpacity(0.88),
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 45,
                                    child: Row(
                                      children: [
                                        Text('Bank Account Details',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                      ],

                                    )),
                                Container(
                                  padding: EdgeInsets.only(left: 4,right: 4,top: 6,bottom: 6),
                                  // color: Color(0xFFF3F3F3),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: TextFormField(
                                          controller: userAccountNoController,
                                          //validator: checkEmptyString,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Account Number",
                                            label: Text("Account Number",
                                              style: TextStyle(
                                                  color: Color(0xFF00376A)
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:Color(0xFF707070))),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          child: Row(
                                            children: [
                                              Expanded(flex:3,child: TextFormField(
                                                controller: userIfscController,
                                                // validator: checkEmptyString,
                                                keyboardType: TextInputType.phone,
                                                decoration: const InputDecoration(
                                                    hintText: "Enter IFSC Code",
                                                    label: Text("IFSC Code",
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
                                      Container(
                                        child: TextFormField(
                                          controller: userNameController,
                                          //validator: checkEmptyString,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Account Holder Name",
                                            label: Text("Account Holder Name",
                                              style: TextStyle(
                                                  color: Color(0xFF00376A)
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:Color(0xFF707070))),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Text('Upload Cheque Image',textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF00376A)
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(child: _buildImageView('assets/demo_img.png',),),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                          child: Row(
                                            children: [
                                              Expanded(flex:6,child: TextFormField(
                                                controller: panCardCodeController,
                                                // validator: checkEmptyString,
                                                keyboardType: TextInputType.text,
                                                decoration: const InputDecoration(
                                                    hintText: "Enter PAN Card Number",
                                                    label: Text("PAN Card Number",
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
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Text('Upload PAN Card Image',textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF00376A)
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(child: _buildImageView('assets/demo_img.png',),),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                InkWell(
                                  onTap: () {


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

      },
    );
  }
}
