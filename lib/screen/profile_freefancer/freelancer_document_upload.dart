import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shopperxm_flutter/screen/landing_screen.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';


class FreelancerDocumentScreen extends StatefulWidget {
  FreelancerDocumentState createState() => FreelancerDocumentState();
}

class FreelancerDocumentState extends State<FreelancerDocumentScreen> {
  var userAccountNoController = TextEditingController();
  var userNameController = TextEditingController();
  var userIfscController = TextEditingController();
  var panCardCodeController = TextEditingController();
  bool isChecked = false;
  bool scrollStart = false;
  ScrollController _scrollController =  ScrollController();
  int selectedRadio = 0;
  bool _isVisible = true;
  bool isLoading=false;
  XFile? aadharImage;
  XFile? passportFrontImage;
  XFile? passportBackImage;
  XFile? drivingLicenseImage;
  String aadharImageURL="";
  String passportFrontImageURL="";
  String passportBackImageURL="";
  String drivingImageURL="";
  @override

  void _toggleContainer() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: "RobotoFlex",

      ),
      home: Scaffold(
        body:
        Column(
          // padding: EdgeInsets.zero,
          children: [
            Container(
                height: 110,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),  // Set the radius for bottom-left corner
                    bottomRight: Radius.circular(20.0),
                    // Set the radius for bottom-right corner
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

                child:   Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    children: [

                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/back_arrow.png", width: 20,
                            height: 20),
                      ),
                      Expanded(
                          child:Text("Documents",textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black))),

                      SizedBox(width: 10),
                    ],
                  ),
                )),
            Expanded(
              child:

              isLoading?

                  Center(
                    child: Loader(),
                  ):


              Stack(
                children: [
                  NotificationListener(
                      child: ListView(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20,right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.only(left: 4,right: 4,top: 6,bottom: 6),
                                  // color: Color(0xFFF3F3F3),
                                  child: Column(
                                    children: [

                                      Row(
                                        children: [
                                          Text('Aadhar Card',textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF00376A)
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [


                                          aadharImage!=null?
                                          Expanded(child: _buildFileImageView(aadharImage!))
                                         :

                                          aadharImageURL!=""?
                                          Expanded(child: _buildNetworkImageView(aadharImageURL))

                                        :




                                          Expanded(child: _buildImageView('assets/demo_img.png')),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _fetchAadharImage(context);

                                            },
                                            child: Container(
                                                width:110,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFF8500),
                                                    borderRadius: BorderRadius.circular(5)),
                                                height: 35,
                                                child: const Center(
                                                  child: Text('Upload',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white)),
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Text('Passport',textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF00376A)
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [






                                          passportFrontImage!=null?
                                          Expanded(child: _buildFileImageView(passportFrontImage!))
                                              :

                                          passportFrontImageURL!=""?
                                          Expanded(child: _buildNetworkImageView(passportFrontImageURL))

                                              :




                                          Expanded(child: _buildImageView('assets/demo_img.png')),

                                          SizedBox(width: 16),
                                          passportBackImage!=null?
                                          Expanded(child: _buildFileImageView(passportBackImage!))
                                              :

                                          passportBackImageURL!=""?
                                          Expanded(child: _buildNetworkImageView(passportBackImageURL))

                                              :




                                          Expanded(child: _buildImageView('assets/demo_img.png')),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(child: Text('Front Side',textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF00376A)
                                            ),
                                          )),
                                          Expanded(child: Text('Back Side',textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF00376A)
                                            ),
                                          )),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(child: InkWell(
                                            onTap: () {
                                              _fetchPassportFrontImage(context);

                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(left: 30,right: 30),

                                                width: 100,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFF8500),
                                                    borderRadius: BorderRadius.circular(5)),
                                                height: 30,
                                                child: const Center(
                                                  child: Text('Upload',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white)),
                                                )),
                                          ),),
                                          Expanded(child: InkWell(
                                            onTap: () {
                                              _fetchPassportBackImage(context);

                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(left: 30,right: 30),
                                                width:100,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFF8500),
                                                    borderRadius: BorderRadius.circular(5)),
                                                height: 30,
                                                child: const Center(
                                                  child: Text('Upload',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white)),
                                                )),
                                          ),),
                                        ],
                                      ),
                                      SizedBox(height: 25),
                                      Row(
                                        children: [
                                          Text('Driving License',textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF00376A)
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          drivingLicenseImage!=null?
                                          Expanded(child: _buildFileImageView(drivingLicenseImage!))
                                              :

                                          drivingImageURL!=""?
                                          Expanded(child: _buildNetworkImageView(drivingImageURL))

                                              :




                                          Expanded(child: _buildImageView('assets/demo_img.png')),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {

                                              _fetchDrivingLicenseImage(context);

                                            },
                                            child: Container(
                                                width:110,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFF8500),
                                                    borderRadius: BorderRadius.circular(5)),
                                                height: 35,
                                                child: const Center(
                                                  child: Text('Upload',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white)),
                                                )),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 30),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingScreen()));

                                  },
                                  child: Container(

                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF00376A),
                                          borderRadius: BorderRadius.circular(5)),
                                      height: 45,
                                      child: const Center(
                                        child: Text('Submit',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),
                                SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),

          ],
        ),
      ),
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


  _fetchAadharImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      aadharImage = image;
      setState(() {});

      uploadImage(aadharImage, "0");
    }
  }


  _fetchPassportFrontImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      passportFrontImage = image;
      setState(() {});
      uploadImage(aadharImage, "2");
    }
  }



  _fetchPassportBackImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      passportBackImage = image;
      setState(() {});
      uploadImage(aadharImage, "3");
    }
  }
  _fetchDrivingLicenseImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      drivingLicenseImage = image;
      setState(() {});

      uploadImage(aadharImage, "4");
    }
  }
  Widget _buildFileImageView(XFile? imageFile) {
    return Container(
      height: 100,
      color: Color(0xFFEFEFEF),
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        child: Center(
          child: Image.file(
            File(imageFile!.path.toString()),
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),

    );
  }

  Widget _buildNetworkImageView(String imagePath) {
    return Container(
      height: 100,
      color: Color(0xFFEFEFEF),

      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 1,
        child: Center(
          child: Image.network(
            imagePath,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),

    );
  }
  @override
  void initState() {
    super.initState();
    getProfileData(context);

  }



  getProfileData(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getUserAllInfo', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    int attachmentStatus=responseJSON["data"]["has_attachment"];

    if(attachmentStatus==1)
    {
      String? baseUrl;

      if(responseJSON["data"].toString().contains("base_url"))
        {
          baseUrl=responseJSON["data"]["base_url"];
        }


      List<dynamic> attachmentList=[];

      attachmentList=responseJSON["data"]["attachment"];

      for(int i=0;i<attachmentList.length;i++)
        {

          String attachType=attachmentList[i]["attachment_type"];
          String attachUrl=baseUrl!+attachmentList[i]["attachment_url"];
          if(attachType=="0"){
            aadharImageURL=attachUrl;
          }else if(attachType=="2"){
            passportFrontImageURL=attachUrl;
          }else if(attachType=="3"){
            passportBackImageURL=attachUrl;
          }else if(attachType=="4"){
            drivingImageURL=attachUrl;
          }

        }

      setState(() {

      });





    }




  }


  uploadImage(XFile? imageFile,String type) async {
    APIDialog.showAlertDialog(context, 'Updating image...');
    FormData formData = FormData.fromMap({
      "file_name": await MultipartFile.fromFile(imageFile!.path),
      "user_id": AppModel.userID,
      "attachment_type": type,
      "Orignal_Name": imageFile.path.split('/').last,
      "fileCount": "1",
    });
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "addAttachment");
    var response = await dio.post(AppConstant.appBaseURL + "addAttachment",
        data: formData);
    log(response.data);
    var responseJSON = jsonDecode(response.data.toString());
    Navigator.pop(context);
    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
}
