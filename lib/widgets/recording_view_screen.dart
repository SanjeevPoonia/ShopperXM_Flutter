import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopperxm_flutter/widgets/common.dart';




class RecordingView extends StatefulWidget
{
  final String url;
  RecordingView(this.url);
  RecordingViewState createState()=>RecordingViewState();
}


class RecordingViewState extends State<RecordingView> with WidgetsBindingObserver
{
  final player = AudioPlayer();
  Duration? _duration;
  Duration? _position;
  PlayerState? _playerState;
  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(top: 35,left: 15),

            child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },

                child: Icon(Icons.close,color: Colors.black,size: 35)),

          ),


          Expanded(
            child: Center(
              child:   Image.asset("assets/music_ic.png"),
            ),
          ),


          Container(
            height: 200,
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const Key('play_button'),
                      onPressed: _isPlaying ? null : _play,
                      iconSize: 48.0,
                      icon: const Icon(Icons.play_arrow),
                      color: Colors.white,
                    ),
                    IconButton(
                      key: const Key('pause_button'),
                      onPressed: _isPlaying ? _pause : null,
                      iconSize: 48.0,
                      icon: const Icon(Icons.pause),
                      color: Colors.white,
                    ),
                    IconButton(
                      key: const Key('stop_button'),
                      onPressed: _isPlaying || _isPaused ? _stop : null,
                      iconSize: 48.0,
                      icon: const Icon(Icons.stop),
                      color: Colors.white,
                    ),
                  ],
                ),
                Slider(
                  onChanged: (value) {
                    final duration = _duration;
                    if (duration == null) {
                      return;
                    }
                    final position = value * duration.inMilliseconds;
                    player.seek(Duration(milliseconds: position.round()));
                  },
                  value: (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                      ? _position!.inMilliseconds / _duration!.inMilliseconds
                      : 0.0,
                ),
                Text(
                  _position != null
                      ? '$_positionText / $_durationText'
                      : _duration != null
                      ? _durationText
                      : '',
                  style: const TextStyle(fontSize: 16.0,color: Colors.white),
                ),
              ],
            ),
          ),




        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
        _duration = value;
      }),
    );
    player.getCurrentPosition().then(
          (value) => setState(() {
        _position = value;
      }),
    );

    _initStreams();
  }
  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
          (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
          setState(() {
            _playerState = state;
          });
        });
  }

  Future<void> _play() async {
    await player.play(UrlSource(widget.url));
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
  playAudio(String url) async {

    try {

      final player = AudioPlayer();
      await player.play(UrlSource(url));


    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }
}

