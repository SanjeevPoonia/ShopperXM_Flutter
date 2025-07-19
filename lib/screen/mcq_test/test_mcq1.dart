import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/mcq_test/test_mcq_type2.dart';
import 'package:shopperxm_flutter/screen/self_training/training_step3.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:video_player/video_player.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../utils/app_modal.dart';
import '../../widgets/appbar_widget.dart';
import 'final_result_screen.dart';


class MCQTest1Screen extends StatefulWidget {
  final String trainingID;
  MCQTest1Screen(this.trainingID);
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MCQTest1Screen> {
  int selectedRadioIndex=9999;
  bool pageNavigator=false;
  bool check=false;
  int _start = 120;
  List<int> checkList=[];
  List<dynamic> answerList=[];
  Timer? _timer;
  int selectedOption=9999;
  bool isLoading=false;
  Map<String,dynamic> trainingData={};
  int currentQuestionIndex=0;
  List<dynamic> quizList=[];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarWidget(trainingData.isEmpty?"":trainingData["training_name"]),

           Expanded(child:

           isLoading?

           Center(
               child:Loader()
           ):


           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 13),
                 child: Row(
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [

                         Text(
                           'Test Code',
                           style: TextStyle(
                             fontSize: 11,
                             fontWeight: FontWeight.w600,
                             color: Colors.black,
                           ),

                         ),


                         Text(
                           trainingData.isEmpty?"":trainingData["training_name"],
                           style: TextStyle(
                             fontSize: 17,
                             fontWeight: FontWeight.w700,
                             color: Colors.black,
                           ),

                         ),



                       ],
                     ),

                     Spacer(),

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [

                         Text(
                           'Time left',
                           style: TextStyle(
                             fontSize: 11,
                             fontWeight: FontWeight.w600,
                             color: Colors.black,
                           ),

                         ),


                         Text(
                           formattedTime(timeInSecond: _start),
                           style: TextStyle(
                               fontSize: 17,
                               fontWeight: FontWeight.w700,
                               color: Color(0xFFFF7C00)
                           ),

                         ),



                       ],
                     ),

                     SizedBox(width: 10),

                     SizedBox(
                       height: 55,
                       child:  Center(
                         child:Lottie.asset("assets/clock_anim.json") ,
                       ),
                     ),



                   ],
                 ),
               ),


               Padding(padding: EdgeInsets.symmetric(horizontal: 13),

                 child: Divider(
                   thickness: 1.4,

                 ),

               ),



               SizedBox(height: 3),
               Padding(
                 padding: const EdgeInsets.only(left: 13),
                 child: Text(
                   'Question '+(currentQuestionIndex+1).toString(),
                   style: TextStyle(
                     fontSize: 11,
                     fontWeight: FontWeight.w600,
                     color: Colors.black,
                   ),

                 ),
               ),
               SizedBox(height: 3),

               Padding(
                 padding: const EdgeInsets.only(left: 13,right: 10),
                 child: Text(
                   quizList[currentQuestionIndex]["question"],
                   style: TextStyle(
                     fontSize: 15.5,
                     fontWeight: FontWeight.w700,
                     color: Colors.black,
                   ),

                 ),
               ),

               SizedBox(height: 12),







               ListView.builder(
                   shrinkWrap: true,
                   itemCount: quizList[currentQuestionIndex]["get_question_option"].length,
                   itemBuilder: (BuildContext context,int pos)
               {
                 return Column(
                   children: [



                     quizList[currentQuestionIndex]["type"]==0?

                   Container(
                   height: 46,
                   margin: EdgeInsets.symmetric(horizontal: 13),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(4),
                       color: Color(0xFFF2F2F2),
                       border: Border.all(color: Color(0xFF707070),width: 0.3)
                   ),

                   child: Row(
                     children: [

                       SizedBox(width: 10),

                       GestureDetector(
                           onTap: () {
                             setState(() {
                               selectedOption = pos;
                             });
                           },
                           child: selectedOption == pos
                               ? Icon(Icons.radio_button_checked,
                               color: AppTheme.orangeColor,
                               size: 23)
                               : Icon(Icons.radio_button_off,
                               color: Color(0xFFC6C6C6),
                               size: 23)),




                       SizedBox(width: 10),

                       Expanded(child: Text(
                         quizList[currentQuestionIndex]["get_question_option"][pos]["option"],
                         style: TextStyle(
                           fontSize: 14,
                           fontWeight:FontWeight.w500,
                           color: Color(0xFF708096),
                         ),

                       )),

                       SizedBox(width: 6),


                     ],
                   ),
                 ):

                     Container(
                       height: 46,
                       margin: EdgeInsets.symmetric(horizontal: 13),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(4),
                           color: Color(0xFFF2F2F2),
                           border: Border.all(color: Color(0xFF707070),width: 0.3)
                       ),

                       child: Row(
                         children: [

                           SizedBox(width: 10),

                           GestureDetector(
                               onTap: () {

                               if(checkList.contains(quizList[currentQuestionIndex]["get_question_option"][pos]["id"]))
                                 {
                                   checkList.remove(quizList[currentQuestionIndex]["get_question_option"][pos]["id"]);
                                 }
                               else
                                 {
                                   checkList.add(quizList[currentQuestionIndex]["get_question_option"][pos]["id"]);
                                 }


                               setState(() {

                               });

                               },
                               child:checkList.contains(quizList[currentQuestionIndex]["get_question_option"][pos]["id"])
                                   ? Icon(Icons.check_box,
                                   color: AppTheme.orangeColor,
                                   size: 23)
                                   : Icon(Icons.check_box_outline_blank,
                                   color: Color(0xFFC6C6C6),
                                   size: 23)),




                           SizedBox(width: 10),

                           Expanded(child: Text(
                             quizList[currentQuestionIndex]["get_question_option"][pos]["option"],
                             style: TextStyle(
                               fontSize: 14,
                               fontWeight:selectedOption==1? FontWeight.w600:FontWeight.w500,
                               color: selectedOption==1?Color(0xFFFF7C00):Color(0xFF708096),
                             ),

                           )),

                           SizedBox(width: 6),


                         ],
                       ),
                     ),


                     SizedBox(height: 10)

                   ],
                 );
               }


               ),


               SizedBox(height: 10),





               Spacer(),

               InkWell(
                 onTap: (){

                   if(quizList[currentQuestionIndex]["type"]==0)
                     {

                       if(selectedOption==9999)
                         {
                           Toast.show("Please select an option to proceed",
                               duration: Toast.lengthLong,
                               gravity: Toast.bottom,
                               backgroundColor: Colors.red);
                         }

                       else
                         {
                           //All good


                           if(currentQuestionIndex==quizList.length-1)
                             {


                               answerList.add({
                                 "question_id":quizList[currentQuestionIndex]["id"].toString(),
                                 "answer_id":quizList[currentQuestionIndex]["get_question_option"][selectedOption]["id"].toString(),
                                 "user_id":AppModel.userID,
                                 "token":AppModel.token,
                               });

                               submitAnswers(context);
                               // Call Submit API


                             }
                           else
                             {

                               answerList.add({
                                 "question_id":quizList[currentQuestionIndex]["id"].toString(),
                                 "answer_id":quizList[currentQuestionIndex]["get_question_option"][selectedOption]["id"].toString(),
                                 "user_id":AppModel.userID,
                                 "token":AppModel.token,
                               });


                               currentQuestionIndex=currentQuestionIndex+1;
                               checkList.clear();
                               selectedOption=9999;
                               _start=120;
                               startTimer();
                               setState(() {

                               });
                             }






                         }


                     }
                   else
                     {
                       if(checkList.length<3)
                       {
                         Toast.show("Please select at least 3 options",
                             duration: Toast.lengthLong,
                             gravity: Toast.bottom,
                             backgroundColor: Colors.red);
                       }
                       else
                         {

                           if(currentQuestionIndex==quizList.length-1)
                           {
                             String answerIDs="";
                             for(int i=0;i<checkList.length;i++)
                             {

                               answerIDs=answerIDs+checkList[i].toString();
                               if(i!=checkList.length-1)
                               {
                                 answerIDs=answerIDs+",";
                               }
                             }


                             answerList.add({
                               "question_id":quizList[currentQuestionIndex]["id"].toString(),
                               "answer_id":answerIDs,
                               "user_id":AppModel.userID,
                               "token":AppModel.token,
                             });


                             submitAnswers(context);
                             // Call Submit API


                           }
                           else
                           {

                             String answerIDs="";
                             for(int i=0;i<checkList.length;i++)
                               {

                                 answerIDs=answerIDs+checkList[i].toString();
                                 if(i!=checkList.length-1)
                                   {
                                     answerIDs=answerIDs+",";
                                   }
                               }


                             answerList.add({
                               "question_id":quizList[currentQuestionIndex]["id"].toString(),
                               "answer_id":answerIDs,
                               "user_id":AppModel.userID,
                               "token":AppModel.token,
                             });


                             print("Answer ID");

                             print(answerIDs);





                             currentQuestionIndex=currentQuestionIndex+1;
                             checkList.clear();
                             selectedOption=9999;
                             _start=120;
                             startTimer();
                             setState(() {

                             });
                           }

                         }
                     }


                  // Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: MCQTestType2Screen()));

                 },
                 child: Container(
                     height: 57,
                     margin: const EdgeInsets.symmetric(horizontal: 13),
                     color: AppTheme.themeColor,
                     child: Center(child:   Text(
                       currentQuestionIndex==quizList.length-1?"Submit":
                       'Next',
                       style: TextStyle(
                         fontSize: 14.5,
                         fontWeight: FontWeight.w500,
                         color: Colors.white,
                       ),

                     ))
                 ),
               ),

               SizedBox(height: 16),


             ],
           ))














          ],
        ),
      ),
    );
  }


  submitAnswers(BuildContext context) async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Submitting answers...');

    Map<String,dynamic> dataObj={
      json.encode("audit_data"):json.encode(answerList)
    };


    var data = {
      "response":dataObj.toString(),
      "mapping_id":trainingData["mapping_id"].toString()

    };
    print("PAYLOAD");
    log(data.toString());

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('saveResponse', data, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FinalResultScreen(responseJSON["data"])),
              (Route<dynamic> route) => false);





    } else {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrainingDetails(context);

  }
  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }
  getTrainingDetails(BuildContext context) async {
    setState(() {
      isLoading=true;
    });
    var data = {
      "training_id":widget.trainingID

    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader('getTrainingQuiz', data, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    setState(() {
      isLoading=false;
    });

    trainingData=responseJSON["data"];
    quizList=responseJSON["data"]["questions"];
    startTimer();
    setState(() {

    });



  }


  void startTimer() {
    _start = 120;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
