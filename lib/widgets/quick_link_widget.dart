

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuickLinkWidget extends StatelessWidget
{
  final Function onTap;
  final String title;
  final String imagePath;
  QuickLinkWidget(this.onTap,this.title,this.imagePath);
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
        height: 114,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
            ),
          ],

        ),
        child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 12),

                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF47320).withOpacity(0.10),
                  ),
                  child: Center(
                      child: Image.asset(imagePath)
                  ),
                ),

                SizedBox(height: 10),

                Text(title,style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                ),textAlign: TextAlign.center),
              ],
            )
        ),
      ),
    );
  }

}


class MenuItemWidget extends StatelessWidget
{
  final Function onTap;
  final String title;
  final String imagePath;
  MenuItemWidget(this.onTap,this.title,this.imagePath);
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        onTap();
      },
      child: Container(
        height: 122,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white.withOpacity(0.50),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
            ),
          ],

        ),
        child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                SizedBox(height: 13),

                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF47320).withOpacity(0.10),
                  ),
                  child: Center(
                      child: Image.asset(imagePath)
                  ),
                ),

                SizedBox(height: 19),

                Text(title,style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                ),textAlign: TextAlign.center),
              ],
            )
        ),
      ),
    );
  }

}