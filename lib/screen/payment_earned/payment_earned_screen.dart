import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/audits/record_video_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/fill_audit_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:shopperxm_flutter/widgets/appbar_widget.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';
import '../../widgets/textfield_profile_widget.dart';
import '../../widgets/textfield_widget.dart';


class PaymentEarnedScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<PaymentEarnedScreen> {
  int selectedRadioIndex=9999;
  int selectedIndex=9999;
  int selectedTab=1;
  List<dynamic> paymentList=[];

  bool isLoading=false;


  List<String> scenarioList=[
    "Vehicle Enquiry",
    "Ola EV Enquiry",
    "OLA Compliance Audit",
    "Service Informed Audit"
  ];

  List<String> audioModeList=[
    "Mystery Audit",
    "Compliance Audit",
    "Informed Audit",
  ];

  List<String> customerTypeList=[
    "Mystery",
    "Infra Audit",
    "Informed",
  ];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body:


        isLoading?
            Column(
              children: [

                AppBarWidget("Payment Earned"),

                Expanded(child:  Center(
                  child: Loader(),
                ))


              ],
            ):

            paymentList.length==0?

            Column(
              children: [

                AppBarWidget("Payment Earned"),


               Expanded(child:  Center(
                 child: Text("No data found!"),
               ))


              ],
            ):






        Column(
          children: [


            Stack(
              children: [

             //   Image.asset("assets/payment_bg.png"),

                AppBarWidget("Payment Earned"),


               /* Column(
                  children: [
                    SizedBox(height: 100),


                    Padding(padding: EdgeInsets.only(left: 17),

                    child:  Text("Payment\nEarned",
                        style: TextStyle(
                          fontSize: 22,
                          height: 1.7,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),

                    )



                  ],
                ),*/


           /*     Column(
                  children: [
                    SizedBox(height: 200),



                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 17),
                      padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.black12.withOpacity(0.3),
                            offset: const Offset(0.0, 5.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),

                      child: Column(
                        children: [

                          Row(
                            children: [
                              SizedBox(width: 6),


                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFDDBD),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Lottie.asset("assets/payment_anim.json"),
                                
                              ),



                            Expanded(
                              child: Column(
                                children: [


                                  Row(
                                    children: [
                                      Spacer(),

                                      Text("October",
                                          style: TextStyle(
                                            fontSize: 14,

                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          )),

                                      SizedBox(width: 10)
                                    ],
                                  ),


                                  SizedBox(height: 7),






                                  Container(
                                    margin: EdgeInsets.only(left: 45,right: 10),
                                    child: LinearPercentIndicator(
                                      barRadius: const Radius.circular(4),
                                      padding: EdgeInsets.zero,
                                      lineHeight: 7.0,
                                      percent: 0.9,
                                      progressColor: Color(0xFFFF7C00),
                                    ),
                                  ),


                                ],
                              ),
                            )



                            ],
                          ),

                          const SizedBox(height: 12),

                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                            color: Colors.grey.withOpacity(0.4),
                            height: 1,
                             ),


                          Row(
                           crossAxisAlignment: CrossAxisAlignment.start,

                            children: [


                              Expanded(child: Padding(
                                padding: const EdgeInsets.only(left: 5,top: 10),
                                child: Row(children: [

                                  Text("Total : ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),

                                  Text("₹10,508",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ))



                                ]),
                              ),flex: 1),


                              Container(
                                width: 1,
                                color:Colors.grey.withOpacity(0.4),
                                height: 50,
                              ),



                              Expanded(child: Padding(
                                padding: const EdgeInsets.only(left: 15,top: 12),
                                child: Row(children: [



                                  Text("₹2,000 completed",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF7A7171),
                                      ))



                                ]),
                              ),flex: 1)

                            ],
                          )










                        ],
                      ),

                    )




                  ],
                )*/


              ],
            ),

           // SizedBox(height: 20),


            Expanded(child:




            ListView(children: [


            /*  Container(
                height: 85,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: [4,4],
                  radius: Radius.circular(8),
                  color: AppTheme.themeColor,
                  padding: EdgeInsets.all(6),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [


                            SizedBox(width: 5),


                            Text("Total Amount",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                )),



                            Spacer(),


                            Text("₹20,900",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.themeColor,
                                )),


                            SizedBox(width: 8),

                          ],
                        ),
                      )
                  ),
                ),

              ),

              SizedBox(height: 22),


              Container(
                margin: EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  children: [
                    Expanded(child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.black12.withOpacity(0.3),
                            offset: const Offset(0.0, 1.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),


                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("₹10,508",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2FAE67),
                              )),

                          SizedBox(height: 6),





                          Text("Settled Amount",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFA5A5A5),
                              )),

                        ],
                      ),

                    ),flex: 1),

                    SizedBox(width: 20),


                    Expanded(child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.black12.withOpacity(0.3),
                            offset: const Offset(0.0, 1.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),


                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("₹2,000",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFF7C00),
                              )),

                          SizedBox(height: 6),





                          Text("Others",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFA5A5A5),
                              )),

                        ],
                      ),

                    ),flex: 1),








                  ],
                ),
              ),
*/


         /*     SizedBox(height: 20),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Text("Lorem Ipsum",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                  ),
                ],
              ),

              SizedBox(height: 15),



              Container(
                margin: EdgeInsets.symmetric(horizontal: 13),
                height: 56,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xFFECECEC),
                    borderRadius: BorderRadius.circular(9)
                ),


                child: Row(
                  children: [

                    Expanded(child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedTab=1;
                        });
                      },
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color:selectedTab==1? Colors.white:Color(0xFFECECEC),
                        ),
                        child: Center(
                          child:Text("Approved",
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: selectedTab==1?Colors.black:Color(0xFFA5A5A5),
                              )),
                        ),
                      ),
                    ),flex: 1),



                    Expanded(child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedTab=2;
                        });
                      },
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color:selectedTab==2? Colors.white:Color(0xFFECECEC),
                        ),
                        child: Center(
                          child:Text("Pending",
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: selectedTab==2?Colors.black:Color(0xFFA5A5A5),
                              )),
                        ),
                      ),
                    ),flex: 1),




                  ],
                ),


              ),


              SizedBox(height: 15),*/



              Padding(padding: EdgeInsets.only(left: 17),

                child:  Text("Payment Earned",
                    style: TextStyle(
                      fontSize: 15,

                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )),

              ),

              SizedBox(height: 15),

              ListView.builder(
                  itemCount: paymentList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context,int pos)
                  {
                    return Column(
                      children: [

                        Container(
                            padding: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
                            margin: EdgeInsets.symmetric(horizontal: 13),
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
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
                                            "Client Name",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFFA5A5A5),
                                            )),

                                        Text(
                                            paymentList[pos]["client"],
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
                                            "₹"+paymentList[pos]["amount"].toString(),
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2FAE67),
                                            )),

                                        Text(
                                            returnDateInFormat(paymentList[pos]["last_update"].toString()),
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



                           /*     Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                          onTap:(){

                                            //  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ReimbursementFormScreen()));

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
                                )*/








                              ],
                            )
                        ),

                        SizedBox(height: 15),


                      ],
                    );
                  }


              )


            ],))





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


                Row(
                  children: [


                    Expanded(child: Card(
                      elevation: 2,
                      shadowColor:Colors.grey,
                    //  margin: EdgeInsets.symmetric(horizontal: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
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
                                  Color(0xFF708096)), // fore
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ))),
                          onPressed: () {

                           // Navigator.pop(context);


                          },
                          child: const Text(
                            'Previous',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),flex: 1),


                    SizedBox(width: 15),






                    Expanded(child: Card(
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
                    ),flex: 1),

                  ],
                )






              ],
            ),
          );
        }

        );

      },
    );
  }



  getPaymentEarnedList(BuildContext context) async {

    setState(() {
      isLoading=true;
    });
    var data = {
      "user_id":AppModel.userID
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getPaymentListFreelancer', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    paymentList = responseJSON['data'];
    setState(() {
      isLoading=false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPaymentEarnedList(context);

  }



  String returnDateInFormat(String date) {
    final format = DateFormat('yyyy-MM-dd');
    var dateTime22 = format.parse(date, true);
    /* final DateFormat dayFormatter = DateFormat.yMMM();
    String dayAsString = dayFormatter.format(dateTime22);*/
    print(dateTime22);
    return dateTime22.toString();
  }

}
