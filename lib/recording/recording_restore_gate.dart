import 'package:flutter/material.dart';
import 'recording_controller.dart';
import 'recording_screen.dart';
import 'recording_session_storage.dart';

class RecordingRestoreGate extends StatefulWidget {
  final Widget child;

  const RecordingRestoreGate({
    super.key,
    required this.child,
  });

  @override
  State<RecordingRestoreGate> createState() =>
      _RecordingRestoreGateState();
}

class _RecordingRestoreGateState extends State<RecordingRestoreGate> {
  final RecordingController _controller = RecordingController.instance;

  final RecordingSessionStorage _sessionStorage =
      RecordingSessionStorage.instance;

  bool _checking = true;

  RecordingSession? _activeSession;

  @override
  void initState() {
    super.initState();
    _checkActiveRecording();
  }

  Future<void> _checkActiveRecording() async {
    try {
      debugPrint('Checking active recording...');

      // Get the persisted Flutter session.
      final session = await _sessionStorage.getActiveSession();

      debugPrint(
        'Stored recording session: '
            '${session == null ? "NONE" : "FOUND"}',
      );

      // Ask Android whether recording is actually running.
      final isNativeRecording =
      await _controller.checkRecordingStatus();

      debugPrint(
        'Native recording status: $isNativeRecording',
      );

      if (!mounted) return;

      if (isNativeRecording && session != null) {
        debugPrint(
          'Active recording found. Restoring RecordingScreen.',
        );

        setState(() {
          _activeSession = session;
          _checking = false;
        });

        return;
      }

      // ----------------------------------------------------------
      // Stale session protection
      // ----------------------------------------------------------
      //
      // If Flutter has saved a session but Android says there is
      // no active recording, the saved session is stale.
      //
      // Remove it so the app doesn't incorrectly redirect to
      // RecordingScreen on every launch.
      //
      if (!isNativeRecording && session != null) {
        debugPrint(
          'Stale recording session found. Clearing it.',
        );

        await _sessionStorage.clearRecordingSession();
      }

      if (!mounted) return;

      setState(() {
        _activeSession = null;
        _checking = false;
      });
    } catch (e, stackTrace) {
      debugPrint(
        'Error checking active recording: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        _activeSession = null;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final session = _activeSession;

    if (session != null) {
      return RecordingScreen(
        userId: session.userId,
        storeId: session.storeId,
        storeName: session.storeName,
        storeCode: session.storeCode,
        storeAddress: session.storeAddress,
        beatplanId: session.beatplanId,
        authKey: session.authKey,
        quality: session.quality,
        camera: session.camera,
      );
    }

    return widget.child;
  }
}