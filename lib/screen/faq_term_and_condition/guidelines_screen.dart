import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/network/api_dialog.dart';
import 'package:shopperxm_flutter/screen/login_work_flow/login_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:shopperxm_flutter/widgets/image_view_screen.dart';
import 'package:shopperxm_flutter/widgets/webview_screen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';
import '../../widgets/full_video_screen.dart';
import '../../widgets/view_pdf_screen.dart';


class GuidelinesScreen extends StatefulWidget {
  final String storeID;
  final String beatPlanID;
  final List<dynamic> docList;
  GuidelinesScreen(this.storeID,this.beatPlanID,this.docList);
  FaqState createState() => FaqState();
}

class FaqState extends State<GuidelinesScreen> {
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
                          child:Text("Required Policy",
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
              child: Text("Document List",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black)),
            ),

            SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 12, right: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 0,
                    crossAxisCount: 3,
                    childAspectRatio: (2 / 2)),
                itemCount: widget.docList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {

                      if(lookupMimeType(widget.docList[index]).toString().startsWith('video/'))
                      {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FullVideoScreen(widget.docList[index].toString())));


                      }
                      else if(lookupMimeType(widget.docList[index]).toString().startsWith('image/'))
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageView(widget.docList[index].toString())));

                      }

                      else if(lookupMimeType(widget.docList[index]).toString().startsWith('pdf/'))
                      {

                      //  _launchBrowser(widget.docList[index].toString());


                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewPDFScreen(widget.docList[index].toString())));

                      }
                      else
                        {
                         // _launchBrowser(widget.docList[index].toString());
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewPPT("http://docs.google.com/viewer?url="+widget.docList[index].toString())));

                        }


                    },
                    child: Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: Colors.black),
                      ),

                      child: Center(
                        child:
                        lookupMimeType(widget.docList[index]).toString().startsWith('video/')?


                          Image.asset("assets/ic_video.png"):


                        lookupMimeType(widget.docList[index]).toString().startsWith('image/')?


                        Image.asset("assets/ic_image.png"):


                        lookupMimeType(widget.docList[index]).toString().startsWith('pdf/')?


                        Image.asset("assets/pdf_ic.png"):

                        Image.asset("assets/ic_doc.png")


                        ,
                      ),
                    ),
                  );
                  // Item rendering
                },
              ),
            ),











          ],
        ),
      ),
    );
  }






  selfAssign(BuildContext context) async {

   APIDialog.showAlertDialog(context, "Please wait...");



    var data = {
      "user_id": AppModel.userID,
      "store_id": widget.storeID,
      "bp_id": widget.beatPlanID
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('auditSelfAssign', data, context);
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
    print(widget.docList.toString());
   // getPrivacyPolicy(context);
  }
  _launchBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
          Uri.parse(url), mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
