import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class VideoWidgetLocal extends StatefulWidget {

  final bool play;
  final File url;
  final Color loaderColor;
  bool? showControls;

  VideoWidgetLocal({required this.url, required this.play,required this.loaderColor,this.showControls});


  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidgetLocal> {
  late VideoPlayerController videoPlayerController ;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
    //  videoPlayerController.play();
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.pause();
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(8),
              // color: Colors.green,
            ),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(8),
                // color: Colors.green,
              ),
              child:   Stack(
                children: [
                  VideoPlayer(videoPlayerController),

                   Center(
                     child:

                     Icon(Icons.play_arrow_rounded,size: 68,color: Colors.white)
                   )


                 // Controls(controller: videoPlayerController,iconSize: 70):Container(),
                ],
              ),
            ),
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(

              valueColor: AlwaysStoppedAnimation<Color>(widget.loaderColor),
            ),);
        }
      },
    );
  }
}