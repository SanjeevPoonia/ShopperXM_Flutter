import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_theme.dart';

class ViewMapScreen extends StatefulWidget {
  final Map<String,dynamic> auditData;
  ViewMapScreen(this.auditData);
  MenuState createState() => MenuState();
}

class MenuState extends State<ViewMapScreen> {
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


                  Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 10),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                    ),
                    child: Container(
                      height: 69,
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);

                              },
                              child:Icon(Icons.keyboard_backspace_rounded)),


                          Text("OLA Experience....",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              )),

                          Image.asset("assets/bell_ic.png",width: 23,height: 23)


                        ],
                      ),
                    ),
                  ),

                  Spacer(),

                  Container(
                    height: 350,
                    child: Column(
                      children: [

                        Container(

                          width: double.infinity,
                          color: Color(0xFFFF7C00),

                          child: Column(
                            children: [

                              SizedBox(height: 20),

                              Text("OLA Experience Center\n Peramangalam",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),textAlign: TextAlign.center),


                              SizedBox(height: 15),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(left:10),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 40,
                                          margin: const EdgeInsets.only(left:10),
                                          padding: EdgeInsets.all(10),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.83)


                                          ),

                                          child: Center(
                                            child: Image.asset("assets/filter_ic.png"),
                                          ),
                                        ),
                                        SizedBox(height: 4),


                                        Text("1 Hrs",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withOpacity(0.70),
                                            )),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        margin: const EdgeInsets.only(left:10),
                                        padding: EdgeInsets.all(15),
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.83)


                                        ),

                                        child: Center(
                                          child: Image.asset("assets/loc_orange.png"),
                                        ),
                                      ),
                                      SizedBox(height: 4),


                                      Text("12 Kms",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        padding: EdgeInsets.all(10),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.83)


                                        ),

                                        child: Center(
                                          child: Image.asset("assets/calender_ic.png"),
                                        ),
                                      ),
                                      SizedBox(height: 4),


                                      Text("2023-02-23",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withOpacity(0.70),
                                          )),
                                    ],
                                  )

                                ],
                              ),

                              SizedBox(height: 12),

                            ],
                          ),


                        ),

                        Expanded(
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              children: [


                                SizedBox(height: 5),

                                Text("Address",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    )),

                                SizedBox(height: 10),


                                Padding(padding: EdgeInsets.symmetric(horizontal: 13),
                                child:   Row(
                                  children: [
                                    Container(
                                      width: 54,
                                      padding: EdgeInsets.all(15),
                                      height: 54,
                                      decoration: BoxDecoration(
                                          color: AppTheme.themeColor.withOpacity(0.10),
                                          borderRadius: BorderRadius.circular(5.83)


                                      ),

                                      child: Center(
                                        child: Image.asset("assets/loc_blue.png"),
                                      ),
                                    ),

                                    SizedBox(width: 12),
                                    
                                    Expanded(child:  Text("B-9, 1st Floor, Mahalaxmi Nagar Rd, behind WTP, South Block, Malviya Nagar, Jaipur, Rajasthan 302017",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFf808080),
                                        )),
                                    )
                                  ],
                                ),

                                ),

                                SizedBox(height: 22),


                                Container(
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

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 28),

                                      Text("Self Assign",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )),




                                      Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: Image.asset("assets/assign2.png",width: 27,height: 27),
                                      ),


                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),

                              ],
                            ),
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
