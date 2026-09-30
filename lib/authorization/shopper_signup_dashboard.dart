import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopperxm_flutter/authorization/shopper_signup_kyc_screen.dart';
import 'package:shopperxm_flutter/authorization/shopper_signup_payment_detail_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/aws_config.dart';

class ShopperSignupDashboardScreen extends StatefulWidget {
  @override
  _ShopperSignupDashboardScreenState createState() =>
      _ShopperSignupDashboardScreenState();
}

class _ShopperSignupDashboardScreenState
    extends State<ShopperSignupDashboardScreen> {

  String authKey = "", userId = "", emailStr = "", shoppersOverallStatus = "";
  String latitudeStr = "0.0";
  String longitudeStr = "0.0";

  double totalAuditValue = 0.0;

  List storeLocationList = [];
  List<dynamic> auditList = [];

  GoogleMapController? mapController;
  Set<Marker> markers = {};

  BitmapDescriptor? userIcon;
  BitmapDescriptor? storeIcon;

  String paymentMessage = "Please complete your bank details and KYC verification steps to perform the audit.";
  String kycDetailsMessage = "Please complete your bank details and KYC verification steps to perform the audit.";

  String permissionMessage =
      "To provide you with the best experience and access location-based features, \n"
      "this app requires permission to access your device’s location.\n"
      "We use your location to: Show near by Services \n"
      "Please enable location access in your device settings to continue.";

  @override
  void initState() {
    super.initState();
    initIcons();
    getUserDetails();
    getLocationCall();
    getAwsDetails();
  }

  // ================= ICON =================

  Future<void> initIcons() async {
    userIcon = await loadIcon("assets/user_pin.png");
    storeIcon = await loadIcon("assets/store_pin.png");
  }

  Future<BitmapDescriptor> loadIcon(String path) async {
    final data = await rootBundle.load(path);
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  // ================= PERMISSION =================

  Future<void> getLocationCall() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // First time ask
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Toast.show("Permission Denied!!!");
        showPermissionDialog();
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Same as "Don't ask again"
      showPermissionDialog();
      return;
    }
    getLocationUpdate();
  }

  void showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("Location Permission Required"),
        content: Text(permissionMessage),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openAppSettings();
              Navigator.pop(context);
            },
            child: Text("Go To Settings"),
          )
        ],
      ),
    );
  }

  // ================= LOCATION =================

  Future<void> getLocationUpdate() async {
    Position? position = await Geolocator.getLastKnownPosition();

    if (position != null) {
      latitudeStr = position.latitude.toString();
      longitudeStr = position.longitude.toString();
    }

    getAuditListFromServer();
  }

  // ================= USER =================

  void getUserDetails() async {
    authKey = await MyUtils.getSharedPreferences("access_token") ?? "";
    userId = await MyUtils.getSharedPreferences("user_id") ?? "";
    emailStr = await MyUtils.getSharedPreferences("email") ?? "";
    shoppersOverallStatus = await MyUtils.getSharedPreferences("shopper_overall_status") ?? "";
    print("shopper overall status: $shoppersOverallStatus");

    setState(() {});
  }

  // ================= API =================

  void getAuditListFromServer() async {
    getFreelanceAuditList();
  }

  Future<void> getFreelanceAuditList() async {
    APIDialog.showAlertDialog(context, "Loading...");

    var data = {
      "latitude": latitudeStr,
      "longitude": longitudeStr,
      "min_distance": "1000"
    };

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader("get/freelancer/all/audit/list", data, context);

    Navigator.pop(context);

    var jsonResponse = json.decode(response.body);

    if (jsonResponse["status"] == 1) {

      auditList.clear();
      storeLocationList.clear();
      totalAuditValue = 0.0;

      auditList = jsonResponse["data"];

      for (int i = 0; i < auditList.length; i++) {
        var jn = auditList[i];

        String price = jn["price"].toString();

        if (price != "null" && price.isNotEmpty) {
          totalAuditValue += int.parse(price);
        }

        storeLocationList.add({
          "lat": jn["latitude"],
          "lng": jn["longitude"],
        });
      }

      addStoreMarker();

    } else {
      Toast.show(jsonResponse["message"], backgroundColor: Colors.red);
    }
  }

  // ================= MAP =================

  void addStoreMarker() {
    markers.clear();

    double userLat = double.tryParse(latitudeStr) ?? 0.0;
    double userLng = double.tryParse(longitudeStr) ?? 0.0;

    // USER MARKER
    markers.add(
      Marker(
        markerId: MarkerId("user"),
        position: LatLng(userLat, userLng),
        infoWindow: InfoWindow(title: "You"),
        icon: userIcon ?? BitmapDescriptor.defaultMarker,
      ),
    );

    for (int i = 0; i < storeLocationList.length; i++) {
      double lat = double.tryParse(storeLocationList[i]["lat"]) ?? 0.0;
      double lng = double.tryParse(storeLocationList[i]["lng"]) ?? 0.0;

      if (lat != 0.0 && lng != 0.0) {
        markers.add(
          Marker(
            markerId: MarkerId("store_$i"),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: "Store"),
            icon: storeIcon ?? BitmapDescriptor.defaultMarker,
          ),
        );
      }
    }

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLat, userLng),
          zoom: 7,
          tilt: 45,
          bearing: 0,
        ),
      ),
    );

    setState(() {});
  }

  // ================= AWS =================

  Future<void> getAwsDetails() async {
    ApiBaseHelper helper = ApiBaseHelper();

    var response = await helper.postAPIWithHeader(
        "s3/details", {}, context);

    var jsonResponse = json.decode(response.body);

    if (jsonResponse["status"] == true) {

      print(jsonResponse);
      final config = AwsConfig.fromJson(
        jsonResponse["data"] as Map<String, dynamic>?,
      );
      await MyUtils.saveAwsDetails(
          region: config.region,
          bucket: config.bucket,
          baseUrl: config.baseUrl,
          storeImgPath: config.uploadPath,
          storeSelfiePath: config.selfiePath,
          audioPath: config.audio,
          videoPath: config.video,
          imgPath: config.img,
          transactionPath: config.transaction,
          key: config.key,
          secret: config.secret);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: SafeArea(child: Column(
        children: [

          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: markers,
              myLocationEnabled: true,
            ),
          ),

          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Text("${auditList.length}",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: AppTheme.orangeColor),),
                      const Text("Total Audits",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Text("₹ $totalAuditValue",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: AppTheme.orangeColor),),
                      const Text("Total Value",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)

                    ],
                  ),
                ),
              ),
            ],
          ),

          Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                shoppersOverallStatus == "2"
                    ? paymentMessage
                    : kycDetailsMessage,
              ),
            ),
          ),

          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
          child:ElevatedButton(
            onPressed: () {
              if (shoppersOverallStatus == "2") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopperSignupPaymentInfoScreen(),
                  ),
                );
              } else if (shoppersOverallStatus == "3") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  ShopperSignupKycScreen(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.themeColor,
              foregroundColor: Colors.white, // text color
              minimumSize: const Size(double.infinity, 50), // full width + height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),

            child: Text(shoppersOverallStatus == "2"?"Complete Payment Info":"Complete KYC Details"),
          ) ,),
          SizedBox(height: 20,),
        ],
      )),
    );
  }
}