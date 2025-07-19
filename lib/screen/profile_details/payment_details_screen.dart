import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shopperxm_flutter/screen/faq_term_and_condition/terms_screen.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:shopperxm_flutter/screen/remainder_screen.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';

class PaymentDetailsScreen extends StatefulWidget {
  Map<String,dynamic> paymentData;
  PaymentDetailsScreen(this.paymentData);
  PaymentDetailsState createState() => PaymentDetailsState();
}

class PaymentDetailsState extends State<PaymentDetailsScreen> {
  var userAccountNoController = TextEditingController();
  var userNameController = TextEditingController();
  bool panCardEabled = true;
  var userIfscController = TextEditingController();
  bool panVerified = false;
  var panCardCodeController = TextEditingController();
  XFile? chequeImage;
  XFile? PANImage;
  bool isChecked = false;
  bool scrollStart = false;
  ScrollController _scrollController = new ScrollController();
  int selectedRadio = 0;
  bool _isVisible = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void _toggleContainer() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Widget build(BuildContext context) {
    ToastContext().init(context);

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
                            child: Text("Payment Details",
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
                              SizedBox(height: 16),
                              Container(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color:
                                          Color(0xFF00376A).withOpacity(0.88),
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
                                padding: EdgeInsets.only(
                                    left: 4, right: 4, top: 6, bottom: 6),
                                // color: Color(0xFFF3F3F3),
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        controller: userAccountNoController,
                                        validator: checkAccountNo,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Account Number",
                                          label: Text(
                                            "Account Number",
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
                                        controller: userIfscController,
                                        validator: checkIFSCCode,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          hintText: "Enter IFSC Code",
                                          label: Text(
                                            "IFSC Code",
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
                                        controller: userNameController,
                                        validator: checkHolderName,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Account Holder Name",
                                          label: Text(
                                            "Account Holder Name",
                                            style: TextStyle(
                                                color: Color(0xFF00376A)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF707070))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text(
                                          'Upload Cheque Image',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF00376A)),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        chequeImage == null
                                            ? Expanded(
                                                child: _buildImageView(
                                                    'assets/demo_img.png'))
                                            : Expanded(
                                                child: _buildFileImageView(
                                                    chequeImage!.path
                                                        .toString()),
                                              ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _fetchChequeImage(context);
                                          },
                                          child: Container(
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFF8500),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              height: 35,
                                              child: const Center(
                                                child: Text('Upload',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white)),
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Container(
                                        child: Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: TextFormField(
                                            controller: panCardCodeController,
                                            enabled: panCardEabled,
                                            // validator: checkEmptyString,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Enter PAN Card Number",
                                                label: Text(
                                                  "PAN Card Number",
                                                  style: TextStyle(
                                                      color: Color(0xFF00376A)),
                                                ),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        panVerified
                                            ? Container()
                                            : Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (panCardCodeController
                                                            .text.length <
                                                        5) {
                                                      Toast.show(
                                                          "Please enter a valid PAN Number",
                                                          duration:
                                                              Toast.lengthLong,
                                                          gravity: Toast.bottom,
                                                          backgroundColor:
                                                              Colors.blue);
                                                    } else {
                                                      validatePAN(context);
                                                    }
                                                    //  _panCardPopup(context);
                                                  },
                                                  child: Text(
                                                    'Verify',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFFF47320),
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          Color(0xFFF47320),
                                                    ),
                                                  ),
                                                ),
                                              )
                                      ],
                                    )),
                                    Container(
                                      height: 1,
                                      color: Color(0xFF707070),
                                    ),
                                    panVerified
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: [
                                                Icon(Icons.check,
                                                    color: Colors.green,
                                                    size: 15),
                                                SizedBox(width: 5),
                                                Text("Verified",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text(
                                          'Upload PAN Card Image',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF00376A)),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PANImage == null
                                            ? Expanded(
                                                child: _buildImageView(
                                                    'assets/demo_img.png'))
                                            : Expanded(
                                                child: _buildFileImageView(
                                                    PANImage!.path.toString()),
                                              ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _fetchPANImage(context);
                                          },
                                          child: Container(
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFF8500),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              height: 35,
                                              child: const Center(
                                                child: Text('Upload',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white)),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              InkWell(
                                onTap: () {
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingScreen()));
                                  _submitHandler(context);
                                },
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00376A),
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 45,
                                    child: const Center(
                                      child: Text('SUBMIT',
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
      height: 140,
      color: Color(0xFFEFEFEF),
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        child: Center(
          child: Image.asset(
            imagePath,
            opacity: const AlwaysStoppedAnimation(.3),
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildFileImageView(String imagePath) {
    return Container(
      height: 140,
      color: Color(0xFFEFEFEF),
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        child: Center(
          child: Image.file(
            File(imagePath),
            // opacity: const AlwaysStoppedAnimation(.3),
            height: 100,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.paymentData.isNotEmpty)
      {

        userAccountNoController.text=widget.paymentData["account_no"].toString();
        userIfscController.text=widget.paymentData["ifsc_code"].toString();
        userNameController.text=widget.paymentData["bank_name"].toString();
        panCardCodeController.text=widget.paymentData["pan_card_no"].toString();
      }
  }

  void _panCardPopup(BuildContext context) {
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
                    'PAN Card Verified',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2226)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You have successfully verified PAN Card',
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

  String? checkAccountNo(String? value) {
    if (value!.toString().length < 5) {
      return 'Account number is required';
    }
    return null;
  }

  String? checkHolderName(String? value) {
    if (value!.toString().length < 2) {
      return 'Account holder name is required';
    }
    return null;
  }

  String? checkIFSCCode(String? value) {
    if (value!.toString().length < 5) {
      return 'Invalid IFSC Code';
    }
    return null;
  }

  uploadImage(String type, XFile? image) async {
    APIDialog.showAlertDialog(context, 'Updating image...');
    FormData formData = FormData.fromMap({
      "file_name": await MultipartFile.fromFile(image!.path),
      "user_id": AppModel.userID,
      "attachment_type": type,
      "Orignal_Name": image.path.split('/').last,
      "fileCount": "1",
    });
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "addAttachment");
    var response = await dio.post(AppConstant.appBaseURL + "addAttachment",
        data: formData);
    log(response.data);
    var responseJSON = jsonDecode(response.data.toString());
    Navigator.pop(context);
    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  validateValues() {
    if (!panVerified) {
      Toast.show("Please verify your PAN Number",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (chequeImage == null) {
      Toast.show("Please upload Cheque image",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (PANImage == null) {
      Toast.show("Please upload PAN Card image",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      submitPaymentInfo(context);
    }
  }

  submitPaymentInfo(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please wait...');
    var data = {
      "upi_id": "",
      "bhim_id": "",
      "bank_name": userNameController.text,
      "acc_no": userAccountNoController.text.toString(),
      "ifsc_code": userIfscController.text,
      "upi_priority": "P3",
      "bhim_priority": "P2",
      "acc_priority": "P1",
      "adhar_number": "",
      "pan_number": panCardCodeController.text,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('addPayment', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      if(widget.paymentData.isNotEmpty)
        {

          Navigator.pop(context,"refresh");
        }
      else
        {

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => TermsScreen()));
        }



    } else {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    validateValues();
  }

  validatePAN(BuildContext context) async {
    String authKey =
        "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYzNTMzMzk2NywianRpIjoiMTQzNmY1MjQtMWY3Zi00MjQ2LWIzODgtYzY5MmRkZWI4NGE2IiwidHlwZSI6ImFjY2VzcyIsImlkZW50aXR5IjoiZGV2LnFkZWdyZWVzQGFhZGhhYXJhcGkuaW8iLCJuYmYiOjE2MzUzMzM5NjcsImV4cCI6MTk1MDY5Mzk2NywidXNlcl9jbGFpbXMiOnsic2NvcGVzIjpbInJlYWQiXX19.MaT1P2eR31wpoXKBwjG8yJkSmDGHzxDFb0zRCDaj7qg";
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Validating PAN...');
    ApiBaseHelper helper = ApiBaseHelper();
    var data = {"id_number": panCardCodeController.text.toString()};
    var response = await helper.aadhaarOTPAPI(
        'https://kyc-api.aadhaarkyc.io/api/v1/pan/pan', data, context, authKey);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON["status_code"] == 200) {
      panVerified = true;
      panCardEabled = false;
      setState(() {});
      _panCardPopup(context);
    } else {
      panVerified = false;
      setState(() {});

      Toast.show("Invalid PAN Number",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _fetchChequeImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      chequeImage = image;
      setState(() {});

      uploadImage("1", chequeImage);
    }
  }

  _fetchPANImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      PANImage = image;
      setState(() {});
      uploadImage("7", PANImage);
    }
  }
}
