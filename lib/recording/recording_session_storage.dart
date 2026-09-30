import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecordingSession {
  final bool isRecording;

  final String userId;
  final String storeId;
  final String storeName;
  final String storeCode;
  final String storeAddress;
  final String beatplanId;
  final String authKey;
  final String fileName;

  final String quality;
  final int camera;

  final DateTime startTime;

  const RecordingSession({
    required this.isRecording,
    required this.userId,
    required this.storeId,
    required this.storeName,
    required this.storeCode,
    required this.storeAddress,
    required this.beatplanId,
    required this.authKey,
    required this.fileName,
    required this.quality,
    required this.camera,
    required this.startTime,
  });

  /// Convert the recording session into JSON.
  Map<String, dynamic> toJson() {
    return {
      'isRecording': isRecording,
      'userId': userId,
      'storeId': storeId,
      'storeName': storeName,
      'storeCode': storeCode,
      'storeAddress': storeAddress,
      'beatplanId': beatplanId,
      'authKey': authKey,
      'fileName': fileName,
      'quality': quality,
      'camera': camera,
      'startTime': startTime.toIso8601String(),
    };
  }

  /// Create a RecordingSession from JSON.
  factory RecordingSession.fromJson(
      Map<String, dynamic> json,
      ) {
    return RecordingSession(
      isRecording: json['isRecording'] == true,

      userId: json['userId']?.toString() ?? '',

      storeId: json['storeId']?.toString() ?? '',

      storeName: json['storeName']?.toString() ?? '',

      storeCode: json['storeCode']?.toString() ?? '',

      storeAddress: json['storeAddress']?.toString() ?? '',

      beatplanId: json['beatplanId']?.toString() ?? '',

      authKey: json['authKey']?.toString() ?? '',

      fileName: json['fileName']?.toString() ?? '',

      quality: json['quality']?.toString() ?? 'Low',

      camera: (json['camera'] as num?)?.toInt() ?? 1,

      startTime:
      DateTime.tryParse(
        json['startTime']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }
}

class RecordingSessionStorage {
  RecordingSessionStorage._();

  static final RecordingSessionStorage instance =
  RecordingSessionStorage._();

  /// Key used to store the active recording session.
  static const String _storageKey =
      'active_recording_session';

  /// Save the currently active recording session.
  Future<void> saveRecordingSession({
    required String userId,
    required String storeId,
    required String storeName,
    required String storeCode,
    required String storeAddress,
    required String beatplanId,
    required String authKey,
    required String fileName,
    required String quality,
    required int camera,
  }) async {
    final prefs =
    await SharedPreferences.getInstance();

    final session = RecordingSession(
      isRecording: true,
      userId: userId,
      storeId: storeId,
      storeName: storeName,
      storeCode: storeCode,
      storeAddress: storeAddress,
      beatplanId: beatplanId,
      authKey: authKey,
      fileName: fileName,
      quality: quality,
      camera: camera,
      startTime: DateTime.now(),
    );

    await prefs.setString(
      _storageKey,
      jsonEncode(session.toJson()),
    );
  }

  /// Get the currently saved recording session.
  ///
  /// Returns null when there is no active recording
  /// session stored.
  Future<RecordingSession?> getActiveSession() async {
    final prefs =
    await SharedPreferences.getInstance();

    final storedValue =
    prefs.getString(_storageKey);

    if (storedValue == null ||
        storedValue.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(storedValue);

      if (decoded is! Map) {
        return null;
      }

      final session =
      RecordingSession.fromJson(
        Map<String, dynamic>.from(decoded),
      );

      if (!session.isRecording) {
        return null;
      }

      return session;
    } catch (e) {
      return null;
    }
  }

  /// Check whether a recording session is currently
  /// stored.
  Future<bool> hasActiveRecording() async {
    final session =
    await getActiveSession();

    return session != null &&
        session.isRecording;
  }

  /// Remove the active recording session.
  ///
  /// This should be called only after the native
  /// recording has actually stopped or failed.
  Future<void> clearRecordingSession() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_storageKey);
  }
}