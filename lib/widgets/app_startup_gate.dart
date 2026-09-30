import 'package:flutter/material.dart';

import '../services/audio_recording_startup.dart';

class AppStartupGate extends StatefulWidget {

  final Widget child;

  const AppStartupGate({
    super.key,
    required this.child,
  });

  @override
  State<AppStartupGate> createState() =>
      _AppStartupGateState();
}

class _AppStartupGateState
    extends State<AppStartupGate> {

  bool _checked = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        _checkAudioRecording();
      },
    );
  }

  Future<void> _checkAudioRecording() async {

    if (_checked) {
      return;
    }

    _checked = true;

    await AudioRecordingStartup.checkAndRedirect(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}