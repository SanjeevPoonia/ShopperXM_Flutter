import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/audits/record_video_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/audit_form.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../widgets/textfield_widget.dart';
import '../start_audit/audit_intro_screen.dart';


class OpenAuditsScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<OpenAuditsScreen> {
  int selectedRadioIndex=1;
  final _formKey = GlobalKey<FormState>();
  bool isLoading=false;
  String Latitude_Str="75.8049537";
  String Longitude_Str="26.852436";
  List<dynamic> campaignList=[];
  List<dynamic> clientList=[];
  List<dynamic> cityList=[];
  List<String> clientListAsString=[

  ];
  List<String> campaignListAsString=[

  ];
  List<String> cityListAsString=[

  ];
  String? selectedClientName;
  String? selectedCampaignName;
  String? selectedCity;




  TextEditingController cityNameController = TextEditingController();
  TextEditingController zoneNameController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController startPointController = TextEditingController();
  TextEditingController endPointController = TextEditingController();

  List<String> categoryList=[
    "Client Name",
    "Name",
    "Audit Date",
    "Address",
    "Code",
  ];
  int metaFieldIndex=1;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body: Form(
          key: _formKey,
          child: Column(
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


                      Text("Open Audits",
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




             Expanded(child:
             isLoading?

                 Center(
                   child: Loader(),
                 ):


             ListView(
               padding: EdgeInsets.symmetric(horizontal: 14),

               children: [

                 SizedBox(height: 5),



                 RichText(
                   text: TextSpan(
                     style: TextStyle(
                       fontSize: 13,
                       color: Color(0xFF00407E),
                     ),
                     children: <TextSpan>[
                       TextSpan(
                           text: "Select client"),
                       TextSpan(
                         text: " *",
                         style: const TextStyle(
                             fontWeight:
                             FontWeight.bold,
                             color: Colors.red),
                       ),
                     ],
                   ),
                 ),
                 DropdownButton2(
                   isExpanded: true,
                   menuItemStyleData: const MenuItemStyleData(
                     //height: 40,
                     padding: EdgeInsets.only(left: 5, right: 5),
                   ),
                   iconStyleData: IconStyleData(
                     icon: const Icon(
                         Icons
                             .keyboard_arrow_down_rounded),
                   ),

                   hint: Text(
                     'Select client',
                     style:
                     TextStyle(
                       fontSize:
                       13,
                       color: Theme
                           .of(
                           context)
                           .hintColor,
                     ),
                   ),
                   items: clientListAsString
                       .map((item) =>
                       DropdownMenuItem<
                           String>(
                         value: item,
                         child: Text(
                             item,
                             style: const TextStyle(
                               fontSize: 13,
                             ),
                             maxLines: 3,
                             overflow: TextOverflow
                                 .visible
                         ),
                       ))
                       .toList(),
                   value:
                   selectedClientName,
                   onChanged:
                       (value) {
                     selectedClientName =
                     value
                     as String;

                     setState(() {

                     });





                     // Fetch Address ID

                     // API CALL


                   },

                 ),



                 SizedBox(height: 10),


                 RichText(
                   text: TextSpan(
                     style: TextStyle(
                       fontSize: 13,
                       color: Color(0xFF00407E),
                     ),
                     children: <TextSpan>[
                       TextSpan(
                           text: "Select Campaign"),
                       TextSpan(
                         text: " *",
                         style: const TextStyle(
                             fontWeight:
                             FontWeight.bold,
                             color: Colors.red),
                       ),
                     ],
                   ),
                 ),
                 DropdownButton2(
                   isExpanded: true,
                   menuItemStyleData: const MenuItemStyleData(
                     //height: 40,
                     padding: EdgeInsets.only(left: 5, right: 5),
                   ),
                   iconStyleData: IconStyleData(
                     icon: const Icon(
                         Icons
                             .keyboard_arrow_down_rounded),
                   ),

                   hint: Text(
                     'Select campaign',
                     style:
                     TextStyle(
                       fontSize:
                       13,
                       color: Theme
                           .of(
                           context)
                           .hintColor,
                     ),
                   ),
                   items: campaignListAsString
                       .map((item) =>
                       DropdownMenuItem<
                           String>(
                         value: item,
                         child: Text(
                             item,
                             style: const TextStyle(
                               fontSize: 13,
                             ),
                             maxLines: 3,
                             overflow: TextOverflow
                                 .visible
                         ),
                       ))
                       .toList(),
                   value:
                   selectedCampaignName,
                   onChanged:
                       (value) {
                         selectedCampaignName =
                     value
                     as String;



                         setState(() {

                         });


                     // Fetch Address ID

                     // API CALL


                   },

                 ),


               SizedBox(height: 10),


                 RichText(
                   text: TextSpan(
                     style: TextStyle(
                       fontSize: 13,
                       color: Color(0xFF00407E),
                     ),
                     children: <TextSpan>[
                       TextSpan(
                           text: "Add Meta Field Manual?"),
                     ],
                   ),
                 ),

               SizedBox(height: 8),

               Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [

                   Expanded(
                     flex:1,
                     child: Row(
                       children: [
                         GestureDetector(
                             onTap: () {
                               setState(() {
                                 selectedRadioIndex = 0;
                               });
                             },
                             child: selectedRadioIndex == 0
                                 ? Icon(Icons.radio_button_checked,
                                 color: AppTheme.themeColor,
                                 size: 20)
                                 : Icon(Icons.radio_button_off,
                                 color: Color(0xFFC6C6C6),
                                 size: 20)),
                         SizedBox(width: 5),
                         Padding(
                           padding: const EdgeInsets.only(top: 2),
                           child: Text('Yes',
                               style: TextStyle(
                                   fontWeight: FontWeight.w500,
                                   fontSize: 14,
                                   color: Colors.black)),
                         ),
                       ],
                     ),
                   ),

                   Expanded(
                     flex:1,
                     child: Row(
                       children: [
                         GestureDetector(
                             onTap: () {
                               setState(() {
                                 selectedRadioIndex = 1;
                               });
                             },
                             child: selectedRadioIndex == 1
                                 ? Icon(Icons.radio_button_checked,
                                 color: AppTheme.themeColor,
                                 size: 20)
                                 : Icon(Icons.radio_button_off,
                                 color: Color(0xFFC6C6C6),
                                 size: 20)),
                         SizedBox(width: 5),
                         Padding(
                           padding: const EdgeInsets.only(top: 2),
                           child: Text('No',
                               style: TextStyle(
                                   fontWeight: FontWeight.w500,
                                   fontSize: 14,
                                   color: Colors.black)),
                         ),
                       ],
                     ),
                   ),



                 ],
               ),

                 SizedBox(height: 13),





                 selectedRadioIndex==0?

                 TextFieldRedHintWidget2('City Name', "Enter City Name",cityNameController,checkEmptyValidator):





                 Container(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       RichText(
                         text: TextSpan(
                           style: TextStyle(
                             fontSize: 13,
                             color: Color(0xFF00407E),
                           ),
                           children: <TextSpan>[
                             TextSpan(
                                 text: "Select City"),
                             TextSpan(
                               text: " *",
                               style: const TextStyle(
                                   fontWeight:
                                   FontWeight.bold,
                                   color: Colors.red),
                             ),
                           ],
                         ),
                       ),
                       DropdownButton2(
                         isExpanded: true,
                         menuItemStyleData: const MenuItemStyleData(
                           //height: 40,
                           padding: EdgeInsets.only(left: 5, right: 5),
                         ),
                         iconStyleData: IconStyleData(
                           icon: const Icon(
                               Icons
                                   .keyboard_arrow_down_rounded),
                         ),

                         hint: Text(
                           'Select city',
                           style:
                           TextStyle(
                             fontSize:
                             13,
                             color: Theme
                                 .of(
                                 context)
                                 .hintColor,
                           ),
                         ),
                         items: cityListAsString
                             .map((item) =>
                             DropdownMenuItem<
                                 String>(
                               value: item,
                               child: Text(
                                   item,
                                   style: const TextStyle(
                                     fontSize: 13,
                                   ),
                                   maxLines: 3,
                                   overflow: TextOverflow
                                       .visible
                               ),
                             ))
                             .toList(),
                         value:
                         selectedCity,
                         onChanged:
                             (value) {
                           selectedCity =
                           value
                           as String;


                           setState(() {

                           });



                           // Fetch Address ID

                           // API CALL


                         },

                       ),
                     ],
                   ),
                 ),



                 SizedBox(height:selectedRadioIndex==0?13: 9),


                 selectedRadioIndex==1?Container():

                 TextFieldRedHintWidget2('Zone Name', "Enter Zone Name",zoneNameController,checkEmptyValidator),
                 selectedRadioIndex==1?Container():
                 SizedBox(height: 14),


                 selectedRadioIndex==1?Container():

                 TextFieldRedHintWidget2('State Name', "Enter State Name",stateNameController,checkEmptyValidator),
                 selectedRadioIndex==1?Container():
                 SizedBox(height: 14),



                 TextFieldRedHintWidget2('Vehicle Number', "Enter Vehicle Number",vehicleNumberController,checkEmptyValidator),

                 SizedBox(height: 14),
                 TextFieldRedHintWidget2('Start Point', "Enter Start Point",startPointController,checkEmptyValidator),

                 SizedBox(height: 14),
                 TextFieldRedHintWidget2('End Point', "Enter End Point",endPointController,checkEmptyValidator),
                 SizedBox(height: 30),
                 InkWell(
                   onTap: (){
                     _submitHandler(context);
                   },
                   child: Container(
                     margin: EdgeInsets.only(top: 1,left: 15,right: 15),
                     height:48,
                     width: 155,
                     //  padding: EdgeInsets.symmetric(horizontal: 20),
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
                       child:     Text("Submit & Start Audit",
                           style: TextStyle(
                             fontSize: 14,
                             fontWeight: FontWeight.w500,
                             color: Colors.white,
                           )),
                     )
                   ),
                 ),

               ]))










            ],
          ),
        )
      ),
    );
  }




  String? checkEmptyValidator(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be left as empty';
    }
    return null;
  }


  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    validateValues();
  }
  validateValues(){
    if(selectedClientName==null)
    {
      Toast.show("Please select client name",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    else if(selectedCampaignName==null)
    {
      Toast.show("Please select Campaign name",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    else if(selectedRadioIndex==1)
    {
      if(selectedCity==null)
        {
          Toast.show("Please select City name",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
        }
      else
        {
          submitOpenAudit(context);
        }




    }



    else
    {
      // All Passed

      submitOpenAudit(context);

    }




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

  getTaggedAuditList(BuildContext context) async {

    setState(() {
      isLoading=true;
    });
    var data = {
     /* "latitude":Latitude_Str,
      "longitude": Longitude_Str,*/
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeaderProd('getOpenAuditMetaDataClient', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON.toString());
   // taggedList = responseJSON['data'];
    setState(() {
      isLoading=false;
    });

    clientList=responseJSON["data"]["client"];
    campaignList=responseJSON["data"]["Campaign"];
    cityList=responseJSON["data"]["city"];

    for(int i=0;i<clientList.length;i++)
      {
        clientListAsString.add(clientList[i]["company_name"]);
      }

    for(int i=0;i<campaignList.length;i++)
    {
      campaignListAsString.add(campaignList[i]["name"]);
    }

    for(int i=0;i<cityList.length;i++)
    {
      cityListAsString.add(cityList[i]["city"]);
    }



  }




  submitOpenAudit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Submitting details...');

    String compaignID="";
    String cityID="";
    String clientID="";



    for(int i=0;i<clientList.length;i++)
    {
     if(selectedClientName==clientList[i]["company_name"])
       {
         clientID=clientList[i]["id"].toString();
       }
    }


    for(int i=0;i<campaignList.length;i++)
    {
      if(selectedCampaignName==campaignList[i]["name"])
      {
        compaignID=campaignList[i]["id"].toString();
      }
    }

   if(selectedRadioIndex==1)
     {
       for(int i=0;i<cityList.length;i++)
       {
         if(selectedCity==cityList[i]["city"])
         {
           cityID=cityList[i]["id"].toString();
         }
       }
     }
   else
     {
       cityID="1";
     }
    var data = {
     "city_id":cityID,
     "store_code":vehicleNumberController.text,
     "start_point":startPointController.text,
     "end_point":endPointController.text,
     "manual_meta_fields":selectedRadioIndex,
     "state":stateNameController.text,
     "zone":zoneNameController.text,
     "city_name":selectedRadioIndex==0?cityNameController.text:selectedCity,
     "client_id":clientID,
     "campaign_id":compaignID,
    };
    print("PAYLOAD");
    log(data.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('getOpenAuditMetaData', data, context);
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaggedAuditList(context);
  }

}
