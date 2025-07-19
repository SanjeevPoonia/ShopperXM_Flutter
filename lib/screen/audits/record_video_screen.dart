import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/audits/tagged_audits.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:video_player/video_player.dart';
import 'package:workmanager/workmanager.dart';



class RecordVideoScreen extends StatefulWidget {
  String storeCode = '';
  String storeName = '';
  String storeAddress = '';
  String storeID = '';
  RecordVideoScreen(this.storeCode,this.storeName,this.storeAddress,this.storeID);

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<RecordVideoScreen> {
  int selectedRadioIndex=9999;
  int selectedIndex=9999;
  String recordingTime = '0:0';
  int fileCount=0;
  bool recording=false;
  Timer? _timer;
  int _start = 0;
  double cameraZoom = 1.0;
  CameraController? controller;
  CameraDescription? camera;
  List<CameraDescription> cameras = [];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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


                    Text("Record Video",
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

            SizedBox(height: 5),


            Container(
              //height: 274,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.symmetric(horizontal: 13),
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

                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Image.asset("assets/ola_ic.png",
                              width: 30, height: 30),
                          SizedBox(height: 15),


                          Image.asset("assets/home_clock.png",
                              width: 22.29, height: 27.85),
    SizedBox(height: 5),
                          Divider(),
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
                                widget.storeCode,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF494F66),
                                )),
                            Divider(),


                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                  widget.storeName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                            ),
                            Divider(),

                            Text(
                                widget.storeAddress==""?"NA":widget.storeAddress,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF494F66),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20)
                ],
              ),
            ),

            Spacer(),

         /*   controller == null || !controller!.value.isInitialized
                ? Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.all(5),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                      AlwaysStoppedAnimation(Colors.blue),
                    ),
                  ),
                  SizedBox(width: 5),

                  Text(
                    'Loading camera',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
                : Container(
              width: 320,
              margin: EdgeInsets.only(
                  left: 20, right: 20, top: 20),
              height: 400,
              child:
              _controller!=null?

              Chewie(controller: chewieController!):Container()




              *//*CameraPreview(controller!),*//*
            ),*/



            recording?

            GestureDetector(
              onTap: ()async{
                _timer!.cancel();
                setState(() {

                });
                recording=false;
                XFile videoPath=  await controller!.stopVideoRecording();
                print(videoPath.path.toString());
                storeDataLocally(videoPath.path.toString());
                fileCount=fileCount+1;
                setState(() {

                });
              },
              child: Container(
                height: 48,
                margin: EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.red
                ),


                child: Row(
                  children: [

                    SizedBox(width: 10),

                    Text('Stop Recording',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),

                    Spacer(),

                    Text(formattedTime(timeInSecond: _start),
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ):Container(),

            SizedBox(height: 8),

            !recording?



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
                  onPressed: () async{

                    final status = await AirplaneModeChecker.instance.checkAirplaneMode();

                    if (status == AirplaneModeStatus.on) {
                      if(!recording)
                      {
                        setState(() {
                          recording=true;
                        });

                        await controller!.startVideoRecording();
                        _start=0;



                       _timer= Timer.periodic(const Duration(seconds: 1), (Timer t) {

                         _start++;

                          setState(() {});
                        });





                      }
                      else{



                      }
                    } else {
                      Toast.show("NOTE : Please turn on Airplane Mode before start Recording",
                          duration: Toast.lengthLong,
                          gravity: Toast.bottom,
                          backgroundColor: Colors.red);
                     // AppSettings.openAppSettingsPanel(AppSettingsPanelType.internetConnectivity);
                      AppSettings.openAppSettings(type: AppSettingsType.wireless);
                    }





                 //   Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp22()));




                  },
                  child:  Text(!recording?
                    'Start Recording':'Stop Recording',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ):Container(),

            !recording?

            SizedBox(height: 11):Container(),




            fileCount==0?Container():



            Card(
              elevation: 4,
              shadowColor:Colors.grey,
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 48,
                color: Colors.white,
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(
                            Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side: BorderSide(color: AppTheme.themeColor)
                            )
                        )
                    ),
                  onPressed: () {

                      if(fileCount==0)
                        {
                          Toast.show("Please record at least one video!",
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red);
                        }

                      else
                        {

                          Navigator.pop(context);
                        }




                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.themeColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),


            SizedBox(height: 20),






          ],
        )
      ),
    );
  }

  fetchLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString("file_list");
    print("Data");
    print(data.toString());
    List<dynamic> list2 = jsonDecode(data!);
    print(list2.toString());
    setState(() {

    });
  }

  storeDataLocally(String filePath) async {
    print("File REce "+filePath);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString("file_list");
    List<dynamic> list2;
    if(data==null)
      {
        list2=[];
      }
    else
      {
        list2 = jsonDecode(data);
      }



    list2.add({
      "id":widget.storeID,
      "path":filePath
    });
    String json = jsonEncode(list2);
    await preferences.setString('file_list',json);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCameras();
    fetchLocalData();
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

                    Text("Select Search Category",
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
                    itemCount: 4,
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
                                child: Text("Client Name",
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


                      },
                      child: const Text(
                        'Save',
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
  initializeCamera() async {
    print("Camera Triggered");
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }
  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }
  Future<void> getCameras() async {
    try {
      cameras = await availableCameras();
      initializeCamera();
    } catch (e) {
      print(e);
    }
    camera = cameras.last;
    print(camera);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }
}
