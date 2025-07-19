import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/audits/pending_audits.dart';
import 'package:shopperxm_flutter/screen/bottom_tabs/assigned_tab.dart';
import 'package:shopperxm_flutter/screen/payment_earned/payment_earned_screen.dart';
import 'package:shopperxm_flutter/screen/reimbursement/claim_reimbursement.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import '../network/Utils.dart';
import '../network/api_helper.dart';
import '../utils/app_modal.dart';
import '../utils/app_theme.dart';
import '../widgets/sidebar_widget.dart';
import 'Invoice/invoice_raised.dart';
import 'audits/artifact_pending_audits.dart';
import 'audits/completed_audits.dart';
import 'audits/open_audits.dart';
import 'audits/tagged_audits.dart';
import 'faq_term_and_condition/faq_screen.dart';
import 'incomplete_complete_screen/complete_screen.dart';
import 'incomplete_complete_screen/incomplete_screen.dart';
import 'login_work_flow/login_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MenuScreen> {
  String emailID = '';
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9CFA5),
      body: Container(
        // color: const Color(0xFFF9CFA5),
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                // margin: EdgeInsets.only(left: 20,right: 20,top: 40),
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/drawer_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 23),


                    Row(
                      children: [

                        Spacer(),

                        InkWell(
                          onTap: () {
                            Provider.of<MEN.MenuController>(context,
                                listen: false)
                                .toggle();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Image.asset("assets/ham_drawer.png",width: 22.2,height: 19.42),
                          ),
                        )

                      ],
                    ),


                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage:
                            AssetImage('assets/profile_d1.png'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(emailID,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  const SizedBox(height: 4),

                                  GestureDetector(
                                    onTap: (){
                                      logout(context);
                                    },
                                    child: Row(
                                      children: [

                                        Image.asset("assets/power_ic.png",width: 19,height: 19),
                                        SizedBox(width: 5),


                                        Text("LOG OUT",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),





                                ],
                              )
                          ),
                          const SizedBox(width: 10),
                          //  const Spacer(),

                        ],
                      ),
                    ),


                    SizedBox(height: 10),



                    Container(
                      margin: EdgeInsets.only(left: 15,right: 110),
                      child: Divider(
                        color: Colors.white.withOpacity(0.50),
                      ),
                    ),
                    Expanded(
                        child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 12),


                            children: [



                              SideBarWidget(
                                  'Home',
                                  'assets/home_ic.png'
                              ),




//artifact_ic
                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));



                                },
                                child: SideBarWidget(
                                    'Assigned Audits',
                                    'assets/assig_ic.png'
                                ),
                              ),


                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: OpenAuditsScreen()));



                                },
                                child: SideBarWidget(
                                    'Open Audits',
                                    'assets/assig_ic.png'
                                ),
                              ),




                              InkWell(
                                onTap: (){

                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: TaggedAuditsScreen(true)));

                                },
                                child: SideBarWidget(
                                    'Tagged Audits',
                                    'assets/tag_ic.png'
                                ),
                              ),
                              InkWell(
                                onTap: (){


                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: PendingAuditsScreen()));

                                },
                                child: SideBarWidget(
                                    'Pending Audits',
                                    'assets/pending_ic.png'
                                ),
                              ),


                              InkWell(
                                onTap: (){


                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ArtifactPendingAuditsScreen()));


                                },
                                child: SideBarWidget(
                                    'Artifact Pending Audits',
                                    'assets/artifact_ic.png'
                                ),
                              ),




                              InkWell(
                                onTap: (){
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: CompletedAuditsScreen()));

                                },
                                child: SideBarWidget(
                                    'Complete Audits',
                                    'assets/complete_ic.png'
                                ),
                              ),

//claim_ic
                              SideBarWidget(
                                  'Feedback',
                                  'assets/feedback2.png'
                              ),

                              InkWell(
                                onTap: (){
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: ClaimReimbursementScreen()));



                                },
                                child: SideBarWidget(
                                    'Claim Reimbursement',
                                    'assets/claim_ic.png'
                                ),
                              ),

                              AppModel.userType=="2"?Container():



                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text("Training & Certificates",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.84))),
                              ),



                              AppModel.userType=="2"?Container():
                              InkWell(
                                onTap: (){
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: IncompleteScreen()));


                                },
                                child: SideBarWidget(
                                    'Incompleted',
                                    'assets/incomplete_ic.png'
                                ),
                              ),


                              AppModel.userType=="2"?Container():
                              InkWell(
                                onTap: (){
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: CompleteScreen()));


                                },
                                child:  SideBarWidget(
                                    'Completed',
                                    'assets/complete_ic.png'
                                ),
                              ),



                              AppModel.userType=="1"?Container():

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text("Payment",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.84))),
                              ),
                              AppModel.userType=="1"?Container():

                              InkWell(
                                onTap: (){
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: PaymentEarnedScreen()));


                                },
                                child: SideBarWidget(
                                    'Payment Earned',
                                    'assets/payment_ic.png'
                                ),
                              ),
                              AppModel.userType=="1"?Container():
                              InkWell(
                                onTap: (){


                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: InvoiceRaisedScreen()));

                                },
                                child: SideBarWidget(
                                    'Invoice Raised',
                                    'assets/invoice_ic.png'
                                ),

                              ),



                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text("Communicate",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.84))),
                              ),
                              InkWell(
                                onTap: (){


                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: FaqScreen()));

                                },
                                child: SideBarWidget(
                                    'FAQ',
                                    'assets/faq_ic.png'
                                ),

                              ),
                              InkWell(
                                onTap: (){
                                  termAndConditionBottomSheet(context);

                                },
                                child: SideBarWidget(
                                    'Terms & Condition',
                                    'assets/terms_ic.png'
                                ),

                              ),


                            ])),

                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ],
          )),
    );
  }
  void termAndConditionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,bottomSheetState)
        {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 50),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)), // Set the corner radius here
              color: Colors.white, // Example color for the container
            ),
            child:Column(
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

                    Text("Terms and Conditions",
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
                Expanded(child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16,right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lorem Ipsum is simply dummy text ?',
                            style: TextStyle(
                                color: Color(0xFF00407E),
                                fontSize: 14,
                                fontWeight: FontWeight.w600

                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting\n\n'
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting',
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14,
                                fontWeight: FontWeight.normal

                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Lorem Ipsum is simply text ?',
                            style: TextStyle(
                                color: Color(0xFF00407E),
                                fontSize: 14,
                                fontWeight: FontWeight.w600

                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting',

                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14,
                                fontWeight: FontWeight.normal

                            ),
                          ),
                          SizedBox(height: 20),
                          Text('Lorem Ipsum is simply dummy text ?',
                            style: TextStyle(
                                color: Color(0xFF00407E),
                                fontSize: 14,
                                fontWeight: FontWeight.w600

                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting\n\n'
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting',
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 14,
                                fontWeight: FontWeight.normal

                            ),
                          ),

                        ],
                      ),
                    ),


                  ],
                )),
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
                        'I Accept',
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
  void initState() {
    super.initState();
    getValue();
  }
  Future<void> getValue() async {
    String? email = await MyUtils.getSharedPreferences("email");
    emailID = email ?? "NA";
    print(email);
  }
}
