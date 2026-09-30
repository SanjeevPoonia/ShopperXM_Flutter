import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShopperStartLMSScreen extends StatefulWidget {
  final String trainingUrl;

  const ShopperStartLMSScreen({super.key, required this.trainingUrl});

  @override
  State<ShopperStartLMSScreen> createState() =>
      _ShopperStartLMSScreenState();
}

class _ShopperStartLMSScreenState
    extends State<ShopperStartLMSScreen> {

  late final WebViewController controller;

  bool isLoading = true;

  String allowedOrigin = "https://lms.qdegrees.com";

  @override
  void initState() {
    super.initState();

    initWebView();
  }

  /// ================= INIT =================
  void initWebView() {

    controller = WebViewController()

    /// 🔥 JavaScript enable
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

    /// 🔥 JS Interface (Android.closeActivity)
      ..addJavaScriptChannel(
        'Android',
        onMessageReceived: (JavaScriptMessage message) {
          String origin = message.message;

          print("On Close Called: $origin");

          /// SAME LOGIC AS JAVA
          if (origin.startsWith(allowedOrigin)) {
            Navigator.pop(context);
          }
        },
      )

    /// 🔥 Navigation delegate
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )

    /// 🔥 Load URL
      ..loadRequest(Uri.parse(widget.trainingUrl));
  }

  /// ================= BACK =================
  Future<bool> handleBack() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    }
    return true;
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        bool shouldPop = await handleBack();
        if (shouldPop && mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Training")),
        body: Stack(
          children: [

            /// WEBVIEW
            WebViewWidget(controller: controller),

            /// LOADER (same as progressDialog)
            if (isLoading)
              Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}