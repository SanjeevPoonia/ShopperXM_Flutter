import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as MAP;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';

class AuditIntroScreen extends StatefulWidget {
  final String storeID;
  final String storeName;
  AuditIntroScreen(this.storeID,this.storeName);
  MenuState createState() => MenuState();
}

class MenuState extends State<AuditIntroScreen> {
  String Latitude_Str="75.7835492";
  String Longitude_Str="26.9111319";
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  int selectedIndex=9999;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String? _mapStyle;

  List<String> statusList=[
    "Open",
    "Closed",
    "Not Found"
  ];
  GoogleMapController? mapController;
  double lat=37.42796133580664;
  double long=-122.085749655962;

  bool isChecked = false;
  XFile? frontAadharImage;
  XFile? backAadharImage;
  bool scrollStart = false;
  List<MAP.Marker> _markers = <MAP.Marker>[];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              height: 320,
              // transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              child: GoogleMap(
                padding: EdgeInsets.zero,
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


                          Text("TAG Store",
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
                    height: 427,
                    child: Column(
                      children: [

                        Container(

                          width: double.infinity,
                          color: Color(0xFFFF7C00),

                          child: Column(
                            children: [

                              SizedBox(height: 20),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(widget.storeName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),textAlign: TextAlign.center),
                              ),


                              SizedBox(height: 15),




                            ],
                          ),


                        ),

                        Expanded(
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                SizedBox(height: 10),



                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 13),
                                  child: Text("Select Store Status",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: AppTheme.themeColor,
                                      )),
                                ),

                                SizedBox(height: 10),

                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 13),
                                  height: 36,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Text(selectedIndex==9999?"Select Status":statusList[selectedIndex],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              )),

                                          Spacer(),

                                          InkWell(
                                            onTap: (){
                                              selectCategoryBottomSheet(context);
                                            },
                                            child: Text("Select",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppTheme.themeColor,
                                                )),
                                          ),


                                        ],
                                      ),

                                      Spacer(),

                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 2),
                                        child: Divider(
                                          color: Color(0xFF8C8C8C),
                                        ),
                                      ),






                                    ],
                                  ),
                                ),


                                SizedBox(height: 15),



                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 13),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      frontAadharImage != null
                                          ? Expanded(
                                          child: _buildFileImageView(
                                              frontAadharImage))
                                          : Expanded(
                                        child: _buildImageView(
                                          'assets/demo_img.png',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      backAadharImage != null
                                          ? Expanded(
                                          child: _buildFileImageView(
                                              backAadharImage))
                                          : Expanded(
                                        child: _buildImageView(
                                            'assets/demo_img.png'),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 13),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            'Capture Store Image',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12, color: Color(0xFF00376A)),
                                          )),
                                      Expanded(
                                          child: Text(
                                            'Capture Selfie with Store',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12, color: Color(0xFF00376A)),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 13),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            _fetchFrontImage(context);
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 30, right: 30),
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFF8500),
                                                  borderRadius:
                                                  BorderRadius.circular(5)),
                                              height: 30,
                                              child: const Center(
                                                child: Text('Upload',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white)),
                                              )),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            _fetchBackImage(context);
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 30, right: 30),
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFFF8500),
                                                  borderRadius:
                                                  BorderRadius.circular(5)),
                                              height: 30,
                                              child: const Center(
                                                child: Text('Upload',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white)),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 22),


                                InkWell(
                                  onTap: (){
                                    validateData();
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

                                    child:   Center(
                                      child: Text("Submit",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )),
                                    ),

                                  ),
                                ),
                                SizedBox(height: 13),

                              ],
                            ),
                          ),
                        )

                      ],
                    ),



                  ),







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
    CameraPosition currentLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, long),
        tilt: 59.440717697143555,
        zoom: 13.151926040649414);
    await controller.animateCamera(CameraUpdate.newCameraPosition(currentLocation));
  }
  void selectCategoryBottomSheet(BuildContext context) {
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


                  children: [
                    SizedBox(width: 10),

                    Text("Select Store Status",
                        style: TextStyle(
                          fontSize: 17,
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

                ListView.builder(
                    shrinkWrap: true,
                    itemCount: statusList.length,
                    itemBuilder: (BuildContext context,int pos)
                    {
                      return InkWell(
                        onTap: (){
                          bottomSheetState(() {
                            selectedIndex=pos;
                          });
                        },
                        child: Container(
                          height: 57,
                          color: selectedIndex==pos?Color(0xFFFF7C00).withOpacity(0.10):Colors.white,
                          child: Row(
                            children: [

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(statusList[pos],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    }


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
                    height: 53,
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

                        if(selectedIndex!=9999)
                          {
                            Navigator.pop(context);
                            setState(() {

                            });
                          }


                      },
                      child: const Text(
                        'Apply',
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

  Widget _buildImageView(String imagePath) {
    return Container(
      height: 100,
      color: Color(0xFFEFEFEF),
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        child: Center(
          child: Image.asset(
            imagePath,
            opacity: const AlwaysStoppedAnimation(.3),
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  validateData(){
    if(selectedIndex==9999)
      {
        Toast.show("Please select store status!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    else if(frontAadharImage==null)
      {
        Toast.show("Please upload store image!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    else if(backAadharImage==null)
      {
        Toast.show("Please upload selfie with store!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    else
      {
        submitTAGStore(context);
      }

  }





  submitTAGStore(BuildContext context) async {

   String storeImageAsBase64="";
   String selfieImageAsBase64="";

   File file1 = File(frontAadharImage!.path);

   List<int> imageBytes = file1.readAsBytesSync();

   storeImageAsBase64=base64Encode(imageBytes);


   File file2 = File(backAadharImage!.path);

   List<int> imageBytes2 = file2.readAsBytesSync();

   selfieImageAsBase64=base64Encode(imageBytes2);



    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please wait...');
    var data = {
     "new_tagging":"1",
     "user_id":AppModel.userID,
     "store_id":widget.storeID,
     "lattitude":Latitude_Str,
     "longitude":Longitude_Str,
     "store_status":selectedIndex.toString(),
     "store_str":storeImageAsBase64,
     "selfie_str":selfieImageAsBase64,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('addTagging', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

       Navigator.pop(context);



    } else {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }



  Widget _buildFileImageView(XFile? image) {
    return Container(
      height: 100,
      color: Color(0xFFEFEFEF),
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        child: Center(
          child: Image.file(
            File(image!.path),

            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  _fetchFrontImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      frontAadharImage = image;
      setState(() {});
    }
  }

  _fetchBackImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      backAadharImage = image;
      setState(() {});
    }
  }

  fetchUserCurrentLocation() async {
    await Permission.location.request();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=null)
    {
      print("CURRENT LOCATION");
      print(position.latitude.toString());
      print(position.longitude.toString());
      Latitude_Str=position.latitude.toString();
      Longitude_Str=position.longitude.toString();
      lat=position.latitude;
      long=position.longitude;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      print("File loaded");
      _mapStyle = string;
    });
    fetchUserCurrentLocation();
  }
}
