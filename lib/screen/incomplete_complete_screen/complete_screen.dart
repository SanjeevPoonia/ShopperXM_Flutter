import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/self_training/play_video_screen.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;

import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../widgets/appbar_widget.dart';
import '../self_training/start_training_screen.dart';


class CompleteScreen extends StatefulWidget {
  @override
  CompleteState createState() => CompleteState();
}

class CompleteState extends State<CompleteScreen> {
  int selectedRadioIndex=9999;
  bool isLoading=false;
  List<dynamic> trainingList=[];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarWidget("Completed Trainings"),
              Padding(padding: EdgeInsets.only(left: 16,right: 16,top: 8),
                child:  Text(
                  'My Learnings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              // SizedBox(height: 15),
              Expanded(
                child:
                isLoading?

                    Center(
                      child: Loader(),
                    ):

                    trainingList.length==0?


                        Center(
                          child: Text("No data found!"),
                        ):





                GestureDetector(
                  onTap: () {
                   // Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SelfTrainingScreen()));
                  },
                  child: ListView.builder(
                      itemCount: trainingList.length,
                      padding: EdgeInsets.only(bottom: 0,top: 0,left: 16,right: 16),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context,int pos)
                      {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(flex:1,child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF000000),
                                    borderRadius: BorderRadius.circular(6),

                                  ),
                                  child: Image.asset("assets/qd_logo.png",
                                      width: 20, height: 20),
                                )),
                                SizedBox(width: 15),
                                Expanded(flex:5,child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            trainingList[pos]["training_name"],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            trainingList[pos]["detail"],
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),

                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: LinearPercentIndicator(
                                            barRadius: const Radius.circular(6),
                                            padding: EdgeInsets.zero,
                                            lineHeight: 6.0,
                                            percent: 1.0,
                                            progressColor: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '100% Completed',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF00407E),
                                          ),

                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),)
                              ],
                            ),

                          ],
                        );
                      }

                  ),),
              )

            ],
          )
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompletedTrainingList(context);
  }

  getCompletedTrainingList(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeaderProd('getCompletedTraining', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    trainingList=responseJSON["data"];
    setState(() {

    });



  }



}
