import 'dart:async';
import 'dart:io' as io;


import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart' show DateFormat;
import 'package:toast/toast.dart';
import 'package:workmanager/workmanager.dart';

import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';



class RecordAudioScreen2 extends StatefulWidget {
  final String beatID;
  final String storeID;

  RecordAudioScreen2(this.beatID,this.storeID);




  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<RecordAudioScreen2> {

  String? pathToAudio;
  bool _playAudio = false;
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  AudioPlayer audioPlayer = AudioPlayer();
  Timer? _timer;
  int _start = 0;
  String _timerText = '00:00:00';
  @override
  void initState() {
    super.initState();
    init();

  }

  init()async{
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    String customPath = '/another_audio_recorder_';
    io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = (await getExternalStorageDirectory())!;
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();
    pathToAudio=customPath;
    _recorder = AnotherAudioRecorder(pathToAudio.toString(), audioFormat: AudioFormat.WAV);

    await _recorder?.initialized;
    var current = await _recorder?.current(channel: 0);
    print(current);
    // should be "Initialized", if all working fine
    setState(() {
      _current = current;
      _currentStatus = current!.status!;
      print(_currentStatus);
    });
  }

  formattedTime({required int timeInSecond}) async {

    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [

            SizedBox(height: 25),


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
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                        },
                        child:Icon(Icons.keyboard_backspace_rounded)),



                    SizedBox(width: 80),


                    Center(
                      child: Text("Audio Recorder",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )),
                    ),



                  ],
                ),
              ),
            ),


            SizedBox(height: 20),


            _current!=null?Center(
              child: Text(
                _printDuration(_current!.duration),
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ):Container(),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                createElevatedButton(
                  icon: Icons.mic,
                  iconColor: Colors.red,
                  onPressFunc: _startRec,
                ),
                SizedBox(
                  width: 30,
                ),
                createElevatedButton(
                  icon: Icons.stop,
                  iconColor: Colors.red,
                  onPressFunc: _stop,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),

            _currentStatus!=RecordingStatus.Unset && _currentStatus==RecordingStatus.Stopped?
            ElevatedButton.icon(
              style:
              ElevatedButton.styleFrom(elevation: 9.0),
              onPressed: () {
              if(_playAudio)
                {
                  onPauseAudio();
                }
              else
                {
                  onPlayAudio();
                }
              },
              icon: _playAudio
                  ? Icon(
                Icons.stop,
              )
                  : Icon(Icons.play_arrow),
              label: _playAudio
                  ? Text(
                "Stop",
                style: TextStyle(
                  fontSize: 26,
                ),
              )
                  : Text(
                "Play",
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ):Container(),


            SizedBox(height: 40),
            _currentStatus!=RecordingStatus.Unset && _currentStatus==RecordingStatus.Stopped?

            InkWell(
              onTap: () {

                uploadInBackground("1", pathToAudio.toString());


              //  Navigator.pop(context,pathToAudio.toString());




              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 60),
                  decoration: BoxDecoration(
                      color: AppTheme.themeColor,
                      borderRadius: BorderRadius.circular(5)),
                  height: 49,
                  child: const Center(
                    child: Text('Upload',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  )),
            ):Container()



          ],
        )
      ),
    );
  }


  uploadInBackground(String fileType,String filePath) async {


    Toast.show("Uploading audio in background...",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);



    await Workmanager().registerOneOffTask(
      "id1" + DateTime.now().millisecondsSinceEpoch.toString(),
      "uploadFileTask12" + DateTime.now().millisecondsSinceEpoch.toString(),
      inputData: <String, dynamic>{
        'filesPath': filePath,
        'beat_id': widget.beatID,
        'store_id': widget.storeID,
        'user_id':AppModel.userID,
        'token':AppModel.token,
        'file_type':fileType
      },
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      existingWorkPolicy: ExistingWorkPolicy.append,
    );



    Navigator.pop(context);




  }


  _stop() async {
    var result = await _recorder?.stop();
    print("Stop recording: ${result?.path}");
    print("Stop recording: ${result?.duration}");
    /*File file = File(result?.path.toString());
    print("File length: ${await file.length()}");*/
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
      pathToAudio=result?.path.toString();
    });
  }
  _startRec() async {
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
       Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void onPlayAudio() async {

    Source source = DeviceFileSource(pathToAudio.toString());
    await audioPlayer.play(source);
    _playAudio=true;
    setState(() {

    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      if(s==PlayerState.completed)
        {
          _playAudio=false;
          setState(() {

          });
        }
    }
  );
  }

  void onPauseAudio() async {
    await audioPlayer.pause();
    _playAudio=false;
    setState(() {

    });
  }
  ElevatedButton createElevatedButton(
      {IconData? icon, Color? iconColor, Function? onPressFunc}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(5.0),
        side: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 9.0,
      ),
      onPressed:(){
       onPressFunc!();
      },
      icon: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Icon(
          icon,
          color: iconColor,
          size: 35.0,
        ),
      ),
      label: Text(''),
    );
  }



@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  String _printDuration(Duration? duration) {
    String negativeSign = duration!.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}