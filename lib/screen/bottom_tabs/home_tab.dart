import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as MAP;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopperxm_flutter/screen/faq_term_and_condition/self_assign_screen.dart';
import 'package:shopperxm_flutter/screen/self_training/start_training_screen.dart';
import 'package:shopperxm_flutter/screen/view_map_screen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_theme.dart';
import '../audits/artifact_pending_audits.dart';
import 'package:flutter/services.dart' show rootBundle;
class HomeTab extends StatefulWidget {
  MenuState createState() => MenuState();
}

class MenuState extends State<HomeTab> {

  double lat=37.42796133580664;
  double long=-122.085749655962;


  List<dynamic> freelanceAuditList=[];
  String range="300";
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 10.4746,
  );
  int _index = 0;

  bool isLoading=false;
  List<MAP.Marker> _markers = <MAP.Marker>[];
  String Latitude_Str="75.8049537";
  String Longitude_Str="26.852436";
  List<String> kmList=[

    "50",
    "100",
    "150",
    "200",
    "250",
    "260",


  ];
  String? _mapStyle;
  GoogleMapController? mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 290,
            // transform: Matrix4.translationValues(0.0, -10.0, 0.0),
            child: GoogleMap(
              padding: EdgeInsets.zero,
              //mapType: MapType.hybrid,
              markers: Set<MAP.Marker>.of(_markers),
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                mapController=controller;
                mapController!.setMapStyle(_mapStyle);
                _controller.complete(controller);

              },
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: 170),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                    /*  InkWell(
                        onTap:(){
                          schedulePeriodicTask();
                       //   Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ViewMapScreen()));

                        },
                        child: Card(
                          child: Container(
                            height: 62,
                            width: 175,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/map_ic.png",
                                    width: 29.32, height: 26.65),
                                SizedBox(width: 10),
                                Text("View Map",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.orangeColor,
                                    )),
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),*/
                      Spacer(),
                      InkWell(
                        onTap: (){
                          filterBottomSheet(context);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.orangeColor),
                          child: Icon(Icons.filter_alt_sharp,
                              color: Colors.white, size: 32),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                   // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.6),
                          offset: const Offset(0.0, 5.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
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

                        freelanceAuditList.length!=0?

                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(freelanceAuditList.length.toString()+" Audits Available",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              )),
                        ):Container(),
                        SizedBox(height: 10),



                       Expanded(
                         child:
                         isLoading?

                             Center(
                               child: Loader(),
                             ):

                             freelanceAuditList.length==0?


                                 Center(
                                   child: Text("No Audits found!"),
                                 ):






                         ListView.builder(
                           itemCount: freelanceAuditList.length,
                             padding: const EdgeInsets.only(bottom: 70,top: 6),
                             shrinkWrap: true,
                             itemBuilder: (BuildContext context,int pos)
                         {
                           return Column(
                             children: [

                               Container(
                                // height: 274,
                                 width: double.infinity,
                                 padding: const EdgeInsets.symmetric(horizontal: 15),
                                 margin: const EdgeInsets.symmetric(horizontal: 4),
                                 decoration: BoxDecoration(
                                   color: Colors.white,
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
                                     SizedBox(
                                       width: 184, height: 41,
                                       child: Stack(
                                         children: [
                                           Image.asset("assets/rect.png",
                                               width: 184, height: 41),

                                           Padding(
                                             padding: const EdgeInsets.only(top: 10),
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [

                                                 Image.asset("assets/loc_3.png",
                                                     width: 16, height: 20),

                                                 SizedBox(width: 14),

                                                 Text(
                                                     getDistance(double.parse(freelanceAuditList[pos]["distance"].toString()))+

                                                         " Km",
                                                     style: TextStyle(
                                                       fontSize: 13,
                                                       fontWeight: FontWeight.w700,
                                                       color: Colors.white,
                                                     )),

                                               ],
                                             ),
                                           )


                                         ],
                                       ),
                                     ),
                                     SizedBox(height: 10),
                                     Row(
                                       children: [
                                         Column(
                                           children: [
                                            // Image.asset("assets/ola_ic.png"),
                                             SizedBox(height: 37),
                                             Image.asset("assets/loc_blue.png",
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
                                                   freelanceAuditList[pos]["store_name"],
                                                   style: TextStyle(
                                                     fontSize: 17,
                                                     fontWeight: FontWeight.w700,
                                                     color: Color(0xFF494F66),
                                                   ),maxLines: 1),
                                               Divider(),
                                               Text(
                                                   freelanceAuditList[pos]["store_address"],
                                                   style: TextStyle(
                                                     fontSize: 13,
                                                     fontWeight: FontWeight.w400,
                                                     color: Color(0xFF494F66),
                                                   ),maxLines: 2,),
                                             ],
                                           ),
                                         ),
                                       ],
                                     ),
                                     Divider(),
                                     Padding(
                                       padding: const EdgeInsets.symmetric(
                                           horizontal: 16, vertical: 5),
                                       child: Row(
                                         children: [
                                           Image.asset("assets/filter_ic.png",
                                               width: 16.53, height: 22.75),
                                           SizedBox(width: 27),
                                           Text("1 Hrs",
                                               style: TextStyle(
                                                 fontSize: 13,
                                                 fontWeight: FontWeight.w400,
                                                 color: Color(0xFF494F66),
                                               )),
                                           Spacer(),
                                           Image.asset("assets/calender_ic.png",
                                               width: 15, height: 15),
                                           SizedBox(width: 5),
                                           Text(parseServerFormatDate(freelanceAuditList[pos]["audit_date"].toString()),
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
                                       children: [
                                         Expanded(
                                             child: InkWell(
                                               onTap:(){
                                                 
                                                 
                                                 navigateTo(double.parse(freelanceAuditList[pos]["latitude"].toString()), double.parse(freelanceAuditList[pos]["longitude"].toString()));



                                              //   Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ViewMapScreen(freelanceAuditList[pos])));

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


                                                     Image.asset("assets/map_blue.png",width: 23.06,height: 20.96),

                                                     SizedBox(width: 20),


                                                     Text("View Map",
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
                                               onTap:() async {

                                            final data= await Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SelfAssignScreen(freelanceAuditList[pos]["store_id"].toString(),freelanceAuditList[pos]["beat_plan_id"].toString(),freelanceAuditList[pos]["des_document"])));
                                            if(data!=null)
                                              {
                                                getFreelanceAuditList(context);
                                              }



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

                                                     Text("Self Assign",
                                                         style: TextStyle(
                                                           fontSize: 13,
                                                           fontWeight: FontWeight.w600,
                                                           color: Colors.white,
                                                         )),


                                                     SizedBox(width: 10),

                                                     Image.asset("assets/assign2.png",width: 27,height: 27),


                                                   ],
                                                 ),
                                               ),
                                             ),flex: 1),
                                       ],
                                     ),

                                     SizedBox(height: 16),
                                   ],
                                 ),
                               ),

                               SizedBox(height: 15)


                             ],
                           );
                         }


                         ),
                       )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
  void selfAssignBottomSheet(BuildContext context) {
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

                       // Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SelfTrainingScreen()));







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

  void filterBottomSheet(BuildContext context) {
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

                    Padding(
                      padding: const EdgeInsets.only(left: 6,top: 10),
                      child: Text("Location Filter",
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
                        child: Image.asset("assets/cross_ic.png",width: 45,height: 45)),

                  ],
                ),


                SizedBox(height: 20),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  child: Row(
                    children: [


                      Image.asset("assets/loc_box.png",
                        width: 50,
                        height: 50,

                      ),

                      SizedBox(width: 15),


                      Text("Find Stores within Kms",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFf00407E),
                          ),textAlign: TextAlign.center),
                    ],
                  ),
                ),




                SizedBox(height: 20),

                SizedBox(
                  height: 100, // Card height
                  child: PageView.builder(
                    itemCount: kmList.length,
                    controller: PageController(viewportFraction: 1 / 3),
                    onPageChanged: (index) => bottomSheetState(() => _index = index),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn,
                          padding: EdgeInsets.all(_index == index ? 0.0 : 8.0),
                          child: Column(
                            children: [



                              Text(kmList[index],
                                  style: TextStyle(
                                    fontSize: _index==index? 38:24,
                                    fontWeight: FontWeight.w600,
                                    color: _index==index?Colors.black:Color(0xFF707070),
                                  )),


                              _index != index?Container():



                              _index != index?Container():
                              Text("Kms",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  )),



                            ],
                          )
                        ),
                      );
                    },
                  ),
                ),






                Card(
                  elevation: 4,
                  shadowColor:Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 11),
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

                        range=kmList[_index];

                        Navigator.pop(context);

                        getFreelanceAuditList(context);









                      },
                      child: const Text(
                        'Apply',
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
     CameraPosition currentLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, long),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    await controller.animateCamera(CameraUpdate.newCameraPosition(currentLocation));
  }


  getFreelanceAuditList(BuildContext context) async {
   setState(() {
     isLoading=true;
   });
    var data = {
      /*"latitude":Latitude_Str,
      "longitude": Longitude_Str,*/
      "min_distance": range,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getFreelanceAuditList', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
   setState(() {
     isLoading=false;
   });

   freelanceAuditList=responseJSON["data"];
   setState(() {

   });



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      print("File loaded");
      _mapStyle = string;
    });
    fetchUserCurrentLocation();
    getFreelanceAuditList(context);
  }
  String getDistance(double distance)
  {
    double distanceAsInt=distance/1000;
    int dis=distanceAsInt.toInt();
    return dis.toString();

  }


  fetchUserCurrentLocation() async {
    await Permission.location.request();

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=null)
      {
        print("CURRENT LOCATION");
        print(position.latitude.toString());
        print(position.longitude.toString());
        lat=position.latitude;
        long=position.longitude;
        Latitude_Str=position.latitude.toString();
        Longitude_Str=position.longitude.toString();

        _markers.add(
            MAP.Marker(
                markerId: MarkerId('SomeId'),
                position: LatLng(position.latitude,position.longitude),
               /* infoWindow: InfoWindow(
                    title: 'The title of the marker'
                )*/
            )
        );




        setState(() {

        });
        _goToTheLake();
      }


  }

  void schedulePeriodicTask() {
    Workmanager().registerPeriodicTask(
    'myPeriodicTask',
    'simplePeriodicTask',
    frequency: Duration(hours: 1),
    inputData: <String, dynamic>{'key': 'value'},
    );
  }
  String parseServerFormatDate(String serverDate) {
    var date = DateTime.parse(serverDate);
    final dateformat = DateFormat.yMd();
    final clockString = dateformat.format(date);
    return clockString.toString();
  }


  void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(Uri.parse(uri.toString()))) {
      await launchUrl(Uri.parse(uri.toString()));
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
