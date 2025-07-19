

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget
{
  final String title,initialValue;
  var controller;
  final String? Function(String?)? validator;
  TextFieldWidget(this.title,this.initialValue,this.controller,this.validator);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                height: 0.5,
                color: Color(0xFF00407E),
              )),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration:  InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}


class TextFieldProfileWidget extends StatelessWidget
{
  final String title,initialValue;
  var controller;
  final String? Function(String?)? validator;
  TextFieldProfileWidget(this.title,this.initialValue,this.controller,this.validator);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                height: 0.5,
                color: Color(0xFF00407E),
              )),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration:  InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}



class TextFieldDisabledWidget extends StatelessWidget
{
  final String title,initialValue;
  TextFieldDisabledWidget(this.title,this.initialValue);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              )),
        ),

        Container(
          height: 35,
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: TextFormField(
            enabled: false,
            decoration:  InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}



class TextFieldDisabledRowWidget extends StatelessWidget
{
  final String title,initialValue;
  TextFieldDisabledRowWidget(this.title,this.initialValue);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
            title,
            style: TextStyle(
              fontSize: 13,

              color: Colors.black,
            )),

        Container(
          height: 35,
          child: TextFormField(
            enabled: false,
            decoration:  InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}



class TextFieldRowWidget extends StatelessWidget
{
  final String title,initialValue;
  var controller;
  final String? Function(String?)? validator;
  TextFieldRowWidget(this.title,this.initialValue,this.controller,this.validator);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
            title,
            style: TextStyle(
              fontSize: 13,
              height: 0.5,
              color: Color(0xFF00407E),
            )),

        TextFormField(
          validator: validator,
          controller: controller,
          decoration:  InputDecoration(
              hintText: initialValue,
              hintStyle: TextStyle(
                  fontSize: 14
              )
          ),
        ),
      ],
    );
  }

}


class TextFieldRowNumberWidget extends StatelessWidget
{
  final String title,initialValue;
  var controller;
  TextFieldRowNumberWidget(this.title,this.initialValue,this.controller);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
            title,
            style: TextStyle(
              fontSize: 13,
              height: 0.5,
              color: Color(0xFF00407E),
            )),

        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:  InputDecoration(
              hintText: initialValue,
              hintStyle: TextStyle(
                  fontSize: 14
              )
          ),
        ),
      ],
    );
  }

}



class TextFieldRedHintWidget extends StatelessWidget
{
  final String title,initialValue;
  var controller;
  final String? Function(String?)? validator;
  TextFieldRedHintWidget(this.title,this.initialValue,this.controller,this.validator);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 14),
          child:
          RichText(
            text: TextSpan(
          style: TextStyle(
          fontSize: 13,
          color: Color(0xFF00407E),
          ),
              children: <TextSpan>[
                 TextSpan(
                    text: title),
                TextSpan(
                  text: " *",
                  style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
          ),






        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: TextFormField(
            validator: validator,
            controller: controller,
            decoration:  InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}

class TextFieldRedHintWidget2 extends StatelessWidget
{
  final String title,initialValue;
  var controller;
  final String? Function(String?)? validator;
  TextFieldRedHintWidget2(this.title,this.initialValue,this.controller,this.validator);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 0),
          child:
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF00407E),
              ),
              children: <TextSpan>[
                TextSpan(
                    text: title),
                TextSpan(
                  text: " *",
                  style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
          ),






        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: TextFormField(
            validator: validator,
            controller: controller,
            decoration:  InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}

class PhoneTextFieldWidget extends StatelessWidget
{
  final String title,initialValue;
  var controller;
  PhoneTextFieldWidget(this.title,this.initialValue,this.controller);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                height: 0.5,
                color: Color(0xFF00407E),
              )),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration:  InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}



class PhoneTextFieldAuditWidget extends StatelessWidget
{
  final String title,initialValue;
  var controller;
  final String? Function(String?)? validator;
  PhoneTextFieldAuditWidget(this.title,this.initialValue,this.controller,this.validator);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                height: 0.5,
                color: Color(0xFF00407E),
              )),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            controller: controller,
            validator: validator,
            keyboardType: TextInputType.number,
            decoration:  InputDecoration(
                hintText: initialValue,
                hintStyle: TextStyle(
                    fontSize: 14
                )
            ),
          ),
        ),

      ],
    );
  }

}