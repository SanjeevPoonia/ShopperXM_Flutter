import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/network/api_dialog.dart';
import 'package:shopperxm_flutter/screen/audits/record_video_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/fill_audit_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';
import '../../widgets/textfield_profile_widget.dart';
import '../../widgets/textfield_widget.dart';


class ClaimScreen extends StatefulWidget {
  final String compaignID;
  final String storeID;
  ClaimScreen(this.compaignID,this.storeID);
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<ClaimScreen> {
  int selectedRadioIndex = 9999;
  int selectedIndex = 9999;
  bool isLoading = false;
  XFile? selectedImage;
  String TransactionFormateIdStr="";
  int MinRange=0;
  int MaxRange=0;
  int isRemarkMandatory=0;
  int isArtifactMandatory=0;
  int isVideoRequired=0;
  int isImageRequired=0;
  int isAudioRequired=0;
  var contactNameController = TextEditingController();
  var mobileController = TextEditingController();
  var auditTypeController = TextEditingController();
  var customerTypeController = TextEditingController();
  int selectedScenarioIndex = 9999;
  int selectedAuditTypeIndex = 9999;
  int selectedCustomerTypeIndex = 9999;
  List<dynamic> questionList=[];
  List<dynamic> parentList=[];
  List<dynamic> scenarioDataList = [];
  List<dynamic> auditModeDataList = [];
  List<dynamic> customerTypeDataList = [];
  List<String> scenarioList = [

  ];

  List<String> audioModeList = [

  ];

  List<String> customerTypeList = [

  ];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

          body:


          Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 10),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))
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
                            child: Icon(Icons.keyboard_backspace_rounded)),


                        Text("Transaction Claim",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            )),

                        Image.asset("assets/bell_ic.png", width: 23, height: 23)


                      ],
                    ),
                  ),
                ),
                Expanded(
                  child:


                      isLoading?

                          Center(
                            child: Loader(),
                          ):


                  ListView(

                    children: [


                      SizedBox(height: 10),


                      PhoneTextFieldAuditWidget("Auditor Amount", "Enter amount",mobileController,phoneValidator),


                      SizedBox(height: 17),
                      TextFieldProfileWidget(
                          'Auditor Remark', 'Enter remark',
                          contactNameController, nameValidator),










                      SizedBox(height: 17),







                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
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

                               _fetchImage();


                              },
                              child: const Text(
                                'Browse Artifact',
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
                              elevation: 2,
                              shadowColor: Colors.grey,
                              // margin: EdgeInsets.symmetric(horizontal: 13),
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
                                            borderRadius: BorderRadius.circular(
                                                4.0),
                                          ))),
                                  onPressed: () {
                                    _submitHandler(context);
                                 /*   Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            FillAuditScreen()));*/
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ), flex: 1),

                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }







  fetchClaim(BuildContext context) async {
    setState(() {
      isLoading=true;
    });


    var data = {
      "caimpaign_id": widget.compaignID
    };
    log(data.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'getClaimTransactionFormat', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });
    TransactionFormateIdStr=responseJSON["data"]["id"];
    MinRange=responseJSON["data"]["min_range"];
    MaxRange=responseJSON["data"]["max_range"];
    isRemarkMandatory=responseJSON["data"]["is_remark_mandatory"];
    isArtifactMandatory=responseJSON["data"]["is_artifact_mandatory"];

    setState(() {

    });
  }



  submitClaim(BuildContext context) async {

    APIDialog.showAlertDialog(context, "Please wait...");
    var data = {
      "beat_plan_store_id": widget.storeID,
      "amount": mobileController.text.toString(),
      "transaction_claim_format": TransactionFormateIdStr,
      "remark": contactNameController.text,
    };
    log(data.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(
        'saveTransactionClaim', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    Navigator.pop(context);

    if (responseJSON['status'] == 1) {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Navigator.pop(context);
    } else {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }



    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchClaim(context);

  }


  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    submitClaim(context);

  }



  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Remark is required';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (value!.length==0) {
      return 'Amount cannot be blank';
    }
    return null;
  }

  _fetchImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      selectedImage = image;
      setState(() {});
      uploadImage();
    }
  }

  uploadImage() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Uploading image...');
    FormData formData = FormData.fromMap({
      "user_id": AppModel.userID,
      "Orignal_Name": selectedImage!.path.split('/').last,
      "fileCount": "1",
      "store_id":widget.storeID,
      "campaign_id":widget.compaignID,
      "file":await MultipartFile.fromFile(selectedImage!.path),

    });
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "saveTransactionArtifact");
    var response = await dio.post(AppConstant.appBaseURL + "saveTransactionArtifact",
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
