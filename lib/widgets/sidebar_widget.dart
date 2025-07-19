

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideBarWidget extends StatelessWidget
{
  final String title;
  final String imagePath;
  SideBarWidget(this.title,this.imagePath);
  @override
  Widget build(BuildContext context) {

    return   Padding(padding: EdgeInsets.symmetric(vertical: 13),

      child: Row(


        children: [

          Image.asset(imagePath,width:21,height: 21),


          SizedBox(width: 25),


          Text(title,
              style: TextStyle(
                  fontSize: 14.5,
                  color: Colors.white.withOpacity(0.84))),

        ],
      ),


    );
  }

}