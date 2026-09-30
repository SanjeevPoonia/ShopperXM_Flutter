import 'package:flutter/material.dart';
import 'package:shopperxm_flutter/recording/record_audio_screen.dart';
import 'audio_recording_service.dart';

class AudioRecordingStartup {

  static Future<void> checkAndRedirect(
      BuildContext context,
      ) async {

    try {

      final isRecording =
      await AudioRecordingService.isRecording();

      if (!isRecording) {
        return;
      }

      final auditId =
      await AudioRecordingService.getAuditId();

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RecordAudioScreen(
            auditId: auditId,
          ),
        ),
            (route) => false,
      );

    } catch (e) {

      debugPrint(
        'Audio recording startup check failed: $e',
      );
    }
  }
}