import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/reimbursement/reimbursement_form.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../widgets/appbar_widget.dart';


class ClaimReimbursementScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<ClaimReimbursementScreen> {
  int selectedRadioIndex=9999;
  bool isLoading=false;

  List<dynamic> claimList=[];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body: Column(
          children: [
            AppBarWidget("Claim Reimbursement"),



           /* Expanded(child:
            Center(
              child: SizedBox(
                height: 170,
                child: OverflowBox(
                    minHeight: 240,
                    maxHeight: 240,
                    child:   Lottie.asset("assets/reim_anim.json")
                ),
              ),
            )),*/



             Expanded(
             child:
                 isLoading?Center(child:Loader()):


                 claimList.length==0?


                 Center(
                   child: Text("No Data found!"),
                 ):
                 ListView.builder(
                     itemCount: claimList.length,
                     itemBuilder: (BuildContext context,int pos)
                 {
                   return Column(
                     children: [

                       Container(
                           height: 148,
                           padding: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
                           margin: EdgeInsets.symmetric(horizontal: 13),
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(10),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.black12.withOpacity(0.3),
                                 offset: const Offset(0.0, 2.0),
                                 blurRadius: 4.0,
                               ),
                             ],
                           ),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [


                               Row(
                                 children: [

                                   Container(
                                     width: 39,
                                     height: 39,
                                     padding: EdgeInsets.all(7),
                                     decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         color: AppTheme.themeColor
                                     ),

                                     child: Center(
                                       child: Image.asset("assets/taxi_ic.png"),
                                     ),
                                   ),


                                   SizedBox(width: 15),


                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [

                                       Text(
                                           "Invoice ID",
                                           style: TextStyle(
                                             fontSize: 13,
                                             fontWeight: FontWeight.w400,
                                             color: Color(0xFFA5A5A5),
                                           )),

                                       Text(
                                           "ABC123",
                                           style: TextStyle(
                                             fontSize: 15,
                                             fontWeight: FontWeight.w500,
                                             color: Colors.black,
                                           )),

                                     ],
                                   ),

                                   Spacer(),

                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.end,
                                     children: [

                                       Text(
                                           claimList[pos]['grand_total_expense'].toString(),
                                           style: TextStyle(
                                             fontSize: 17,
                                             fontWeight: FontWeight.w500,
                                             color: Color(0xFFE91919),
                                           )),

                                       Text(
                                           claimList[pos]['created_at'],
                                           style: TextStyle(
                                             fontSize: 13,
                                             fontWeight: FontWeight.w400,
                                             color: Colors.black,
                                           )),

                                     ],
                                   )



                                 ],
                               ),

                               SizedBox(height: 25),



                               Row(
                                 children: [
                                   Expanded(
                                       child: InkWell(
                                         onTap:(){

                                             Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ReimbursementFormScreen(

                                             )));

                                         },
                                         child: Container(
                                           height:48,
                                           padding: EdgeInsets.symmetric(horizontal: 12),
                                           decoration: BoxDecoration(
                                             color: Colors.white,
                                             borderRadius: BorderRadius.circular(4),
                                             boxShadow: [
                                               BoxShadow(
                                                 color:
                                                 Colors.black12.withOpacity(0.3),
                                                 offset: const Offset(0.0, 5.0),
                                                 blurRadius: 6.0,
                                               ),
                                             ],
                                           ),

                                           child: Row(
                                             children: [


                                               Image.asset("assets/more_ic.png",width: 20,height: 20),

                                               SizedBox(width: 10),


                                               Text("View Details",
                                                   style: TextStyle(
                                                     fontSize: 13,
                                                     fontWeight: FontWeight.w600,
                                                     color: Color(0xFF00407E),
                                                   )),

                                             ],
                                           ),
                                         ),
                                       ),flex: 1),

                                   SizedBox(width: 20),

                                   Expanded(
                                       child: InkWell(
                                         onTap:(){

                                           //successBottomSheet(context);
                                         },
                                         child: Container(
                                           margin: EdgeInsets.only(top: 1),
                                           height:48,
                                           padding: EdgeInsets.symmetric(horizontal: 12),
                                           decoration: BoxDecoration(
                                             color: Color(0xFF00407E),
                                             borderRadius: BorderRadius.circular(4),
                                             boxShadow: [
                                               BoxShadow(
                                                 color:
                                                 Colors.black12.withOpacity(0.3),
                                                 offset: const Offset(0.0, 5.0),
                                                 blurRadius: 6.0,
                                               ),
                                             ],
                                           ),

                                           child: Row(
                                             children: [

                                               Text("Track Status",
                                                   style: TextStyle(
                                                     fontSize: 13,
                                                     fontWeight: FontWeight.w600,
                                                     color: Colors.white,
                                                   )),


                                               SizedBox(width: 10),

                                               Image.asset("assets/status_ic.png",width: 21,height: 21),


                                             ],
                                           ),
                                         ),
                                       ),flex: 1),
                                 ],
                               )








                             ],
                           )
                       ),

                       SizedBox(height: 15),


                     ],
                   );
                 }


                 )


            ),



            Column(

              children: [



                InkWell(
                    onTap: (){
                       Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: ReimbursementFormScreen()));

                    },

                    child: Image.asset("assets/add_reim.png",width: 50,height: 50)),

                SizedBox(height: 13),

                Text(
                  'Add Reimbursement',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.themeColor,
                  ),

                ),
                SizedBox(height: 17),

              ],
            )












          ],
        )
      ),
    );
  }

  void successBottomSheet(BuildContext context) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,


                  children: [
                    SizedBox(width: 100),

                    Text("Feedback sent\n successfully",
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


                SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: OverflowBox(
                    minHeight: 170,
                    maxHeight: 170,
                    child:  Lottie.asset("assets/check_animation.json"),
                  ),
                ),


                SizedBox(height: 25),



                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 48,
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
                        'Next',
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
  getClaimList(BuildContext context) async {

    setState(() {
      isLoading=true;
    });
    var data = {

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('actualTransactionClaimList', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON['data']);
    claimList = responseJSON['data'];
    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClaimList(context);
  }






}
