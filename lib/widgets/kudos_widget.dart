


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class KudosWidget extends StatelessWidget
{
  Function onTap;
  String title;
  KudosWidget(this.onTap,this.title);
  @override
  Widget build(BuildContext context) {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [

       Text(title,
           style: TextStyle(
               fontWeight: FontWeight.w500,
               fontSize: 15,
               color: Colors.black)),
       SizedBox(height: 5),

       InkWell(
         onTap: (){
           onTap();

         },
         child: Container(
           height: 57,
           padding: EdgeInsets.symmetric(horizontal: 10),
           decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(4),
               color: Color(0xFFF4F6FB)
           ),

           child: Row(
             children: [

               Expanded(child:  Text(title,
                   style: TextStyle(

                       fontSize: 14,
                       color: Color(0xFFAFAFAF)))),

               Icon(Icons.keyboard_arrow_down_sharp,size: 30,color: AppTheme.orangeColor)




             ],
           ),
         ),
       )

     ],
   );
  }

}
