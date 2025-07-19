import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:toast/toast.dart';


class NotificationScreen extends StatefulWidget {
  @override
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationScreen> {
  bool showImage = false;
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


                      Text("Notifications",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                      showImage == true?
                      Image.asset("assets/bell_ic.png",width: 23,height: 23):Column()

                    ],
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Example item count
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 10),
                          child:  Text('8-03-2024',
                            style: TextStyle(
                              fontSize: 16,
                             fontWeight: FontWeight.w600,
                              color: Color(0xFF00407E)
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3, // Example content count
                          itemBuilder: (context, contentIndex) {
                            return Container(
                              margin: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFE9F4F7),
                                borderRadius: BorderRadius.circular(8.0), // Set corner radius
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Audit Assigned',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFFF7C00)
                                        ),
                                      ),
                                      Spacer(),
                                      Text('13:34',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF708096)
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Text('New Audit assigned to your portal by James Mathews',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF000000)
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                   children: [
                                     Text('06 - Oct - 2023',
                                       style: TextStyle(
                                           fontSize: 14,
                                           fontWeight: FontWeight.normal,
                                           color: Color(0xFF708096)
                                       ),
                                     ),
                                   ],
                                 ),
                                ],
                              ),
                            );
                          },
                        ),

                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 25)

            ],
          )
      ),
    );
  }

}
