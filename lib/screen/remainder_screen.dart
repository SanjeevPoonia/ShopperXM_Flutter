import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';

import '../../utils/app_theme.dart';
import 'audits/pending_audits.dart';

class RemainderScreen extends StatefulWidget {
  MenuState createState() => MenuState();
}

class MenuState extends State<RemainderScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


  SwiperController controller=SwiperController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              // transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              child: GoogleMap(
                padding: EdgeInsets.zero,
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Container(
              child: Column(
                children: [

                  SizedBox(height: 10),




                  Text("Remainders",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),textAlign: TextAlign.center),


                  SizedBox(
                    height: 150,
                    child: OverflowBox(
                      minHeight: 170,
                      maxHeight: 170,
                      child:  Lottie.asset("assets/remainder_anim.json"),
                    ),
                  ),





                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.only(topLeft: Radius.circular(56),topRight: Radius.circular(56)),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black12.withOpacity(0.3),
                               offset: const Offset(0.0, 5.0),
                               blurRadius: 6.0,
                             ),
                           ],
                         ),
                         child: Column(
                           children: [




                             SizedBox(height: 30),


                             Text("Lorem Ipsum Simply\nText here",
                                 style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.w700,
                                   color: Colors.black,
                                 ),textAlign: TextAlign.center),

                             SizedBox(height: 5),
                             Text("Lorem Ipsum is simply dummy text of the printing and",
                                 style: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Color(0xFF707070),
                                 ),textAlign: TextAlign.center,),

                             SizedBox(height: 10),

                             Container(
                               height: 281,
                               child: Swiper(
                                 controller: controller,
                                 itemBuilder: (context, index) {
                                   return Column(
                                     children: [
                                       Container(
                                         //height: 274,
                                         width: double.infinity,
                                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                         margin: EdgeInsets.symmetric(horizontal: 13),
                                         decoration: BoxDecoration(
                                           color: Color(0xFFE4EBF5),
                                           borderRadius: BorderRadius.circular(10),
                                           boxShadow: [
                                             BoxShadow(
                                               color: Colors.black12.withOpacity(0.3),
                                               offset: const Offset(0.0, 5.0),
                                               blurRadius: 6.0,
                                             ),
                                           ],
                                         ),
                                         child: Column(
                                           children: [
                                             SizedBox(height: 5),
                                             Row(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Column(
                                                   children: [
                                                     Image.asset("assets/ola_ic.png",width: 45,height: 45),
                                                     SizedBox(height: 15),


                                                     Image.asset("assets/home_clock.png",
                                                         width: 22.29, height: 27.85),



                                                   ],
                                                 ),
                                                 SizedBox(width: 15),
                                                 Expanded(
                                                   child: Column(
                                                     crossAxisAlignment:
                                                     CrossAxisAlignment.start,
                                                     children: [
                                                       Text(
                                                           "VS_RAJ_0021 (Vodaphone idea Ltd.)",
                                                           style: TextStyle(
                                                             fontSize: 15,
                                                             fontWeight: FontWeight.w700,
                                                             color: Color(0xFF494F66),
                                                           )),
                                                       Divider(),


                                                       Padding(
                                                         padding: const EdgeInsets.symmetric(vertical: 8),
                                                         child: Text(
                                                             "Vi Store Silver Jublee Road",
                                                             style: TextStyle(
                                                               fontSize: 13,
                                                               fontWeight: FontWeight.w600,
                                                               color: Colors.black,
                                                             )),
                                                       ),



                                                     ],
                                                   ),
                                                 ),
                                               ],
                                             ),


                                             Divider(),
                                             Row(
                                               children: [
                                                 SizedBox(width: 15),
                                                 Image.asset("assets/loc_blue.png",
                                                     width: 22.29, height: 27.85),
                                                 SizedBox(width: 25),
                                                 Expanded(
                                                   child: Text(
                                                       "B-9, 1st Floor, Mahalaxmi Nagar Rd, behind WTP",
                                                       style: TextStyle(
                                                         fontSize: 13,
                                                         fontWeight: FontWeight.w400,
                                                         color: Color(0xFF494F66),
                                                       )),
                                                 ),

                                                 SizedBox(width: 8),
                                               ],
                                             ),


                                             Divider(),
                                             Padding(
                                               padding: const EdgeInsets.symmetric(
                                                   horizontal: 5, vertical: 5),
                                               child: Row(
                                                 children: [
                                                   SizedBox(width: 12),
                                                   Image.asset("assets/filter_ic.png",
                                                       width: 16.53, height: 22.75),
                                                   SizedBox(width: 27),
                                                   Text("1 Hrs",
                                                       style: TextStyle(
                                                         fontSize: 13,
                                                         fontWeight: FontWeight.w400,
                                                         color: Color(0xFF494F66),
                                                       )),
                                                   SizedBox(width: 15),
                                                   Image.asset("assets/calender_ic.png",
                                                       width: 15, height: 15),
                                                   SizedBox(width: 10),
                                                   Text("2023-02-23",
                                                       style: TextStyle(
                                                         fontSize: 13,
                                                         fontWeight: FontWeight.w400,
                                                         color: Color(0xFF494F66),
                                                       )),

                                                   SizedBox(width: 15),
                                                   Image.asset("assets/loc_blue.png",
                                                       width: 18, height: 18),
                                                   SizedBox(width: 10),
                                                   Text("12 Km",
                                                       style: TextStyle(
                                                         fontSize: 13,
                                                         fontWeight: FontWeight.w400,
                                                         color: Color(0xFF494F66),
                                                       )),
                                                 ],
                                               ),
                                             ),

                                             SizedBox(height: 10),



                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [


                                                Image.asset("assets/orange_filter.png",width: 25,height: 25),

                                                SizedBox(width: 5),

                                                Text("2 Days remaining",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppTheme.orangeColor,
                                                    )),

                                              ],
                                            ) ,

                                             SizedBox(height: 15)
                                           ],
                                         ),
                                       ),

                                       SizedBox(height: 10)
                                     ],
                                   );
                                 },
                                 itemCount: 10,
                                 //layout: SwiperLayout.STACK,
                                 scrollDirection: Axis.vertical,
                                 // pagination: const SwiperPagination(alignment: Alignment.centerRight),
                                 //control: const SwiperControl(),
                               ),
                             ),

                             SizedBox(height: 10),


                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [

                                 InkWell(
                                   child: Container(
                                     height: 53,
                                     width: 53,
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       shape: BoxShape.circle,
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.black12.withOpacity(0.3),
                                           offset: const Offset(0.0, 5.0),
                                           blurRadius: 6.0,
                                         ),
                                       ],
                                     ),
                                     child: Center(
                                       child: Image.asset("assets/arrow_down.png",width: 32,height: 32),
                                     ),
                                   ),
                                   onTap: (){
                                     controller.next(animation: true);
                                     setState(() {

                                     });
                                   },
                                 ),



                                 SizedBox(width: 55),



                                 InkWell(
                                   onTap: (){
                                     controller.previous(animation: true);
                                     setState(() {

                                     });
                                   },
                                   child: Container(
                                     height: 53,
                                     width: 53,
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       shape: BoxShape.circle,
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.black12.withOpacity(0.3),
                                           offset: const Offset(0.0, 5.0),
                                           blurRadius: 6.0,
                                         ),
                                       ],
                                     ),
                                     child: Center(
                                       child: Image.asset("assets/arrow_up.png",width: 32,height: 32),
                                     ),
                                   ),
                                 )

                               ],
                             ),
                             SizedBox(height: 15),

                             InkWell(
                               onTap: (){
                                 Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: LandingScreen()));

                               },
                               child: Container(
                                 height:48,
                                 width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 14),
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

                                 child: Center(
                                   child:    Text("Dashboard",
                                       style: TextStyle(
                                         fontSize: 13,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.white,
                                       )),
                                 )
                               ),
                             ),


                           ],
                         ),
                                         ),


                        Container(
                          transform: Matrix4.translationValues(0.0, -27.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color:AppTheme.orangeColor,
                                  shape: BoxShape.circle
                                ),
                                child: Center(
                                  child: Image.asset("assets/calender.png",color: Colors.white,),
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  )








                ],
              ),
            )
          ],
        ),

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

                    Text("Start Training",
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
                  height: 170,
                  child: OverflowBox(
                    minHeight: 170,
                    maxHeight: 170,
                    child:  Lottie.asset("assets/training_anim.json"),
                  ),
                ),


                SizedBox(height: 15),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Text("You haven't completed training for the selected process please complete training to self assign the available audits.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFf708096),
                      ),textAlign: TextAlign.center),
                ),




                SizedBox(height: 15),



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
                        'Begin Training',
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
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
