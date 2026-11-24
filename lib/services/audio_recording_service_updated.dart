
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/audio_recording_model.dart';

class AudioRecordingServiceUpdated {
  static const MethodChannel _channel = MethodChannel(
    'com.qdegrees.shopperxm/audio_recording',
  );
  static const String _activeRecordingKey =
      'shopperxm_active_audio_recording';
  static const String _lastRecordingKey =
      'shopperxm_last_audio_recording';

  Future<AudioRecordingModel?> getSavedRecording() async {
    final status = await getNativeStatus();
    if (status['recordingId'] == null) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_activeRecordingKey);
    if (jsonString == null) return null;
    try {
      return AudioRecordingModel.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }
  Future<bool> hasMicrophonePermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) return true;

    final result = await Permission.microphone.request();

    return result.isGranted;
  }
  Future<Map<String, dynamic>> getNativeStatus() async {
    final result = await _channel.invokeMethod<dynamic>(
      'getAudioRecordingStatus',
    );

    return Map<String, dynamic>.from(result as Map);
  }

  Future<bool> isRecordingActive() async {
    try {
      final status = await getNativeStatus();

      return status['isRecording'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> startRecording(
      AudioRecordingModel model,
      )
  async {
    if (model.recordingId.isEmpty ||
        model.storeId.isEmpty ||
        model.beatplanId.isEmpty) {
      throw Exception(
        'Recording ID, Store ID and Beatplan ID are required.',
      );
    }


    final permissionGranted =
    await hasMicrophonePermission();

    if (!permissionGranted) {
      throw Exception(
        'Microphone permission is required to record audio.',
      );
    }

    final prefs = await SharedPreferences.getInstance();

    // Prevent starting a second recording.
    if (await isRecordingActive()) {
      throw Exception(
        'Another audio recording is already running.',
      );
    }

    // Save store details BEFORE starting native recording.
    await prefs.setString(
      _activeRecordingKey,
      jsonEncode(model.toJson()),
    );

    final result = await _channel.invokeMethod<bool>(
      'startAudioRecording',
      {
        'recordingId': model.recordingId,
        'beatplanId': model.beatplanId,
        'storeId': model.storeId,
        'storeName': model.storeName,
        'auditDate': model.auditDate,
      },
    );
    if (result != true) {
      throw Exception('Unable to send audio recording start request.');
    }
    if (result == null) {
      throw Exception('Unable to start audio recording.');
    }
  }

  Future<Map<String, dynamic>> stopRecording() async {
    final result = await _channel.invokeMethod<dynamic>(
      'stopAudioRecording',
    );

    final data = Map<String, dynamic>.from(result as Map);

    final prefs = await SharedPreferences.getInstance();

    final saved = await getSavedRecording();

    if (saved != null) {
      final completed = saved.toJson();

      completed['status'] = 'completed';
      completed['filePath'] = data['filePath'];
      completed['fileUri'] = data['fileUri'];
      completed['fileName'] =
          data['fileName'] ?? saved.fileName;

      await prefs.setString(
        _lastRecordingKey,
        jsonEncode(completed),
      );
    }

    await prefs.remove(_activeRecordingKey);

    return data;
  }

  Future<void> clearActiveRecording() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeRecordingKey);
  }
}
