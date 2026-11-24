
import 'package:flutter/foundation.dart';
import '../models/audio_recording_model.dart';
import '../services/audio_recording_service_updated.dart';

class AudioRecordingController extends ChangeNotifier {
  final AudioRecordingServiceUpdated _service =
  AudioRecordingServiceUpdated();

  bool isRecording = false;
  bool isLoading = false;
  String? errorMessage;

  AudioRecordingModel? recordingDetails;



  Future<void> checkRecordingStatus() async {
    isLoading = true;
    notifyListeners();

    try {
      final status = await _service.getNativeStatus();
      errorMessage = null;
      isRecording = status['isRecording'] == true;

      if (isRecording) {
        recordingDetails =
        await _service.getSavedRecording();

        // If metadata is missing, don't allow a new recording
        // against a different store. Report a recovery issue.
        if (recordingDetails == null) {
          errorMessage =
          'Recording is active, but store details could not be recovered.';
        }
      } else {
        recordingDetails = null;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> startRecording({
    required String beatplanId,
    required String storeId,
    required String storeName,
    required String auditDate,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {

      if (beatplanId.trim().isEmpty ||
          storeId.trim().isEmpty ||
          storeName.trim().isEmpty ||
          auditDate.trim().isEmpty) {
        throw Exception(
          'Store details are missing. Please reopen the store and try again.',
        );
      }

      final model = AudioRecordingModel(
        recordingId: DateTime.now().microsecondsSinceEpoch.toString(),
        beatplanId: beatplanId,
        storeId: storeId,
        storeName: storeName,
        auditDate: auditDate,
        fileName: '',
        status: 'recording',
        startedAt: DateTime.now(),
      );

      debugPrint('Starting audio recording:');
      debugPrint('Recording ID: ${model.recordingId}');
      debugPrint('Beatplan ID: ${model.beatplanId}');
      debugPrint('Store ID: ${model.storeId}');
      debugPrint('Store Name: ${model.storeName}');
      debugPrint('Audit Date: ${model.auditDate}');

      await _service.startRecording(model);



      // Allow Android's service to process the start request.
      await Future.delayed(const Duration(milliseconds: 500));

      final status = await _service.getNativeStatus();

      if (status['isRecording'] != true) {
        throw Exception(
          'Android accepted the request, but recording is not active. '
              'Check Android Logcat for the recording service error.',
        );
      }


      isRecording = true;
      recordingDetails = await _service.getSavedRecording() ?? model;
    } catch (e) {
      isRecording = false;
      errorMessage = e.toString();
      debugPrint('Start audio recording error: $e');
    }finally{
      isLoading = false;
      notifyListeners();
    }


  }

  Future<void> stopRecording() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.stopRecording();

      isRecording = false;
      recordingDetails = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
