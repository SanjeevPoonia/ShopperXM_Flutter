import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/profile_details/basic_information.dart';
import 'package:shopperxm_flutter/screen/profile_freefancer/freelancer_document_upload.dart';
import 'package:shopperxm_flutter/screen/profile_freefancer/freelancer_other_details.dart';
import 'package:shopperxm_flutter/screen/profile_freefancer/freelancer_payment_details.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_theme.dart';
import '../login_work_flow/login_screen.dart';
import '../profile_details/address_details_screen.dart';
import '../profile_details/payment_details_screen.dart';
import '../profile_freefancer/freefancer_basic_info.dart';
import '../profile_freefancer/freelancer_address_details.dart';


class ProfileTab extends StatefulWidget {
  MenuState createState() => MenuState();
}

class MenuState extends State<ProfileTab> {
  ScrollController _scrollController = new ScrollController();
  bool scrollStart = false;
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool oldPasswordVisible=true;
  bool newPasswordVisible=true;
  bool confirmPasswordVisible=true;
  final _formKey = GlobalKey<FormState>();
  bool isLoading=false;
  List<dynamic> pendingAuditList=[];
  Map<String,dynamic> basicInfo={};
  Map<String,dynamic> address ={};
  Map<String,dynamic> paymentInfo ={};
  String name = '';
  String email = '';
  String mob = '';
  final List<String> itemList = [
    'Basic Information',
    'Address Details',
    'Payment Information',
    'Change Password',
    'Documents',
    'Other Information',
    'Logout',

    // Add more items as needed
  ];
  List<String> image = [
    'assets/basic_info.png',
    'assets/location.png',
    'assets/payment.png',
    'assets/change_pass.png',
    'assets/document.png',
    'assets/other_info.png',
    'assets/logout.png',
    // Add more image URLs as needed
  ];
  int selectedIndex=9999;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading?

      Center(
        child: Loader(),
      ):Column(

        children: [

          Stack(
            alignment: Alignment.topCenter,
            children: [
              // Your Image
              Container(
                height: 165,
                color: Colors.white, // Adjust the opacity as needed
              ),
              Image.asset("assets/top_back.png"),
              Positioned(
                bottom: 50.0,
                right: 40.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Text
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),

                  ],
                ),
              ),
              Positioned(
                top: 95,
                left: 20,// Adjust the position as needed
                child: ClipOval(
                  child: Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child:Image.network(basicInfo["profile_pic"]),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Expanded(child: ListView.builder(
            itemCount: itemList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                child: InkWell(
                    onTap: () {
                      setState(() async {
                        if (index == 0){
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BasicInformationScreen(basicInfo,email,mob),
                              ));
                          if (result != null){
                            getProfileData(context);
                          }
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>FreelancerBasicInfoScreen(basicInfo,email,mob)));
                        }else if (index == 1){



                          final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressDetailsScreen(email,address)));
                          if (result != null){
                            getProfileData(context);
                          }
                        }else if (index == 2){

                          //paymentInfo



                          final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentDetailsScreen(paymentInfo)));
                          if (result != null){
                            getProfileData(context);
                          }                        }else if (index == 3){
                          changePasswordBottomSheet(context);
                        }else if (index == 4){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> FreelancerDocumentScreen()));
                        }else if (index == 5){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> FreelancerOtherScreen()));
                        }else if (index == 6){
                          logout(context);
                        }
                      });
                      print('Clicked on ${itemList[index]}');
                    },
                    child: Container(

                      padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                      child: Row(
                        children: [
                          Image.asset(image[index],height: 40,width: 40,),
                          SizedBox(width: 20,),
                          Text(itemList[index],
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0xFF1D2226)
                            ),
                          ),
                          Spacer(),
                          Image.asset("assets/right-aarow.png",height: 16,width: 16,),
                        ],
                      ),
                    )
                ),
              );
            },
          ),),
          SizedBox(height: 90,),

        ],
      ),
    );
  }

  String? checkConfirmPasswordValidator(String? value) {
    if (newPasswordController.text.toString()!=value) {
      return "Password and Confirm Password must be same";
    } else {
      return null;
    }
  }

  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    changePassword(context);
  }


  String? checkPasswordValidator(String? value) {
    if (value!.length<6) {
      return "Password must be of at least 6 digits";
    } else {
      return null;
    }
  }
// changeSuccessfully(context);
  String? checkOldPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return "Old Password cannot be left as empty";
    } else {
      return null;
    }
  }


  void changePasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (context,bottomSheetState)
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
                      SizedBox(width: 14),

                      Text("Change password",
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
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.only(left: 16,right: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              controller: oldPasswordController,
                              obscureText:oldPasswordVisible,
                              validator: checkOldPasswordValidator,
                              decoration: InputDecoration(
                                hintText: "Enter Password",
                                label: const Text("Old Password",
                                  style: TextStyle(
                                      color: Color(0xFF00407E)
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(oldPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility, color: Color(0xFF00376A),),
                                  onPressed: () {
                                    setState(
                                          () {
                                        bottomSheetState((){});
                                        oldPasswordVisible = !oldPasswordVisible;
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
                              controller: newPasswordController,
                              obscureText: newPasswordVisible,
                              validator: checkPasswordValidator,
                              decoration: InputDecoration(
                                hintText: "Enter Password",
                                label: const Text("New Password",
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
                                        bottomSheetState((){});
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
                                        bottomSheetState((){});
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
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25),


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

                          _submitHandler();

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

          ),
        );

      },
    );
  }
  void changeSuccessfully(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 14),
                    Center(
                      child: Text("Password updated Successfully",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),

                    ),

                    Spacer(),

                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",width: 38,height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Lottie.asset('assets/done.json',
                          width: 140.0, // Adjust the image width as needed
                          height: 140.0,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 25),


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
                        Navigator.pop(context);

                      },
                      child: const Text(
                        'Back',
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
  void logout(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 14),
                    Center(
                      child: Text("Are you Sure?",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),

                    ),

                    Spacer(),

                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/cross_ic.png",width: 38,height: 38)),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Lottie.asset('assets/logout.json',
                          width: 200.0, // Adjust the image width as needed
                          height: 200.0,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 25),


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
                      onPressed: () async {
                        Navigator.pop(context);
                        SharedPreferences preferences = await SharedPreferences.getInstance();
                        await preferences.clear();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => true);
                      },
                      child: const Text(
                        'LOGOUT',
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
    name = responseJSON["data"]["basic_info"]["full_name"] ?? "NA";
    email = responseJSON["data"]["email"] ?? "NA";
    mob = responseJSON["data"]["mobile_no"] ?? "NA";
    basicInfo = responseJSON["data"]["basic_info"];
    address = responseJSON["data"]["address"];
    paymentInfo = responseJSON["data"]["payment_info"];

    setState(() {

    });



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData(context);
  }

  changePassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please wait...');
    var data = {
      "old_password": oldPasswordController.text,
      "password": newPasswordController.text
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('change_password', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Navigator.pop(context);
      changeSuccessfully(context);


      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();

      Toast.show("Please Login with new password",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);



    } else {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }


}
