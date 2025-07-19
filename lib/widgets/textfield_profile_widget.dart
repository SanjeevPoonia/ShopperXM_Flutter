

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class ProfileTextFieldWidget extends StatelessWidget
{
  final String title,initialValue;
  ProfileTextFieldWidget(this.title,this.initialValue);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 17),
      padding: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        color: Color(0xFFEEEDF9),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),

          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF707070))),

          SizedBox(
            height: 40,
            child: TextFormField(
              initialValue:initialValue,
              decoration: InputDecoration(
                hintText:title,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppTheme.textlight
                ),
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
          ),


        ],
      ),
    );
  }

}


class ProfileTextFieldSmallWidget extends StatelessWidget
{
  final String title,initialValue;
  ProfileTextFieldSmallWidget(this.title,this.initialValue);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        color: Color(0xFFEEEDF9),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),

          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF707070))),

          SizedBox(
            height: 40,
            child: TextFormField(
              initialValue:initialValue,
              decoration: InputDecoration(
                hintText:title,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppTheme.textlight
                ),
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
          ),


        ],
      ),
    );
  }

}


