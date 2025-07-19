
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shopperxm_flutter/screen/audits/tagged_audits.dart';
import 'package:shopperxm_flutter/screen/bottom_tabs/home_tab.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:provider/provider.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart';
import '../utils/app_modal.dart';
import 'bottom_tabs/assigned_tab.dart';
import 'bottom_tabs/feedback_tab.dart';
import 'bottom_tabs/profile_tab.dart';
import 'main_screen.dart';
import 'menu_screen.dart';

class LandingScreen extends StatefulWidget
{
  LandingState createState()=>LandingState();
}

class LandingState extends State<LandingScreen> with TickerProviderStateMixin
{
  int selectedIndex = 0;
  MEN.MenuController? menuController;
  final ZoomDrawerController controller = ZoomDrawerController();
  List<String> titleList=[
    "Home",
    "Assigned Audits",
    "Feedback",
    "Profile"
  ];

  List<String> titleListInApp=[
    "Assigned Audits",
    "Tagged Audits",
    "Feedback",
    "Profile"
  ];


  List<Widget> bottomTabItems = <Widget>[
    HomeTab(),
    AssignedTab(false),
    FeedbackTab(),
    ProfileTab(),
  ];

  List<Widget> bottomTabInApp = <Widget>[
    AssignedTab(false),
    TaggedAuditsScreen(false),
    FeedbackTab(),
    ProfileTab(),
  ];



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child:ChangeNotifierProvider(
        create: (context) => menuController,
        child: ZoomScaffold(
          menuScreen:  MenuScreen(),
          showBoxes: true,
          orangeTheme: false,
          pageTitle: AppModel.userType=="1"?titleListInApp[selectedIndex]:titleList[selectedIndex],
          contentScreen: Layout(
              contentBuilder: (cc) => Stack(
                children: [



                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:
                      AppModel.userType=="1"?

                      bottomTabInApp[selectedIndex]:


                      bottomTabItems[selectedIndex]),
                  Column(
                    children: [
                      const Spacer(),
                      Container(
                        height: 86,
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.3),
                              offset: Offset(0.0, 5.0),
                              blurRadius: 6.0,

                            ),
                          ],
                        ),

                        // color: Colors.white,
                        child: Scaffold(
                          extendBody: true,
                          backgroundColor: Colors.transparent,
                          bottomNavigationBar: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                            child: BottomAppBar(
                              padding: EdgeInsets.zero,
                              //bottom navigation bar on scaffold
                              color: const Color(0xFFE5EBF2),
                              shape: const CircularNotchedRectangle(),
                              //shape of notch
                              // notchMargin: 5,
                              //notche margin between floating button and bottom appbar
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child:
                                AppModel.userType=="1"?

                                Row(
                                  //children inside bottom appbar
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        selectedIndex = 0;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 69,
                                        height: 69,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedIndex==0?Colors.white:Color(0xFFE5EBF2),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 13),
                                            Image.asset(
                                                'assets/assign_nav.png',
                                                width: 25,
                                                height: 25,
                                                color: selectedIndex == 0
                                                    ? Color(0xFF00407E)
                                                    : Color(0xFFA0B7CF)),
                                            Spacer(),

                                            Text('Assigned',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:FontWeight.w700,
                                                    color: selectedIndex ==
                                                        0
                                                        ? Color(0xFF00407E)
                                                        : Color(0xFF00407E).withOpacity(0.30))),

                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //feedback_ic

                                    GestureDetector(
                                      onTap: () {
                                        selectedIndex = 1;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 69,
                                        height: 69,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedIndex==1?Colors.white:Color(0xFFE5EBF2),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 13),
                                            Image.asset(
                                                'assets/tag_ic.png',
                                                width: 25,
                                                height: 25,
                                                color: selectedIndex == 1
                                                    ? Color(0xFF00407E)
                                                    : Color(0xFFA0B7CF)),

                                            Spacer(),
                                            Text('Tagged',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: selectedIndex ==
                                                        1
                                                        ? Color(0xFF00407E)
                                                        : Color(0xFF00407E).withOpacity(0.30))),


                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),



                                    GestureDetector(
                                      onTap: () {
                                        selectedIndex = 2;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 69,
                                        height: 69,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedIndex==2?Colors.white:Color(0xFFE5EBF2),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 13),
                                            Image.asset(
                                                'assets/feedback_ic.png',
                                                width: 25,
                                                height: 25,
                                                color: selectedIndex == 2
                                                    ? Color(0xFF00407E)
                                                    : Color(0xFFA0B7CF)),


                                            Spacer(),
                                            Text('Feedback',
                                                style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: selectedIndex ==
                                                        2
                                                        ? Color(0xFF00407E)
                                                        : Color(0xFF00407E).withOpacity(0.30))),


                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),


                                    GestureDetector(
                                      onTap: () {
                                        selectedIndex = 3;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 69,
                                        height: 69,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedIndex==3?Colors.white:Color(0xFFE5EBF2),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 13),
                                            Image.asset(
                                                'assets/profile_nav.png',
                                                width: 25,
                                                height: 25,
                                                color: selectedIndex == 3
                                                    ? Color(0xFF00407E)
                                                    : Color(0xFFA0B7CF)),

                                            Spacer(),
                                            Text('Profile',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: selectedIndex ==
                                                        3
                                                        ? Color(0xFF00407E)
                                                        : Color(0xFF00407E).withOpacity(0.30))),

                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ):




                                Row(
                                  //children inside bottom appbar
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        selectedIndex = 0;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 69,
                                        height: 69,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedIndex==0?Colors.white:Color(0xFFE5EBF2),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 13),
                                            Image.asset(
                                                'assets/home_nav.png',
                                                width: 25,
                                                height: 25,
                                                color: selectedIndex == 0
                                                    ? Color(0xFF00407E)
                                                    : Color(0xFFA0B7CF)),
                                            Spacer(),

                                            Text('Home',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:FontWeight.w700,
                                                    color: selectedIndex ==
                                                        0
                                                        ? Color(0xFF00407E)
                                                        : Color(0xFF00407E).withOpacity(0.30))),

                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //feedback_ic

                                    GestureDetector(
                                      onTap: () {
                                        selectedIndex = 1;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 69,
                                        height: 69,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedIndex==1?Colors.white:Color(0xFFE5EBF2),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 13),
                                            Image.asset(
                                                'assets/assign_nav.png',
                                                width: 25,
                                                height: 25,
                                                color: selectedIndex == 1
                                                    ? Color(0xFF00407E)
                                                    : Color(0xFFA0B7CF)),

                                            Spacer(),
                                            Text('Assigned',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: selectedIndex ==
                                                        1
                                                        ? Color(0xFF00407E)
                                                        : Color(0xFF00407E).withOpacity(0.30))),


                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),



                                    GestureDetector(
                                      onTap: () {
                                        selectedIndex = 2;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 69,
                                        height: 69,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedIndex==2?Colors.white:Color(0xFFE5EBF2),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 13),
                                            Image.asset(
                                                'assets/feedback_ic.png',
                                                width: 25,
                                                height: 25,
                                                color: selectedIndex == 2
                                                    ? Color(0xFF00407E)
                                                    : Color(0xFFA0B7CF)),


                                            Spacer(),
                                            Text('Feedback',
                                                style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: selectedIndex ==
                                                        2
                                                        ? Color(0xFF00407E)
                                                        : Color(0xFF00407E).withOpacity(0.30))),


                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),


                                    GestureDetector(
                                      onTap: () {
                                        selectedIndex = 3;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 69,
                                        height: 69,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: selectedIndex==3?Colors.white:Color(0xFFE5EBF2),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 13),
                                            Image.asset(
                                                'assets/profile_nav.png',
                                                width: 25,
                                                height: 25,
                                                color: selectedIndex == 3
                                                    ? Color(0xFF00407E)
                                                    : Color(0xFFA0B7CF)),

                                            Spacer(),
                                            Text('Profile',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: selectedIndex ==
                                                        3
                                                        ? Color(0xFF00407E)
                                                        : Color(0xFF00407E).withOpacity(0.30))),

                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /* floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked,*/
                        ),
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    menuController = MEN.MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }
}

