
import 'package:flutter/material.dart';

import '../controllers/audio_recording_controller.dart';

class RecordAudioScreenUpdated extends StatefulWidget {
  final String beatplanId;
  final String storeId;
  final String storeName;
  final String auditDate;
  final String storeAddress;

  const RecordAudioScreenUpdated({
    super.key,
    required this.beatplanId,
    required this.storeId,
    required this.storeName,
    required this.auditDate,
    required this.storeAddress
  });

  @override
  State<RecordAudioScreenUpdated> createState() =>
      _RecordAudioScreenState();
}

class _RecordAudioScreenState extends State<RecordAudioScreenUpdated>
    with WidgetsBindingObserver {

  late final AudioRecordingController controller;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    controller = AudioRecordingController();

    controller.checkRecordingStatus();
  }

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {
    if (state == AppLifecycleState.resumed) {
      controller.checkRecordingStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {

        print("beatplanid: ${widget.beatplanId}");
        print("StoreId: ${widget.storeId}");
        print("StoreName: ${widget.storeName}");
        print("StoreAddress: ${widget.storeAddress}");
        print("AuditDate: ${widget.auditDate}");

        final activeDetails = controller.recordingDetails;
        final storeName = activeDetails?.storeName ?? widget.storeName;
        final storeId = activeDetails?.storeId ?? widget.storeId;
        final beatplanId = activeDetails?.beatplanId ?? widget.beatplanId;
        final auditDate = activeDetails?.auditDate ?? widget.auditDate;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Record Audio'),
            automaticallyImplyLeading:
            !controller.isRecording,
          ),

          body: SafeArea(
            child: controller.isLoading &&
                activeDetails == null
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [

                  _storeDetails(
                    storeName,
                    storeId,
                    beatplanId,
                    auditDate,
                  ),

                  const SizedBox(height: 28),

                  _recordingStatus(),

                  const SizedBox(height: 24),

                  if (controller.errorMessage != null)
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: 16),
                      child: Text(
                        controller.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),

                  _recordingButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _storeDetails(
      String storeName,
      String storeId,
      String beatplanId,
      String auditDate,
      ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            const Text(
              'STORE INFORMATION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              storeName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 28),
            _detail('Beatplan ID', beatplanId),
            _detail('Store Code', storeId),
            _detail('Store Name', storeName),
            _detail('Audit Date', auditDate),
          ],
        ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordingStatus() {
    final active = controller.isRecording;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: active
            ? Colors.red.withValues(alpha: 0.08)
            : Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            active ? Icons.mic : Icons.mic_none,
            color: active ? Colors.red : Colors.green,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            active
                ? 'Audio recording is running'
                : 'No active recording',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordingButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: controller.isLoading
            ? null
            : controller.isRecording
            ? _stopRecording
            : _startRecording,
        icon: Icon(
          controller.isRecording
              ? Icons.stop
              : Icons.mic,
        ),
        label: Text(
          controller.isLoading
              ? 'Please wait...'
              : controller.isRecording
              ? 'Stop Recording'
              : 'Start Recording',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.isRecording
              ? Colors.red
              : Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _startRecording() async {

    debugPrint('Record Audio Screen Values:');
    debugPrint('Beatplan ID: ${widget.beatplanId}');
    debugPrint('Store ID: ${widget.storeId}');
    debugPrint('Store Name: ${widget.storeName}');
    debugPrint('Audit Date: ${widget.auditDate}');

    await controller.startRecording(
      beatplanId: widget.beatplanId,
      storeId: widget.storeId,
      storeName: widget.storeName,
      auditDate: widget.auditDate,
    );

  }

  Future<void> _stopRecording() async {
    await controller.stopRecording();

    if (!mounted) return;

    if (!controller.isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio recording stopped.'),
        ),
      );
    }
  }
}
