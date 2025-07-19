import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/audits/record_video_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/fill_audit_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:shopperxm_flutter/widgets/appbar_widget.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../widgets/textfield_profile_widget.dart';
import '../../widgets/textfield_widget.dart';


class AddExpensesScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<AddExpensesScreen> {
  int selectedRadioIndex=9999;
  int selectedIndex=9999;
  String? selectedDate;
  final _formKey = GlobalKey<FormState>();
  var baseLocationController=TextEditingController();
  var fromController=TextEditingController();
  var toController=TextEditingController();
  var travelPurposeController=TextEditingController();
  var modeOfTravelController=TextEditingController();
  var remarkController=TextEditingController();
  var travelAmountController=TextEditingController();
  var loadgingController=TextEditingController();
  var foodController=TextEditingController();
  var newSimController=TextEditingController();
  var petrolController=TextEditingController();
  var distanceController=TextEditingController();
  var autoController=TextEditingController();

  var dateController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body: Form(
          key: _formKey,
          child: Column(
            children: [


              AppBarWidget("Add Expenses"),

              Expanded(
                child: ListView(

                  children: [




                    SizedBox(height: 10),


                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                         Expanded(child:  Column(
                           children: [
                             Container(
                               child: Text("Date",
                                   style: TextStyle(
                                     fontSize: 13,
                                     fontWeight: FontWeight.w400,
                                     color: AppTheme.themeColor,
                                   )),
                             ),





                             GestureDetector(
                               onTap: () async {
                                 DateTime? pickedDate = await showDatePicker(
                                     context: context,
                                     initialDate: DateTime.now(),
                                     firstDate: DateTime(1950),
                                     //DateTime.now() - not to allow to choose before today.
                                     lastDate: DateTime(2100));

                                 if (pickedDate != null) {
                                   String formattedDate =
                                   DateFormat('yyyy-MM-dd')
                                       .format(pickedDate);
                                   selectedDate = formattedDate.toString();
                                   dateController.text=selectedDate.toString();
                                   setState(() {});
                                 }
                               },
                               child: Container(
                                 height: 35,
                                 child: TextFormField(
                                   enabled: false,
                                   controller: dateController,
                                   decoration:  InputDecoration(
                                       hintText: "Date*",
                                       suffixIconConstraints: BoxConstraints(
                                           minHeight: 11,
                                           minWidth: 11
                                       ),
                                       suffixIcon: Container(child: Image.asset("assets/calender_ic.png",width: 11,height: 11,)),
                                       hintStyle: TextStyle(
                                           fontSize: 14
                                       )
                                   ),
                                 ),
                               ),
                             )
                           ],
                           crossAxisAlignment: CrossAxisAlignment.start,
                         ),flex: 1),

                          SizedBox(width: 30),

                          Expanded(child:  TextFieldRowWidget("Base Location","",baseLocationController,checkEmptyValidator),flex: 1)




                        ],
                      ),
                    ),

                    SizedBox(height: 22),


                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Expanded(child:  TextFieldRowWidget("From","Enter here",fromController,checkEmptyValidator),flex: 1),

                          SizedBox(width: 30),

                          Expanded(child:  TextFieldRowWidget("To","Enter here",toController,checkEmptyValidator),flex: 1)




                        ],
                      ),
                    ),


                    SizedBox(height: 18),



                    TextFieldWidget("Purpose of Travel", 'Enter here',travelPurposeController,checkEmptyValidator),

                    SizedBox(height: 18),



                    TextFieldWidget("Mode of Travel", 'Enter here',modeOfTravelController,checkEmptyValidator),
                    SizedBox(height: 18),


                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Text("Expenses Type",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.themeColor,
                          )),
                    ),



                    SizedBox(height: 22),


                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Expanded(child:  TextFieldRowNumberWidget("Travel","Enter amount",travelAmountController),flex: 1),

                          SizedBox(width: 30),

                          Expanded(child:  TextFieldRowNumberWidget("Loadging","Enter amount",loadgingController),flex: 1)




                        ],
                      ),
                    ),

                    SizedBox(height: 22),



                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Expanded(child:  TextFieldRowNumberWidget("Food","Enter amount",foodController),flex: 1),

                          SizedBox(width: 30),

                          Expanded(child:  TextFieldRowNumberWidget("New Sim Purchased","Enter amount",newSimController),flex: 1)




                        ],
                      ),
                    ),





                    SizedBox(height: 22),



                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Expanded(child:  TextFieldRowNumberWidget("Petrol","Enter amount",petrolController),flex: 1),

                          SizedBox(width: 30),

                          Expanded(child:  TextFieldRowNumberWidget("Distance(Km)","Enter distance",distanceController),flex: 1)




                        ],
                      ),
                    ),




                    SizedBox(height: 22),



                    PhoneTextFieldWidget("Auto/Tempo", 'Enter amount',autoController),




                    SizedBox(height: 22),



                    TextFieldWidget("Remark", 'Enter here',remarkController,checkEmptyValidator),



                    SizedBox(height: 30),




                    Card(
                      elevation: 2,
                      shadowColor:Colors.grey,
                       margin: EdgeInsets.symmetric(horizontal: 14),
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

                          _submitHandler(context);



                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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




  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    validateValues();
  }

  String? checkEmptyValidator(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be left as empty';
    }
    return null;
  }
  validateValues(){

    if(selectedDate==null)
    {
      Toast.show("Please select a valid date",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    else if(travelAmountController.text=="" && loadgingController.text=="" && foodController.text=="" && newSimController.text=="" && petrolController.text=="" && distanceController.text=="" && autoController.text=="")
    {
      Toast.show("Please enter at least one expense!!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    else
      {

        Map<String,dynamic> expenseData={

          "date":dateController.text,
          "base":baseLocationController.text,
          "from":fromController.text,
          "to":toController.text,
          "purpose":travelPurposeController.text,
          "mode":modeOfTravelController.text,
          "travel":travelAmountController.text.toString(),
          "loadging":loadgingController.text.toString(),
          "food":foodController.text.toString(),
          "sim":newSimController.text.toString(),
          "petrol":petrolController.text.toString(),
          "distance":distanceController.text.toString(),
          "auto":autoController.text.toString(),
          "remark":remarkController.text.toString(),
        };


        Navigator.pop(context,expenseData);
      }





  }
}
