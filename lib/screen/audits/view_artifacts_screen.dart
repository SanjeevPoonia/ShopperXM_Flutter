import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;


import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopperxm_flutter/screen/audits/tagged_audits.dart';
import 'package:shopperxm_flutter/utils/app_theme.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:shopperxm_flutter/widgets/full_video_screen.dart';

import 'package:toast/toast.dart';
import 'package:shopperxm_flutter/screen/zoom_scaffold.dart' as MEN;
import 'package:video_player/video_player.dart';
import 'package:workmanager/workmanager.dart';

import '../../widgets/recording_view_screen.dart';
import '../../widgets/video_widget_local.dart';


class ViewArtifactScreen extends StatefulWidget {
  final List<dynamic> artifactsList;
  ViewArtifactScreen(this.artifactsList);
  @override
  ViewArtifactState createState() => ViewArtifactState();
}

class ViewArtifactState extends State<ViewArtifactScreen> {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
              ),
              child: Container(
                height: 69,
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                        },
                        child:Icon(Icons.keyboard_backspace_rounded)),


                    Text("View Artifacts",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        )),

                    Image.asset("assets/bell_ic.png",width: 23,height: 23)


                  ],
                ),
              ),
            ),

            SizedBox(height: 5),



            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 12, right: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    crossAxisCount: 3,
                    childAspectRatio: (2 / 2)),
                itemCount: widget.artifactsList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {

                      if(lookupMimeType(widget.artifactsList[index]["path"]).toString().startsWith('video/'))
                        {

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>FullVideoScreen(widget.artifactsList[index]["path"])));


                        }
                      else
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordingView(widget.artifactsList[index]["path"])));

                        }




                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: Colors.black),
                          ),

                      child: Center(
                        child:
                        lookupMimeType(widget.artifactsList[index]["path"]).toString().startsWith('video/')?
                            
                        Image.asset("assets/ic_video.png",width: 60,height: 60)
                            
                      //  Icon(Icons.videocam_outlined,color: Colors.red,size: 35)
                       /* VideoWidgetLocal( url:io.File(widget.artifactsList[index]["path"]),
                            play: false,
                            loaderColor: AppTheme.themeColor)*/:

                        Image.asset("assets/music_ic.png",width: 60,height: 60)




                        ,
                      ),
                    ),
                  );
                  // Item rendering
                },
              ),
            ),















            SizedBox(height: 20),






          ],
        )
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



}
