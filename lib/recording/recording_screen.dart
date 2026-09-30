import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'recording_controller.dart';
import 'recording_event.dart';
import 'recording_session_storage.dart';

class RecordingScreen extends StatefulWidget {
  final String userId;
  final String storeId;
  final String beatplanId;
  final String authKey;
  final String storeName;
  final String storeCode;
  final String storeAddress;
  final String quality;
  final int camera;
  const RecordingScreen({
    super.key,
    required this.userId,
    required this.storeId,
    required this.beatplanId,
    required this.authKey,
    required this.storeName,
    required this.storeCode,
    required this.storeAddress,
    this.quality = 'Low',
    this.camera = 1,
  });
  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}
class _RecordingScreenState extends State<RecordingScreen> {
  final RecordingController _controller = RecordingController.instance;
  StreamSubscription<RecordingEvent>? _eventSubscription;
  RecordingEventType _status = RecordingEventType.idle;
  String? _videoFileName;
  String? _videoPath;
  String? _videoUri;
  String? _errorMessage;
  bool _isStarting = false;
  bool _isStopping = false;

  final RecordingSessionStorage _sessionStorage = RecordingSessionStorage.instance;

  @override
  void initState() {
    super.initState();

    _initializeRecording();
  }

  Future<void> _initializeRecording() async {
    if (!Platform.isAndroid) {
      return;
    }

    _eventSubscription =
        _controller.events.listen(
          _handleRecordingEvent,
          onError: (Object error) {
            if (!mounted) {
              return;
            }

            setState(() {
              _status = RecordingEventType.error;
              _errorMessage = error.toString();
              _isStarting = false;
              _isStopping = false;
            });
          },
        );

    try {
      final isRecording =
      await _controller.checkRecordingStatus();

      if (!mounted) {
        return;
      }

      setState(() {
        _status = isRecording
            ? RecordingEventType.started
            : RecordingEventType.idle;
      });
    } catch (e) {
      debugPrint(
        'Recording status check failed: $e',
      );
    }
  }

  Future<void> _handleRecordingEvent(
      RecordingEvent event,
      ) async {
    if (!mounted) {
      return;
    }

    debugPrint(
      'Recording event: ${event.type}',
    );

    switch (event.type) {
      case RecordingEventType.started:
        setState(() {
          _status = RecordingEventType.started;
          _isStarting = false;
          _isStopping = false;
          _errorMessage = null;
          if (event.fileName != null) {
            _videoFileName =
                event.fileName;
          }
        });
        try {
          await _sessionStorage.saveRecordingSession(
            userId: widget.userId,
            storeId: widget.storeId,
            storeName: widget.storeName,
            storeCode: widget.storeCode,
            storeAddress: widget.storeAddress,
            beatplanId: widget.beatplanId,
            authKey: widget.authKey,
            fileName:
            event.fileName ??
                _videoFileName ??
                '',
            quality: widget.quality,
            camera: widget.camera,
          );

          debugPrint(
            'Recording session saved successfully. '
                'storeId=${widget.storeId}, '
                'storeName=${widget.storeName}, '
                'beatplanId=${widget.beatplanId}',
          );
        } catch (e) {
          debugPrint(
            'Failed to save recording session: $e',
          );
        }

        break;

      case RecordingEventType.stopping:
        setState(() {
          _status =
              RecordingEventType.stopping;

          _isStarting = false;
          _isStopping = true;
        });

        break;

      case RecordingEventType.stopped:
        setState(() {
          _status =
              RecordingEventType.stopped;

          _isStarting = false;
          _isStopping = false;

          _videoFileName =
              event.fileName;

          _videoPath =
              event.path;

          _videoUri =
              event.uri;
        });

        try {
          await _sessionStorage.clearRecordingSession();

          debugPrint(
            'Recording session cleared after recording stopped.',
          );
        } catch (e) {
          debugPrint(
            'Failed to clear recording session: $e',
          );
        }

        _showRecordingCompleted();

        break;

      case RecordingEventType.error:
        setState(() {
          _status =
              RecordingEventType.error;

          _isStarting = false;
          _isStopping = false;

          _errorMessage =
              event.message ??
                  'Recording failed.';
        });
        try {
          await _sessionStorage.clearRecordingSession();
          debugPrint(
            'Recording session cleared after recording error.',
          );
        } catch (e) {
          debugPrint(
            'Failed to clear recording session after error: $e',
          );
        }


        _showError(
          event.message ??
              'Recording failed.',
        );

        break;

      case RecordingEventType.idle:
        setState(() {
          _status =
              RecordingEventType.idle;

          _isStarting = false;
          _isStopping = false;
        });

        break;

      case RecordingEventType.unknown:
        break;
    }

    _controller.updateState(event);
  }

  Future<void> _startRecording() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (_isStarting ||
        _isStopping ||
        _controller.isRecording) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isStarting = true;
      _errorMessage = null;
      _status =
          RecordingEventType.idle;
    });

    final fileName =
    _generateFileName();

    try {
      final success =
      await _controller.startRecording(
        userId: widget.userId,
        storeId: widget.storeId,
        beatplanId: widget.beatplanId,
        authKey: widget.authKey,
        fileName: fileName,
        quality: widget.quality,
        camera: widget.camera,
      );

      if (!mounted) {
        return;
      }

      if (!success) {
        setState(() {
          _isStarting = false;
          _status =
              RecordingEventType.error;
          _errorMessage =
          'Unable to start recording.';
        });

        _showError(
          'Unable to start recording.',
        );
      }

      // Do not set recording=true here.
      //
      // The actual state is received from
      // RecordingBridge through EventChannel.
    } on RecordingException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isStarting = false;
        _status =
            RecordingEventType.error;
        _errorMessage = e.message;
      });

      _showError(e.message);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isStarting = false;
        _status =
            RecordingEventType.error;
        _errorMessage = e.toString();
      });

      _showError(
        'Unable to start recording.',
      );
    }
  }

  Future<void> _stopRecording() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (_isStopping ||
        !_controller.isRecording) {
      return;
    }

    setState(() {
      _isStopping = true;
      _status =
          RecordingEventType.stopping;
    });

    try {
      final success =
      await _controller.stopRecording();

      if (!mounted) {
        return;
      }

      if (!success) {
        setState(() {
          _isStopping = false;
        });

        _showError(
          'Unable to stop recording.',
        );
      }

      // The final result will come from
      // RECORDING_STOPPED event.
    } on RecordingException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isStopping = false;
        _status =
            RecordingEventType.error;
        _errorMessage = e.message;
      });

      _showError(e.message);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isStopping = false;
        _status =
            RecordingEventType.error;
        _errorMessage = e.toString();
      });

      _showError(
        'Unable to stop recording.',
      );
    }
  }

  String _generateFileName() {
    final timestamp =
        DateTime.now()
            .millisecondsSinceEpoch;

    return 'Audit_${widget.storeId}_$timestamp';
  }

  void _showRecordingCompleted() {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Recording completed successfully.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Recording functionality is Android only.
    //
    // On iOS the entire recording UI is hidden.
    if (!Platform.isAndroid) {
      return const SizedBox.shrink();
    }

    final bool isRecording =
        _status ==
            RecordingEventType.started &&
            !_isStopping;

    final bool isBusy =
        _isStarting ||
            _isStopping;

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor:
        const Color(0xFF1A1A1A),
        title: const Text(
          'Video Recording',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildStoreInformationCard(),

              const SizedBox(height: 16),

              _buildRecordingStatusCard(),

              const SizedBox(height: 20),

              _buildRecordingButton(),

              if (_status ==
                  RecordingEventType.stopped)
                ...[
                  const SizedBox(height: 20),
                  _buildRecordingResultCard(),
                ],

              if (_status ==
                  RecordingEventType.error &&
                  _errorMessage != null)
                ...[
                  const SizedBox(height: 16),
                  _buildErrorCard(),
                ],

              if (isBusy)
                const SizedBox(height: 16),

              if (isBusy)
                const Center(
                  child: Text(
                    'Please do not close the application '
                        'while recording is being processed.',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      Colors.black54,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreInformationCard() {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                    color:
                    const Color(0xFFEAF2FF),
                  ),
                  child: const Icon(
                    Icons.store_outlined,
                    color:
                    Color(0xFF246BCE),
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    'Store Information',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            _buildInformationRow(
              label: 'Store Name',
              value: widget.storeName,
            ),

            const SizedBox(height: 10),

            _buildInformationRow(
              label: 'Store Code',
              value: widget.storeCode,
            ),

            const SizedBox(height: 10),

            _buildInformationRow(
              label: 'Store ID',
              value: widget.storeId,
            ),

            if (widget.storeAddress
                .trim()
                .isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildInformationRow(
                label: 'Address',
                value:
                widget.storeAddress,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInformationRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value.isEmpty
                ? '-'
                : value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingStatusCard() {
    final bool recording =
        _status ==
            RecordingEventType.started;

    final bool stopping =
        _status ==
            RecordingEventType.stopping;

    String title;

    IconData icon;

    if (recording) {
      title = 'Recording in progress';
      icon = Icons.fiber_manual_record;
    } else if (stopping) {
      title = 'Stopping recording...';
      icon = Icons.stop_circle_outlined;
    } else if (_isStarting) {
      title = 'Starting recording...';
      icon = Icons.videocam_outlined;
    } else {
      title = 'Ready to record';
      icon = Icons.videocam_outlined;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(14),
        side: BorderSide(
          color: recording
              ? Colors.red.shade200
              : Colors.black12,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: recording
                  ? Colors.red
                  : Colors.black54,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                      color: recording
                          ? Colors.red
                          : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    recording
                        ? 'Video recording is currently active.'
                        : 'You can start a new recording.',
                    style:
                    const TextStyle(
                      fontSize: 12,
                      color:
                      Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingButton() {
    final bool recording =
        _status ==
            RecordingEventType.started;

    final bool stopping =
        _status ==
            RecordingEventType.stopping;

    final bool disabled =
        _isStarting ||
            _isStopping;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: disabled
            ? null
            : recording
            ? _stopRecording
            : _startRecording,
        icon: Icon(
          recording
              ? Icons.stop
              : Icons.videocam,
        ),
        label: Text(
          _isStarting
              ? 'Starting Recording...'
              : stopping
              ? 'Stopping Recording...'
              : recording
              ? 'Stop Recording'
              : 'Start Recording',
          style: const TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),
        style:
        ElevatedButton.styleFrom(
          backgroundColor: recording
              ? Colors.red
              : const Color(
            0xFF246BCE,
          ),
          foregroundColor:
          Colors.white,
          disabledBackgroundColor:
          Colors.grey.shade400,
          disabledForegroundColor:
          Colors.white,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordingResultCard() {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  'Recording Completed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (_videoFileName != null)
              _buildInformationRow(
                label: 'File',
                value:
                _videoFileName!,
              ),

            if (_videoPath != null) ...[
              const SizedBox(height: 10),
              _buildInformationRow(
                label: 'Path',
                value: _videoPath!,
              ),
            ],

            if (_videoUri != null) ...[
              const SizedBox(height: 10),
              _buildInformationRow(
                label: 'URI',
                value: _videoUri!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade700,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  fontSize: 13,
                  color:
                  Colors.red.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}