import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/otp_verification__new_screen.dart';
import 'package:shopperxm_flutter/screen/profile_details/address_details_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';

class BasicInformationSignUpScreen extends StatefulWidget {
  final Map<String,dynamic> profileData;
  final String email;
  final String mobile;

  BasicInformationSignUpScreen(this.profileData,this.email, this.mobile);

  BasicInformationScreenState createState() => BasicInformationScreenState();
}

class BasicInformationScreenState extends State<BasicInformationSignUpScreen> {
  var usernameController = TextEditingController();
  var ageController = TextEditingController();
  XFile? supportImage;
  bool newPasswordVisible=true;
  bool confirmPasswordVisible=true;
  var userEmailController = TextEditingController();
  var userMobNoController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  bool passwordVisible = true;
  bool scrollStart = false;
  String? selectedDate;
  var newPasswordController = TextEditingController();
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
                  height: 100,
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


                              Container(
                                child: TextFormField(
                                  controller: firstNameController,
                                  validator: nameValidator,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "First Name",
                                    label: Text(
                                      "First Name",
                                      style:
                                      TextStyle(color: Color(0xFF00376A)),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 5),


                              Container(
                                child: TextFormField(
                                  controller: lastNameController,
                                  validator: nameValidator,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Last Name",
                                    label: Text(
                                      "Last Name",
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
                                      style: TextStyle(color: Colors.black),
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
                              SizedBox(height: 5),




                              Container(
                                child: TextFormField(
                                  controller: userEmailController,
                                  style: TextStyle(color: Colors.black),
                                  validator: emailValidator,
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


                              SizedBox(height: 5),


                              Container(
                                child: TextFormField(
                                  controller: newPasswordController,
                                  obscureText: newPasswordVisible,
                                  validator: checkPasswordValidator,
                                  decoration: InputDecoration(
                                    hintText: "Enter Password",
                                    label: const Text("Password",
                                      style: TextStyle(
                                          color: Color(0xFF00407E)
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(newPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility, color: Color(0xFF00376A),),
                                      onPressed: () {
                                        setState(
                                              () {
                                            newPasswordVisible = !newPasswordVisible;
                                          },
                                        );
                                      },
                                    ),
                                    alignLabelWithHint: false,
                                    filled: false,
                                    enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:Color(0xFF00376A))),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,

                                ),

                              ),
                              SizedBox(height: 8),
                              Container(
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: confirmPasswordVisible,
                                  validator: checkConfirmPasswordValidator,
                                  decoration: InputDecoration(
                                    hintText: "Enter Password",
                                    label: const Text("Confirm New Password",
                                      style: TextStyle(
                                          color: Color(0xFF00407E)
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(confirmPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility, color: Color(0xFF00376A),),
                                      onPressed: () {
                                        setState(
                                              () {
                                          setState(() {

                                          });
                                            confirmPasswordVisible = !confirmPasswordVisible;
                                          },
                                        );
                                      },
                                    ),
                                    alignLabelWithHint: false,
                                    filled: false,
                                    enabledBorder: UnderlineInputBorder( borderSide: BorderSide(color:Color(0xFF00376A))),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,

                                ),

                              ),


                              SizedBox(height: 45),

                              Card(
                                elevation: 4,
                                shadowColor:Colors.grey,
                                margin: EdgeInsets.symmetric(horizontal: 14),
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

                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerificationNewScreen(userEmailController.text, userMobNoController.text.toString())));

                                    //  _submitHandler(context);

                                    },
                                    child: const Text(
                                      'NEXT',
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


  String? checkConfirmPasswordValidator(String? value) {
    if (newPasswordController.text.toString()!=value) {
      return "Password and Confirm Password must be same";
    } else {
      return null;
    }
  }
  String? checkPasswordValidator(String? value) {
    if (value!.length<6) {
      return "Password must be of at least 6 digits";
    } else {
      return null;
    }
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value!)) {
      return 'Please enter valid Mobile number, it must be of 10 digits and begins with 6, 7, 8 or 9.';
    }
    return null;
  }
}
