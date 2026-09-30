import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/audio_recording_service.dart';

class RecordAudioScreen extends StatefulWidget {
  final String? auditId;
  final String? storeCode;

  // Audit details that will be displayed on the recording page.
  final String? storeName;
  final String? storeAddress;
  final String? auditDate;

  const RecordAudioScreen({
    super.key,
    this.auditId,
    this.storeCode,
    this.storeName,
    this.storeAddress,
    this.auditDate,
  });

  @override
  State<RecordAudioScreen> createState() =>
      _RecordAudioScreenState();
}

class _RecordAudioScreenState
    extends State<RecordAudioScreen>
    with WidgetsBindingObserver {

  bool _isRecording = false;
  bool _isLoading = true;

  String? _recordingFilePath;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _checkRecordingStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  // ============================================================
  // App Lifecycle
  // ============================================================

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {

    if (state == AppLifecycleState.resumed) {
      _checkRecordingStatus();
    }
  }

  // ============================================================
  // Check Native Recording Status
  // ============================================================

  Future<void> _checkRecordingStatus() async {

    try {

      final isRecording =
      await AudioRecordingService.isRecording();

      final filePath =
      await AudioRecordingService.getFilePath();

      if (!mounted) {
        return;
      }

      setState(() {

        _isRecording = isRecording;

        _recordingFilePath =
            filePath;
      });

    } catch (e) {

      debugPrint(
        'Error checking audio recording status: $e',
      );

    } finally {

      if (mounted) {

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // Start Recording
  // ============================================================

  String? _getStoreCode() {
    final storeCode = widget.storeCode?.trim();
    if (storeCode == null || storeCode.isEmpty) {
      return null;
    }
    return storeCode;
  }
  Future<void> _startRecording() async {
    if (_isRecording) {
      return;
    }

    try {
      // ---------------------------------------------------------
      // 1. Check microphone permission
      // ---------------------------------------------------------
      var permission = await Permission.microphone.status;

      if (!permission.isGranted) {
        permission = await Permission.microphone.request();
      }

      if (!permission.isGranted) {
        if (permission.isPermanentlyDenied) {
          await openAppSettings();
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Microphone permission is required to record audio.',
            ),
          ),
        );

        return;
      }

      // ---------------------------------------------------------
      // 2. Get Store Code
      // ---------------------------------------------------------
      final storeCode = _getStoreCode();

      if (storeCode == null || storeCode.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Store Code is not available. Unable to start recording.',
            ),
          ),
        );

        return;
      }

      // ---------------------------------------------------------
      // 3. Start native audio recording
      // ---------------------------------------------------------
      final started = await AudioRecordingService.startRecording(
        storeCode: storeCode,
        auditId: widget.auditId,
      );

      if (!started) {
        throw Exception('Native audio recording could not be started.');
      }

      // Give the Android service a moment to initialize.
      await Future.delayed(const Duration(milliseconds: 500));

      // ---------------------------------------------------------
      // 4. Verify recording status
      // ---------------------------------------------------------
      final isRecording =
      await AudioRecordingService.isRecording();

      if (!isRecording) {
        throw Exception(
          'Audio recording service did not start successfully.',
        );
      }

      // ---------------------------------------------------------
      // 5. Get public MediaStore path / URI
      // ---------------------------------------------------------
      final filePath =
      await AudioRecordingService.getFilePath();

      final fileUri =
      await AudioRecordingService.getFileUri();

      debugPrint(
        'Audio recording started',
      );

      debugPrint(
        'Audio File Path: $filePath',
      );

      debugPrint(
        'Audio File URI: $fileUri',
      );

      if (!mounted) return;

      setState(() {
        _isRecording = true;
        _recordingFilePath = filePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Audio recording started.',
          ),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        'Start audio recording error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to start audio recording: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // Stop Recording
  // ============================================================

  Future<void> _stopRecording() async {
    if (!_isRecording) {
      return;
    }

    try {
      // ---------------------------------------------------------
      // 1. Stop native recording
      // ---------------------------------------------------------
      final stopped =
      await AudioRecordingService.stopRecording();

      if (!stopped) {
        throw Exception(
          'Unable to stop audio recording.',
        );
      }

      // ---------------------------------------------------------
      // 2. Wait for MediaStore finalization
      // ---------------------------------------------------------
      String? filePath;
      String? fileUri;

      for (int i = 0; i < 10; i++) {
        await Future.delayed(
          const Duration(milliseconds: 300),
        );

        filePath =
        await AudioRecordingService.getFilePath();

        fileUri =
        await AudioRecordingService.getFileUri();

        if (filePath != null &&
            filePath.isNotEmpty &&
            fileUri != null &&
            fileUri.isNotEmpty) {
          break;
        }
      }

      debugPrint(
        'Stopped audio recording',
      );

      debugPrint(
        'Audio File Path: $filePath',
      );

      debugPrint(
        'Audio File URI: $fileUri',
      );

      if (filePath == null || filePath.isEmpty) {
        throw Exception(
          'Audio file path could not be retrieved.',
        );
      }

      if (fileUri == null || fileUri.isEmpty) {
        throw Exception(
          'Audio file URI could not be retrieved.',
        );
      }

      // ---------------------------------------------------------
      // 3. Update UI
      // ---------------------------------------------------------
      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _recordingFilePath = filePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Audio recording saved successfully.',
          ),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        'Stop audio recording error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        _isRecording = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save audio recording: $e',
          ),
        ),
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }


  // ============================================================
  // Permission Settings Dialog
  // ============================================================

  Future<void> _showPermissionSettingsDialog() async {

    await showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text(
            'Microphone Permission Required',
          ),

          content: const Text(
            'Microphone permission has been '
                'permanently denied. Please enable it '
                'from App Settings to record audio.',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {

                Navigator.pop(context);

                await openAppSettings();
              },
              child: const Text(
                'Open Settings',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // Message
  // ============================================================

  void _showMessage(String message) {

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: !_isRecording,

      onPopInvokedWithResult:
          (didPop, result) {

        if (_isRecording && !didPop) {

          _showMessage(
            'Please stop the audio recording '
                'before leaving this screen.',
          );
        }
      },

      child: Scaffold(

        appBar: AppBar(
          title: const Text(
            'Record Audio',
          ),

          automaticallyImplyLeading:
          !_isRecording,
        ),

        body: _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(

          padding:
          const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ------------------------------------------------
              // Audit Details
              // ------------------------------------------------

              _buildAuditDetails(),

              const SizedBox(
                height: 24,
              ),

              // ------------------------------------------------
              // Recording Status
              // ------------------------------------------------

              _buildRecordingStatus(),

              const SizedBox(
                height: 24,
              ),

              // ------------------------------------------------
              // Start / Stop
              // ------------------------------------------------

              if (!_isRecording)
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton.icon(

                    onPressed:
                    _startRecording,

                    icon: const Icon(
                      Icons.mic,
                    ),

                    label: const Text(
                      'Start Audio Recording',
                    ),
                  ),
                ),

              if (_isRecording)
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton.icon(

                    onPressed:
                    _stopRecording,

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.red,
                      foregroundColor:
                      Colors.white,
                    ),

                    icon: const Icon(
                      Icons.stop,
                    ),

                    label: const Text(
                      'Stop Audio Recording',
                    ),
                  ),
                ),

              if (_recordingFilePath != null) ...[

                const SizedBox(
                  height: 24,
                ),

                _buildFileInformation(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Audit Details
  // ============================================================

  Widget _buildAuditDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Audit Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _buildDetailRow(
              'Audit ID',
              widget.auditId ?? '-',
            ),

            const SizedBox(height: 8),

            _buildDetailRow(
              'Store Code',
              widget.storeCode ?? '-',
            ),

            const SizedBox(height: 8),

            _buildDetailRow(
              'Store Name',
              widget.storeName ?? '-',
            ),

            const SizedBox(height: 8),

            _buildDetailRow(
              'Store Address',
              widget.storeAddress ?? '-',
            ),

            const SizedBox(height: 8),

            _buildDetailRow(
              'Audit Date',
              widget.auditDate ?? '-',
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Recording Status
  // ============================================================

  Widget _buildRecordingStatus() {

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: _isRecording
              ? Colors.red
              : Colors.grey.shade300,
        ),

        color: _isRecording
            ? Colors.red.withOpacity(0.05)
            : Colors.grey.shade50,
      ),

      child: Row(

        children: [

          Icon(
            _isRecording
                ? Icons.fiber_manual_record
                : Icons.mic_none,
            color: _isRecording
                ? Colors.red
                : Colors.grey,
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(

            child: Text(
              _isRecording
                  ? 'Audio Recording in Progress'
                  : 'Audio Recording Not Started',

              style: TextStyle(
                fontWeight:
                FontWeight.w600,

                color: _isRecording
                    ? Colors.red
                    : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // File Information
  // ============================================================

  Widget _buildFileInformation() {

    return Card(

      child: Padding(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              'Recording File',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              _recordingFilePath ?? '',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Detail Row
  // ============================================================

  Widget _buildDetailRow(
      String label,
      String value,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}