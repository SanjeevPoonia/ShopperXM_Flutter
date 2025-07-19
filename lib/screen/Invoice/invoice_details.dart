import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';


class InvoiceDetailsScreen extends StatefulWidget {
  @override
  InvoiceDetailsState createState() => InvoiceDetailsState();
}

class InvoiceDetailsState extends State<InvoiceDetailsScreen> {
  var invoiceTitleController = TextEditingController();
  var invoiceIdController = TextEditingController();
  var usernameController = TextEditingController();
  var statusController = TextEditingController();
  var auditCountController = TextEditingController();
  var amountController = TextEditingController();
  var descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

          body: Column(
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


                      Text("Invoice Details",
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

              Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [

                      Container(
                          margin: EdgeInsets.only(left: 18,right: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),

                          ),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: invoiceTitleController,
                                  // validator: checkEmptyString,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Enter title",
                                    label: Text("Invoice Title",
                                      style: TextStyle(
                                          color: Color(0xFF00376A)
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: TextFormField(
                                  controller: invoiceIdController,
                                  // validator: checkEmptyString,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Enter ID",
                                    label: Text("Invoice ID",
                                      style: TextStyle(
                                          color: Color(0xFF00376A)
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: TextFormField(
                                  controller: usernameController,
                                  // validator: checkEmptyString,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Name",
                                    label: Text("Auditor Name",
                                      style: TextStyle(
                                          color: Color(0xFF00376A)
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {

                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Padding(padding: EdgeInsets.only(left: 0,right: 0,top: 6,bottom: 4),child:  Text('Date of Birth',style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color:Color(0xFF00376A)
                                        )),)
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(

                                          child: Text('DD-MM-YYYY',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15,
                                                  color: Color(0xFFC2C2C2)
                                              )),
                                        ),
                                        Container(

                                          child: Image.asset(
                                            'assets/calender.png', // Replace with your image URL
                                            width: 12,
                                            height: 12,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                height: 1,
                                color: Color(0xFF707070),
                              ),
                              Container(
                                child: TextFormField(
                                  controller: descriptionController,
                                  // validator: checkEmptyString,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Description",
                                    label: Text("Description",
                                      style: TextStyle(
                                          color: Color(0xFF00376A)
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: TextFormField(
                                  controller: statusController,
                                  // validator: checkEmptyString,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Status",
                                    label: Text("Status",
                                      style: TextStyle(
                                          color: Color(0xFF00376A)
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: TextFormField(
                                  controller: auditCountController,
                                  // validator: checkEmptyString,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: "Enter count",
                                    label: Text("Audit Count",
                                      style: TextStyle(
                                          color: Color(0xFF00376A)
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: TextFormField(
                                  controller: amountController,
                                  // validator: checkEmptyString,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: "Enter amount",
                                    label: Text("Amount",
                                      style: TextStyle(
                                          color: Color(0xFF00376A)
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          )


                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(left: 18,right: 18),
                        child: Text('For Audits',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF00407E)
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                          itemCount: 4,
                          padding: EdgeInsets.only(bottom: 10,top: 6,left: 12,right: 12),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,int pos)
                          {
                            return Column(
                              children: [

                                Container(
                                  //height: 274,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF708096).withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(10),

                                  ),
                                  child: Column(
                                    children: [

                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Image.asset("assets/calender_ic.png",
                                              width: 15, height: 15),

                                          SizedBox(width: 12),
                                          Text("2023-02-23",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFFF7C00),
                                              )),
                                          Spacer(),
                                          Container(
                                            height: 30,
                                            padding: EdgeInsets.all(4.0), // Add padding if needed
                                            decoration: BoxDecoration(
                                              color: Color(0xFF00407E), // Set background color
                                              borderRadius: BorderRadius.circular(6.0), // Set corner radius
                                            ),
                                            child: Text(
                                              '05',
                                              style: TextStyle(
                                                color: Colors.white, // Set text color
                                                fontSize: 16.0, // Set text size
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 10),
                                      Container(
                                        height: 1,
                                        color: Color(0xFF707070).withOpacity(0.30),
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [

                                          Image.asset("assets/ola_ic.png",width: 35,height: 35,),
                                          SizedBox(width: 15),

                                          Expanded(
                                            child: Text(
                                                "VS_RAJ_0021 (Vodaphone idea Ltd.)",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                )),
                                          ),

                                        ],
                                      ),

                                      SizedBox(height: 16)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 14),



                              ],
                            );
                          }


                      ),
                      SizedBox(height: 20),


                    ],
                  )
              ),
              Card(
                elevation: 4,
                shadowColor:Colors.grey,
                margin: EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 47,
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

              SizedBox(height: 25)

            ],
          )
      ),
    );
  }

}
