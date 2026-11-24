import 'package:flutter/material.dart';
import 'package:shopperxm_flutter/recording/record_audio_screen_updated.dart';
import 'package:shopperxm_flutter/services/audio_recording_service_updated.dart';
import '../models/audio_recording_model.dart';
import 'package:shopperxm_flutter/main.dart';


class AudioRecordingRecovery {
  static bool _isNavigating = false;

  static Future<void> checkAndRestore() async {

    if (_isNavigating) return;

    final service = AudioRecordingServiceUpdated();

    try {
      final status = await service.getNativeStatus();

      if (status['isRecording'] != true) {
        return;
      }

      final details = await service.getSavedRecording();

      if (details == null) {
        // Do not silently start a new recording.
        // Show a recovery/error state instead.
        return;
      }

      _isNavigating = true;

      final navigator = appNavigatorKey.currentState;

      if (navigator == null) {
        _isNavigating = false;
        return;
      }

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RecordAudioScreenUpdated(
            beatplanId: details.beatplanId,
            storeId: details.storeId,
            storeName: details.storeName,
            auditDate: details.auditDate,
            storeAddress: "",
          ),
        ),
            (route) => false,
      );

    } catch (e) {
      debugPrint(
        'Audio recording recovery error: $e',
      );
    } finally {
      _isNavigating = false;
    }
  }
}
