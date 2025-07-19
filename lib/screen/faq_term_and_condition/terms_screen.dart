import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/network/api_dialog.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/login_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:toast/toast.dart';

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';


class TermsScreen extends StatefulWidget {
  FaqState createState() => FaqState();
}

class FaqState extends State<TermsScreen> {
  bool isVisible = true;
  int selectedIndex = -1;
  List<bool> itemVisibility = List.generate(10, (index) => false);
  bool checkToggle=false;
  bool isLoading=false;

  String title="";
  String desc="";
  @override


  Widget build(BuildContext context) {

    ToastContext().init(context);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: "RobotoFlex",

      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
                height: 100,
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
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [

                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/back_arrow.png", width: 17,
                            height: 17),
                      ),

                      SizedBox(width: 10),
                      Expanded(
                          child:Text("Privacy Policy & Contractor Agreement",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black))),

                      SizedBox(width: 10),
                    ],
                  ),
                )),
            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black)),
            ),

            SizedBox(height: 10),

          Expanded(child:

          isLoading?
              Center(
                child: Loader(),
              ):

          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:

                Html(data: desc,

                )

                /* Text(desc,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(0xFF808080))),*/
              ),
            ],

          )),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),  // Set the radius for bottom-left corner
                topRight: Radius.circular(20.0),
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

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 10),

                Row(
                  children: [

                    SizedBox(width: 16),

                    GestureDetector(
                      onTap: (){
                        setState(() {
                          checkToggle=!checkToggle;
                        });
                      },
                      child: Container(
                        child: checkToggle?
                        Icon(Icons.check_box,color: AppTheme.themeColor):Icon(Icons.check_box_outline_blank),
                      ),
                    ),


                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Text("I have read and agree to the Platform independent Contractor Agreement and Privacy Policy",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black)),
                      ),
                    ),


                  ],
                ),

                SizedBox(height: 12),


                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 47,
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

                        if(checkToggle)
                        {
                          acceptPrivacyPolicy(context);
                        }


                        // successBottomSheet(context);

                      },
                      child: const Text(
                        'KYC Request To Create Account',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),



              ],
            ),
          )









          ],
        ),
      ),
    );
  }






  getPrivacyPolicy(BuildContext context) async {

    setState(() {
      isLoading=true;
    });



    var data = {
      "user_id": AppModel.userID,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getpolicy', data, context);
    setState(() {
      isLoading=false;
    });
    List<dynamic> list = json.decode(response.body);

    //List<dynamic> list=responseJSON;
    if(list.length!=0)
      {
        title=list[0]["title"];
        desc=list[0]["description"];
        setState(() {

        });
      }






   // print(responseJSON);
  }

  acceptPrivacyPolicy(BuildContext context) async {


    APIDialog.showAlertDialog(context, "Please wait...");


    var data = {
      "is_aggrement_accepted":checkToggle,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('generateKycRequest', data, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if(responseJSON["status"]==1)
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);



      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);


    }
    else
    {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrivacyPolicy(context);
  }

}
