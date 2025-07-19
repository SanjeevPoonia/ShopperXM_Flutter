import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class FaqScreen extends StatefulWidget {
  FaqState createState() => FaqState();
}

class FaqState extends State<FaqScreen> {
  bool isVisible = true;
  int selectedIndex = -1;
  List<bool> itemVisibility = List.generate(10, (index) => false);


  @override


  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        fontFamily: "RobotoFlex",

      ),
      home: Scaffold(
        body: Column(
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
                          child:Text("FAQ",textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.black))),

                      SizedBox(width: 10),
                    ],
                  ),
                )),
            SizedBox(height: 16,),
            Expanded(child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isVisible) {
                            selectedIndex = index;
                          } else {
                            selectedIndex = -1;
                          }

                        });

                      },
                      child: Container(

                        padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 0),
                        child: Column(
                          children: [
                            Row(
                              children: [

                                Text('Lorem Ipsum is simply dummy text ?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Color(0xFF1D2226)
                                  ),
                                ),
                                Spacer(),
                                Image.asset("assets/arrow_down_bl.png",height: 16,width: 16,),
                              ],
                            ),
                            SizedBox(height: 15,),
                            selectedIndex == index ?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting'),
                                SizedBox(height: 8,),
                              ],
                            ):Container(),
                            Container(
                              height: 1,
                              color: Colors.black.withOpacity(0.20),
                            )
                          ],
                        ),
                      )
                  ),
                );
              },
            ),),
            SizedBox(height: 50,)

          ],
        ),
      ),
    );
  }


}
