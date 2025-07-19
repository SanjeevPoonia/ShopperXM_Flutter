import 'dart:convert';
import 'dart:developer';
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
import 'package:shopperxm_flutter/screen/reimbursement/add_expenses_screen.dart';
import 'package:shopperxm_flutter/screen/start_audit/fill_audit_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:shopperxm_flutter/widgets/appbar_widget.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../widgets/textfield_profile_widget.dart';
import '../../widgets/textfield_widget.dart';


class ReimbursementFormScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<ReimbursementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  var departNameController=TextEditingController();
  var empCodeController=TextEditingController();
  var nameController=TextEditingController();
  var projectNameController=TextEditingController();
  var designationController=TextEditingController();
  var projectManagerController=TextEditingController();
  var fromDateController=TextEditingController();
  var toDateController=TextEditingController();
  String? selectedDate;
  String? selectedToDate;
  List<dynamic> expensesList=[];
  bool showExpenses=false;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body: Form(
          key: _formKey,
          child: Column(
            children: [


              AppBarWidget("Claim Reimbursement Form"),

              Expanded(
                child: ListView(

                  children: [




                    SizedBox(height: 10),


                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Text("Period",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.themeColor,
                          )),
                    ),


                    SizedBox(height: 8),

                   Row(
                     children: [

                       Expanded(child:  GestureDetector(
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
                             fromDateController.text=selectedDate.toString();
                             setState(() {});
                           }
                         },
                         child: Container(
                           height: 30,
                           margin: EdgeInsets.symmetric(horizontal: 13),
                           child: TextFormField(
                             enabled: false,
                             controller: fromDateController,
                             decoration:  InputDecoration(
                                 hintText: "Select from date",
                                 suffixIconConstraints: BoxConstraints(
                                     minHeight: 12,
                                     minWidth: 12
                                 ),
                                 suffixIcon: Container(child: Image.asset("assets/calender_ic.png",width: 12,height: 12,)),

                                 hintStyle: TextStyle(
                                     fontSize: 14
                                 )
                             ),
                           ),
                         ),
                       ),flex: 1,
                       ),



                       SizedBox(width: 20),





                       Expanded(child:  GestureDetector(
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
                             selectedToDate = formattedDate.toString();
                             toDateController.text=selectedToDate.toString();
                             setState(() {});
                           }
                         },
                         child: Container(
                           height: 30,
                           margin: EdgeInsets.symmetric(horizontal: 13),
                           child: TextFormField(
                             enabled: false,
                             controller: toDateController,
                             decoration:  InputDecoration(
                                 hintText: "Select to date",
                                 suffixIconConstraints: BoxConstraints(
                                     minHeight: 12,
                                     minWidth: 12
                                 ),
                                 suffixIcon: Image.asset("assets/calender_ic.png",width: 11,height: 11),
                                 hintStyle: TextStyle(
                                     fontSize: 14
                                 )
                             ),
                           ),
                         ),
                       ),flex: 1,
                       )


                     ],
                   ),



                    SizedBox(height: 22),



                    TextFieldRedHintWidget('Department', "Enter department",departNameController,checkEmptyValidator),



                    SizedBox(height: 22),


                    TextFieldRedHintWidget('Employee Code',"Enter employee code",empCodeController,checkEmptyValidator),


                    SizedBox(height: 22),


                    TextFieldRedHintWidget('Name',"Enter name",nameController,checkEmptyValidator),


                    SizedBox(height: 22),


                    TextFieldRedHintWidget('Project Name',"Enter Project Name",projectNameController,checkEmptyValidator),




                    SizedBox(height: 22),


                    TextFieldRedHintWidget('Designation',"Enter Designation",designationController,checkEmptyValidator),


                    SizedBox(height: 22),


                    TextFieldRedHintWidget('Project Manager',"Enter Project Manager",projectManagerController,checkEmptyValidator),


                    SizedBox(height: 27),


                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: expensesList.length,
                        itemBuilder: (BuildContext context,int pos)
                        {
                          return Column(
                            children: [

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
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

                                    SizedBox(height: 5),




                                    Row(
                                      children: [
                                        Spacer(),
                                        GestureDetector(
                                            onTap: (){
                                              setState(() {
                                               expensesList.removeAt(pos);
                                               setState(() {

                                               });
                                              });
                                            },
                                            child: Image.asset("assets/cross_ic.png",width: 38,height: 38)),
                                      ],
                                    ),


                                    SizedBox(height: 8),


                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 13),
                                      child: Row(
                                        children: [
                                          Expanded(child:  TextFieldDisabledRowWidget("Date",expensesList[pos]["date"]),flex: 1),

                                          SizedBox(width: 30),

                                          Expanded(child:  TextFieldDisabledRowWidget("Base Location",expensesList[pos]["base"]),flex: 1),




                                        ],
                                      ),
                                    ),


                                    SizedBox(height: 22),


                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 13),
                                      child: Row(
                                        children: [
                                          Expanded(child:  TextFieldDisabledRowWidget("From",expensesList[pos]["from"]),flex: 1),

                                          SizedBox(width: 30),

                                          Expanded(child:  TextFieldDisabledRowWidget("To",expensesList[pos]["to"]),flex: 1)




                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 22),

                                    TextFieldDisabledWidget("Purpose of Travel", expensesList[pos]["purpose"]),


                                    SizedBox(height: 22),

                                    TextFieldDisabledWidget("Mode of Travel", expensesList[pos]["mode"]),

                                    SizedBox(height: 22),

                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 13),
                                      child: Row(
                                        children: [
                                          Expanded(child:  TextFieldDisabledRowWidget("Travel",expensesList[pos]["travel"]),flex: 1),

                                          SizedBox(width: 30),

                                          Expanded(child:  TextFieldDisabledRowWidget("Loadging",expensesList[pos]["loadging"]),flex: 1)




                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 22),

                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 13),
                                      child: Row(
                                        children: [
                                          Expanded(child:  TextFieldDisabledRowWidget("Food",expensesList[pos]["food"]),flex: 1),

                                          SizedBox(width: 30),

                                          Expanded(child:  TextFieldDisabledRowWidget("New Sim Purchased",expensesList[pos]["sim"]),flex: 1)




                                        ],
                                      ),
                                    ),




                                    SizedBox(height: 22),



                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 13),
                                      child: Row(
                                        children: [
                                          Expanded(child:  TextFieldDisabledRowWidget("Petrol",expensesList[pos]["petrol"]),flex: 1),

                                          SizedBox(width: 30),

                                          Expanded(child:  TextFieldDisabledRowWidget("Distance(Km)",expensesList[pos]["distance"]),flex: 1)




                                        ],
                                      ),
                                    ),



                                    SizedBox(height: 22),



                                    TextFieldDisabledWidget("Auto/Tempo", expensesList[pos]["auto"]),




                                    SizedBox(height: 22),



                                    TextFieldDisabledWidget("Remark",expensesList[pos]["remark"]),



                                    SizedBox(height: 10),


                                  ],
                                ),






                              ),

                              SizedBox(height: 17),

                            ],

                          );
                        }


                    ),









                    SizedBox(height: 30),


                    Center(
                      child: InkWell(
                        onTap:() async {
                   final data=await Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AddExpensesScreen()));

                   if(data!=null)
                     {
                       expensesList.add(data);
                       setState(() {

                       });
                     }

                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 1),
                          height:48,
                          width: 160,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF7C00),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color:
                                Colors.black12.withOpacity(0.3),
                                offset: const Offset(0.0, 3.0),
                                blurRadius: 3.0,
                              ),
                            ],
                          ),

                          child: Row(
                            children: [

                              Text("Add Expenses",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),


                              SizedBox(width: 10),

                              Image.asset("assets/add_white.png",width: 27,height: 27),


                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 45),


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

                           // successBottomSheet(context);


                          },
                          child: const Text(
                            'Submit',
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

                    Text("Submitted\nsuccessfully",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),textAlign: TextAlign.center),

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
                        'Back',
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




  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
     validateValues();
  }

  validateValues(){
    if(selectedDate==null)
      {
        Toast.show("Please select from date",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    else if(selectedToDate==null)
      {
        Toast.show("Please select to date",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    else if(expensesList.length==0)
      {
        Toast.show("Please add at least one expense!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    else
      {
        // All Passed

        submitFormData(context);

      }




  }




  submitFormData(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Submitting details...');
    List<dynamic> detailsDataList=[];

    detailsDataList.add({
      "user_id": AppModel.userID,
      "date_from":fromDateController.text.toString(),
      "date_to": toDateController.text.toString(),
      "department": departNameController.text,
      "employee_code_no": empCodeController.text,
      "user_name": nameController.text,
      "expense_project_name": projectNameController.text,
      "designation": designationController.text,
      "project_manager": projectManagerController.text,
    });


    List<dynamic> expensesDataList=[];
    for(int i=0;i<expensesList.length;i++)
    {
      expensesDataList.add({
        "date_es": expensesList[i]["date"],
        "base_location_es":expensesList[i]["base"],
        "form_es": expensesList[i]["from"],
        "to_es": expensesList[i]["to"],
        "travel_purpose_es": expensesList[i]["purpose"],
        "travel_mode_es":expensesList[i]["mode"],
        "travel_amount_es":expensesList[i]["travel"],
        "travel_amount_artifact": "",
        "loadging_amount_es": expensesList[i]["loadging"],
        "loadging_amount_artifact":"",
        "food_amount_es":expensesList[i]["food"],
        "food_amount_artifact":"",
        "petrol_amount_es":expensesList[i]["petrol"],
        "petrol_amount_artifact":"",
        "distance_es":expensesList[i]["distance"],
        "distance_artifact":"",
        "auto_amount_es":expensesList[i]["auto"],
        "auto_artifact":"",
        "newsim_amount":expensesList[i]["sim"],
        "newsim_artifact":"",
        "remark_es":expensesList[i]["remark"],
      });
    }



    var data = {
      '"actualDetail"':json.encode(detailsDataList),
      '"actualExpense"':json.encode(expensesDataList)
    };
    print("PAYLOAD");
    log(data.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('saveActualTransaction', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    log(responseJSON);
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




  String? checkEmptyValidator(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be left as empty';
    }
    return null;
  }
}
