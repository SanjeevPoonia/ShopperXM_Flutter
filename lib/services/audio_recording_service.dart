import 'package:flutter/services.dart';

class AudioRecordingService {
  static const MethodChannel _channel =
  MethodChannel('com.qdegrees.shopperxm/audio_recording');

  /// Start audio recording.
  ///
  /// The native Android service creates the public file:
  /// Movies/RetailIQ/<storeCode>/Audio/
  static Future<bool> startRecording({
    required String storeCode,
    String? auditId,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'startAudioRecording',
        {
          'store_code': storeCode,
          'audit_id': auditId,
        },
      );

      return result ?? false;
    } on PlatformException catch (e) {
      print(
        'Start audio recording failed: '
            '${e.code} - ${e.message}',
      );

      return false;
    } catch (e) {
      print('Start audio recording failed: $e');
      return false;
    }
  }

  /// Stop audio recording.
  static Future<bool> stopRecording() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'stopAudioRecording',
      );

      return result ?? false;
    } on PlatformException catch (e) {
      print(
        'Stop audio recording failed: '
            '${e.code} - ${e.message}',
      );

      return false;
    } catch (e) {
      print('Stop audio recording failed: $e');
      return false;
    }
  }

  /// Check whether audio recording is currently active.
  static Future<bool> isRecording() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'isAudioRecording',
      );

      return result ?? false;
    } on PlatformException catch (e) {
      print(
        'Get audio recording status failed: '
            '${e.code} - ${e.message}',
      );

      return false;
    } catch (e) {
      print('Get audio recording status failed: $e');
      return false;
    }
  }

  /// Returns a display path such as:
  ///
  /// /storage/emulated/0/Movies/RetailIQ/STORE001/Audio/audio_xxx.m4a
  static Future<String?> getFilePath() async {
    try {
      return await _channel.invokeMethod<String>(
        'getAudioRecordingFilePath',
      );
    } on PlatformException catch (e) {
      print(
        'Get audio file path failed: '
            '${e.code} - ${e.message}',
      );

      return null;
    } catch (e) {
      print('Get audio file path failed: $e');
      return null;
    }
  }

  /// Returns the MediaStore content URI.
  ///
  /// Example:
  /// content://media/external/file/12345
  static Future<String?> getFileUri() async {
    try {
      return await _channel.invokeMethod<String>(
        'getAudioRecordingFileUri',
      );
    } on PlatformException catch (e) {
      print(
        'Get audio file URI failed: '
            '${e.code} - ${e.message}',
      );

      return null;
    } catch (e) {
      print('Get audio file URI failed: $e');
      return null;
    }
  }

  /// Returns the audit ID associated with the recording.
  static Future<String?> getAuditId() async {
    try {
      return await _channel.invokeMethod<String>(
        'getAudioRecordingAuditId',
      );
    } on PlatformException catch (e) {
      print(
        'Get audio audit ID failed: '
            '${e.code} - ${e.message}',
      );

      return null;
    } catch (e) {
      print('Get audio audit ID failed: $e');
      return null;
    }
  }

  /// Returns the store code associated with the recording.
  static Future<String?> getStoreCode() async {
    try {
      return await _channel.invokeMethod<String>(
        'getAudioRecordingStoreCode',
      );
    } on PlatformException catch (e) {
      print(
        'Get audio store code failed: '
            '${e.code} - ${e.message}',
      );

      return null;
    } catch (e) {
      print('Get audio store code failed: $e');
      return null;
    }
  }
}