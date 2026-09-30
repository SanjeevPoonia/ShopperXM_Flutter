import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanScreen extends StatefulWidget {
  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {

  late MobileScannerController controller;

  bool isScanned = false;

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleScan(String code) async {
    if (isScanned) return;
    isScanned = true;
    print("Scanned Code: $code");
    try {
      await controller.stop();
    } catch (_) {}
    if (mounted) {
      setState(() {});
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.pop(context,code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body:  isScanned
          ? const Center(child: CircularProgressIndicator()):Stack(
        children: [

          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              if (capture.barcodes.isEmpty) return;
              final code = capture.barcodes.first.rawValue;
              print("Scanned Code: $code");
              if (code == null || code.isEmpty) return;
              handleScan(code); // 🔥 SAFE FLOW
            },
          ),

          /// OVERLAY
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}