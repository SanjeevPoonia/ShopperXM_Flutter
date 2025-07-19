
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget
{

  final String title,value;
  ListTileWidget(this.title,this.value);

  @override
  Widget build(BuildContext context) {
   return Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [

       Expanded(
         flex: 1,
         child: Text(title,
             style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.w400,
                 color: Color(0xFf707070))),
       ),

       Expanded(
         flex: 1,
         child: Text(value,
             style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
                 color: Colors.black),textAlign: TextAlign.right,),
       ),

     ],

   );
  }

}

class ListTileWidget2 extends StatelessWidget
{

  final String title,value;
  ListTileWidget2(this.title,this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          flex: 1,
          child: Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFf707070))),
        ),

        Expanded(
          flex: 1,
          child: Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D963A)),textAlign: TextAlign.right,),
        ),

      ],

    );
  }

}

class ListTileWidget3 extends StatelessWidget
{

  final String title,value;
  ListTileWidget3(this.title,this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          flex: 1,
          child: Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFf707070))),
        ),

        Expanded(
          flex: 1,
          child: Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8588A8)),textAlign: TextAlign.right),
        ),

      ],

    );
  }

}


class ListTileWidget4 extends StatelessWidget
{

  final String title,value;
  ListTileWidget4(this.title,this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          flex: 1,
          child: Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFf707070))),
        ),

        Expanded(
          flex: 1,
          child: Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF1111)),textAlign: TextAlign.right),
        ),

      ],

    );
  }

}