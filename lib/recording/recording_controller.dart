import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'recording_event.dart';


class RecordingController {
  RecordingController._();

  static final RecordingController instance =
  RecordingController._();

  static const MethodChannel _methodChannel =
  MethodChannel('retailiq/recording');

  static const EventChannel _eventChannel =
  EventChannel('retailiq/recording_events');

  Stream<RecordingEvent>? _eventStream;

  Stream<RecordingEvent> get events {
    if (!Platform.isAndroid) {
      return const Stream<RecordingEvent>.empty();
    }

    _eventStream ??= _eventChannel
        .receiveBroadcastStream()
        .map<RecordingEvent>((dynamic event) {

      if (event is Map) {
        return RecordingEvent.fromMap(
          Map<String, dynamic>.from(event),
        );
      }

      return const RecordingEvent(
        type: RecordingEventType.unknown,
      );
    });

    return _eventStream!;
  }

  bool _isRecording = false;

  bool get isRecording => _isRecording;


  Future<bool> startRecording({
    required String userId,
    required String storeId,
    required String beatplanId,
    required String authKey,
    required String fileName,
    String quality = 'Low',
    int camera = 1,
  }) async {

    if (!Platform.isAndroid) {
      return false;
    }

    // ------------------------------------------------------------
    // STEP 1: Request camera + microphone permissions
    // BEFORE starting the foreground service.
    // ------------------------------------------------------------

    final permissionsGranted =
    await _requestRecordingPermissions();

    if (!permissionsGranted) {
      throw const RecordingException(
        code: 'RECORDING_PERMISSION_DENIED',
        message:
        'Camera and microphone permissions are required to record video.',
      );
    }
    // ------------------------------------------------------------
    // STEP 2: Start native recording service
    // ------------------------------------------------------------


    try {

      final bool? result =
      await _methodChannel.invokeMethod<bool>(
        'startRecording',
        <String, dynamic>{

          'user_id': userId,

          'store_id': storeId,

          'beatplan_id': beatplanId,

          'authKey': authKey,

          'file_name': fileName,

          'quality': quality,

          'camera': camera,
        },
      );

      return result ?? false;

    } on PlatformException catch (e) {

      throw RecordingException(
        code: e.code,
        message:
        e.message ??
            'Unable to start recording.',
      );

    } catch (e) {

      throw RecordingException(
        code: 'START_RECORDING_FAILED',
        message: e.toString(),
      );
    }
  }


  Future<bool> stopRecording() async {

    if (!Platform.isAndroid) {
      return false;
    }

    try {

      final bool? result =
      await _methodChannel.invokeMethod<bool>(
        'stopRecording',
      );

      return result ?? false;

    } on PlatformException catch (e) {

      throw RecordingException(
        code: e.code,
        message:
        e.message ??
            'Unable to stop recording.',
      );

    } catch (e) {

      throw RecordingException(
        code: 'STOP_RECORDING_FAILED',
        message: e.toString(),
      );
    }
  }


  Future<bool> checkRecordingStatus() async {

    if (!Platform.isAndroid) {
      _isRecording = false;
      return false;
    }

    try {

      final bool? result =
      await _methodChannel.invokeMethod<bool>(
        'isRecording',
      );

      _isRecording = result ?? false;

      return _isRecording;

    } on PlatformException catch (e) {

      throw RecordingException(
        code: e.code,
        message:
        e.message ??
            'Unable to check recording status.',
      );

    } catch (e) {

      throw RecordingException(
        code: 'STATUS_CHECK_FAILED',
        message: e.toString(),
      );
    }
  }
  Future<bool> _requestRecordingPermissions() async {
    if (!Platform.isAndroid) {
      return false;
    }

    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final cameraGranted =
        statuses[Permission.camera]?.isGranted ?? false;

    final microphoneGranted =
        statuses[Permission.microphone]?.isGranted ?? false;

    debugPrint(
      'Recording permissions -> '
          'camera=$cameraGranted, '
          'microphone=$microphoneGranted',
    );

    return cameraGranted && microphoneGranted;
  }


  void updateState(
      RecordingEvent event,
      ) {

    switch (event.type) {

      case RecordingEventType.started:
        _isRecording = true;
        break;

      case RecordingEventType.stopping:
        break;

      case RecordingEventType.stopped:
        _isRecording = false;
        break;

      case RecordingEventType.error:
        _isRecording = false;
        break;

      case RecordingEventType.idle:
        _isRecording = false;
        break;

      case RecordingEventType.unknown:
        break;
    }
  }
}


class RecordingException implements Exception {

  final String code;

  final String message;

  const RecordingException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {

    return 'RecordingException($code): $message';
  }
}