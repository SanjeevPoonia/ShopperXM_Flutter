
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class StartScreen extends StatefulWidget{
  StartScreen();
  StartState createState()=> StartState();
}
class StartState extends State<StartScreen> {

  int activePage = 0;
  bool scrollStart = false;
  bool isVisible = true;

  void initState() {
    // TODO: implement initState
    super.initState();


  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body: Center(
          child: Text(
            'Hello \n ShopperXM',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800,color: Colors.black),
          ),
        ),
      ),
    );
  }

}
