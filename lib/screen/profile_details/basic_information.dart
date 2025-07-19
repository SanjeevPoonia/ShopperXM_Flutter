import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shopperxm_flutter/screen/profile_details/address_details_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';

class BasicInformationScreen extends StatefulWidget {
  final Map<String,dynamic> profileData;
  final String email;
  final String mobile;

  BasicInformationScreen(this.profileData,this.email, this.mobile);

  BasicInformationScreenState createState() => BasicInformationScreenState();
}

class BasicInformationScreenState extends State<BasicInformationScreen> {
  var usernameController = TextEditingController();
  var ageController = TextEditingController();
  XFile? supportImage;
  var userEmailController = TextEditingController();
  var userMobNoController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  bool scrollStart = false;
  String? selectedDate;
  int selectedRadioIndex = 9999;
  int selectedIndex = 9999;
  ScrollController _scrollController = new ScrollController();
  List<String> audioModeList = ["Single", "Married", "Divorced", "Widowed"];
  final _formKey = GlobalKey<FormState>();

  @override
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
                            child: Text("Basic Information",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
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
                          margin: EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    print('Hello');
                                  },
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.grey.shade200,
                                          child: supportImage != null
                                              ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: FileImage(
                                                      File(supportImage!.path)),
                                                )
                                              : CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage: AssetImage(
                                                      'assets/profile.png'),
                                                ),
                                        ),
                                        Positioned(
                                          bottom: 1,
                                          right: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              _fetchImage(context);
                                            },
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Image.asset(
                                                  "assets/camera.png",
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 0,
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      50,
                                                    ),
                                                  ),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(2, 4),
                                                      color: Colors.black
                                                          .withOpacity(
                                                        0.3,
                                                      ),
                                                      blurRadius: 3,
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 20),
                              Text(
                                'Click the above image for browse the profile picture',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1D2226).withOpacity(0.60),
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: TextFormField(
                                  controller: userEmailController,
                                  enabled: false,
                                  style: TextStyle(color: Colors.black),
                                  // validator: checkEmptyString,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Email Address",
                                    label: Text(
                                      "Email Address",
                                      style:
                                          TextStyle(color: Color(0xFF00376A)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    'Mobile Number',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Color(0xFF00376A)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // Country Flag Icon
                                  GestureDetector(
                                    onTap: () {
                                      print('Hello');
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(0.0),
                                          child: Image.asset(
                                            'assets/india.png',
                                            // Replace with your flag icon
                                            width: 20.0,
                                            height: 20.0,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2.0),
                                          child:
                                              Icon(Icons.keyboard_arrow_down),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: TextFormField(
                                      controller: userMobNoController,
                                      enabled: false,
                                      style: TextStyle(color: Colors.black),
                                      //validator: checkEmptyString,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        hintText: "Enter mobile number",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: Color(0xFF707070),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                child: TextFormField(
                                  controller: usernameController,
                                  validator: nameValidator,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Full Name",
                                    label: Text(
                                      "Full Name",
                                      style:
                                          TextStyle(color: Color(0xFF00376A)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  selectMaritalStatus(context);
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
                                          child: Text('Marital Status',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Color(0xFF00376A))),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                              selectedIndex == 9999
                                                  ? 'select'
                                                  : audioModeList[
                                                      selectedIndex],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15,
                                                  color: selectedIndex == 9999
                                                      ? Color(0xFFC2C2C2)
                                                      : Colors.black)),
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
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 6,
                                              bottom: 4),
                                          child: Text('Date of Birth',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Color(0xFF00376A))),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                              selectedDate == null
                                                  ? 'DD-MM-YYYY'
                                                  : selectedDate.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15,
                                                  color: selectedDate == null
                                                      ? Color(0xFFC2C2C2)
                                                      : Colors.black)),
                                        ),
                                        Container(
                                          child: Image.asset(
                                            'assets/calender.png',
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
                              SizedBox(height: 5),
                              Container(
                                child: TextFormField(
                                  controller: ageController,
                                  validator: ageValidator,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Age",
                                    label: Text(
                                      "Age",
                                      style:
                                          TextStyle(color: Color(0xFF00376A)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 18),
                              Row(
                                children: [
                                  Text('Gender',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: AppTheme.themeColor)),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedRadioIndex = 1;
                                            });
                                          },
                                          child: selectedRadioIndex == 1
                                              ? Icon(Icons.radio_button_checked,
                                                  color: AppTheme.themeColor,
                                                  size: 18)
                                              : Icon(Icons.radio_button_off,
                                                  color: Color(0xFFC6C6C6),
                                                  size: 18)),
                                      SizedBox(width: 5),
                                      Image.asset("assets/male_ic.png",
                                          width: 12, height: 19),
                                      SizedBox(width: 7),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text('Male',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedRadioIndex = 2;
                                            });
                                          },
                                          child: selectedRadioIndex == 2
                                              ? Icon(Icons.radio_button_checked,
                                                  color: AppTheme.themeColor,
                                                  size: 18)
                                              : Icon(Icons.radio_button_off,
                                                  color: Color(0xFFC6C6C6),
                                                  size: 18)),
                                      SizedBox(width: 5),
                                      Image.asset("assets/female_ic.png",
                                          width: 12, height: 19),
                                      SizedBox(width: 7),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text('Female',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedRadioIndex = 3;
                                            });
                                          },
                                          child: selectedRadioIndex == 3
                                              ? Icon(Icons.radio_button_checked,
                                                  color: AppTheme.themeColor,
                                                  size: 18)
                                              : Icon(Icons.radio_button_off,
                                                  color: Color(0xFFC6C6C6),
                                                  size: 18)),
                                      SizedBox(width: 5),
                                      Image.asset("assets/trans_ic.png",
                                          width: 15, height: 20),
                                      SizedBox(width: 7),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text('Transgender',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 30),


                              widget.profileData.isNotEmpty?


                              InkWell(
                                onTap: () {
                                  _submitHandler(context);
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
                              ):


                              InkWell(
                                onTap: () {
                                  _submitHandler(context);
                                },
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF00376A),
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 45,
                                    child: const Center(
                                      child: Text('NEXT',
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

  uploadImage() async {
    APIDialog.showAlertDialog(context, 'Updating image...');
    FormData formData = FormData.fromMap({
      "file_name": await MultipartFile.fromFile(supportImage!.path),
      "user_id": AppModel.userID,
      "attachment_type": "5",
      "Orignal_Name": supportImage!.path.split('/').last,
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

  _fetchImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      supportImage = image;

      setState(() {});

      uploadImage();
    }
  }

  void selectMaritalStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, bottomSheetState) {
          return Container(
            padding: EdgeInsets.all(10),
            // height: 600,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child: Column(
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
                    Text("Marital Status",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",
                            width: 38, height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: audioModeList.length,
                    itemBuilder: (BuildContext context, int pos) {
                      return InkWell(
                        onTap: () {
                          bottomSheetState(() {
                            selectedIndex = pos;
                          });
                        },
                        child: Container(
                          height: 57,
                          color: selectedIndex == pos
                              ? Color(0xFFFF7C00).withOpacity(0.10)
                              : Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(audioModeList[pos],
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
                    }),
                SizedBox(height: 15),
                Card(
                  elevation: 4,
                  shadowColor: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 53,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // background
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.themeColor), // fore
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ))),
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Apply',
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
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userEmailController.text = widget.email;
    userMobNoController.text = widget.mobile;
    if(widget.profileData.isNotEmpty)
      {
        usernameController.text=widget.profileData["full_name"];
        String maritalStatus=widget.profileData["marital_status"];
        if(maritalStatus=="Single")
          {
            selectedIndex=0;
          }

        else if(maritalStatus=="Married")
        {
          selectedIndex=1;
        }

        else if(maritalStatus=="Divorced")
        {
          selectedIndex=2;
        }

        else if(maritalStatus=="Widowed")
        {
          selectedIndex=3;
        }

        if(widget.profileData["dob"]!=null)
          {
            selectedDate=widget.profileData["dob"].toString();
          }


        ageController.text=widget.profileData["age"]??"";

       if(widget.profileData["gender"]!=null)
         {
           if(widget.profileData["gender"]=="Male")
           {
             selectedRadioIndex=0;
           }
           else if(widget.profileData["gender"]=="Female")
           {
             selectedRadioIndex=1;
           }
           else if(widget.profileData["gender"]=="Transgender")
           {
             selectedRadioIndex=2;
           }
         }
       setState(() {

       });

      }



  }

  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? ageValidator(String? value) {
    if (value!.isEmpty) {
      return 'Age is required';
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
//Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressDetailsScreen()));

    if (selectedIndex == 9999) {
      Toast.show("Please select Marital status",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedDate == null) {
      Toast.show("Please select date of birth",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else if (selectedRadioIndex == 9999) {
      Toast.show("Please select a Gender",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      // All Validations Passed
      // Call API


      if(widget.profileData.isNotEmpty)
        {
          updateBasicInfo(context);
        }
      else
        {
          submitBasicInfo(context);
        }




    }
  }

  submitBasicInfo(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please wait...');
    var data = {
      "full_name": usernameController.text,
      "marital_status": audioModeList[selectedIndex],
      "dob": selectedDate.toString(),
      "age": ageController.text.toString(),
      "gender": selectedRadioIndex == 1
          ? "MALE"
          : selectedRadioIndex == 2
              ? "FEMALE"
              : "TRANSGENDER",
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPIWithHeader('addBasicInfo', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              AddressDetailsScreen(responseJSON["data"]["email"],{})));
    } else {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  updateBasicInfo(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please wait...');
    var data = {
      "full_name": usernameController.text,
      "marital_status": audioModeList[selectedIndex],
      "email" : userEmailController.text,
      "mobile_no" : userMobNoController.text,
      "dob": selectedDate.toString(),
      "age": ageController.text.toString(),
      "gender": selectedRadioIndex == 1
          ? "MALE"
          : selectedRadioIndex == 2
          ? "FEMALE"
          : "TRANSGENDER",
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('editBasicInfo', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Navigator.pop(context,"refresh");

    } else {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }



}
