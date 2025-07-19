import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shopperxm_flutter/screen/Invoice/invoice_details.dart';
import 'package:shopperxm_flutter/screen/Invoice/raise_invoice_screen.dart';
import 'package:shopperxm_flutter/screen/notification/notification_screen.dart';
import 'package:toast/toast.dart';

import '../../utils/app_theme.dart';

class InvoiceRaisedScreen extends StatefulWidget {
  InvoiceRaisedState createState() => InvoiceRaisedState();
}

class InvoiceRaisedState extends State<InvoiceRaisedScreen> {


  int selectedRadioIndex=9999;
  @override

  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

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

                      Text("Invoice Raised",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));
                          },
                          child: Image.asset("assets/bell_ic.png",width: 23,height: 23)),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              Card(
                elevation: 4,
                shadowColor:Colors.grey,
                margin: EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 45,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RaiseInvoiceScreen()));

                      },
                      child:  Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Image.asset("assets/img_raised.png",
                                width: 16, height: 20),

                            SizedBox(width: 14),

                            Text(
                                "Raise Invoice",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),

                          ],
                        ),
                      )
                  ),
                ),
              ),
              SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                    itemCount: 4,
                    padding: EdgeInsets.only(bottom: 70,top: 6,left: 12,right: 12),
                    shrinkWrap: true,
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.3),
                                  offset: const Offset(0.0, 1.0),
                                  blurRadius: 3.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 184, height: 41,
                                  child: Stack(
                                    children: [
                                      Image.asset("assets/rect_green.png",
                                          width: 180, height: 38),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Text(
                                                "Raised Invoice",
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
                                    Text(
                                        "Invoice Title",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 13,
                                          height: 0.5,
                                          color: Color(0xFF00407E),
                                        )),
                                  ],
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: "Enter Invoice",
                                        hintStyle: TextStyle(
                                            fontSize: 14
                                        )
                                    ),
                                  ),
                                ),

                                SizedBox(height: 22),

                                Row(
                                  children: [

                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left: 0),
                                            child: Text(
                                                "Invoice ID",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  height: 0.5,
                                                  color: Color(0xFF00407E),
                                                )),
                                          ),

                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 0),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  hintText: "124RFWS",
                                                  hintStyle: TextStyle(
                                                      fontSize: 14
                                                  )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 18),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left: 0),
                                            child: Text(
                                                "Audit Count",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  height: 0.5,
                                                  color: Color(0xFF00407E),
                                                )),
                                          ),

                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 0),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  hintText: "5",
                                                  hintStyle: TextStyle(
                                                      fontSize: 14
                                                  )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(child: Row(
                                        children: [
                                          Image.asset("assets/status.png",
                                              width: 15, height: 15),
                                          SizedBox(width: 12),
                                          Text("Completed",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF2FAE67),
                                              )),

                                        ],
                                      )),
                                      SizedBox(width: 18),
                                      Expanded(child: Row(
                                        children: [
                                          Image.asset("assets/calender_ic.png",
                                              width: 15, height: 15),
                                          SizedBox(width: 12),
                                          Text("2023-02-23",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF494F66),
                                              )),
                                        ],
                                      ))

                                    ],
                                  ),
                                ),

                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                          onTap:(){

                                          },
                                          child: Container(
                                            height:45,
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                  Colors.black12.withOpacity(0.2),
                                                  offset: const Offset(0.0, 1.0),
                                                  blurRadius: 3.0,
                                                ),
                                              ],
                                            ),

                                            child: Row(
                                              children: [
                                                Image.asset("assets/download.png",width: 23.06,height: 20.96),

                                                SizedBox(width: 20),
                                                Text("Download",
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
                                          onTap:(){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>InvoiceDetailsScreen()));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 1),
                                            height:45,
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF00407E),
                                              borderRadius: BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                  Colors.black12.withOpacity(0.2),
                                                  offset: const Offset(0.0, 1.0),
                                                  blurRadius: 3.0,
                                                ),
                                              ],
                                            ),

                                            child: Row(
                                              children: [

                                                Text("Show Details",
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
                                SizedBox(height: 15),
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
          )
      ),
    );
  }


}
