import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShopperVerifyAadhaarScreen extends StatefulWidget {
  final String trainingUrl;
  final String clientId;

  const ShopperVerifyAadhaarScreen({
    super.key,
    required this.trainingUrl,
    required this.clientId,
  });

  @override
  State<ShopperVerifyAadhaarScreen> createState() =>
      _ShopperVerifyAadhaarScreenState();
}

class _ShopperVerifyAadhaarScreenState
    extends State<ShopperVerifyAadhaarScreen> {

  late final WebViewController _controller;

  final String allowedOrigin = "https://retailanalytics.qdegrees.com";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

    // 🔥 Navigation delegate (same as Java shouldOverrideUrlLoading)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);
          },

          onPageFinished: (url) {
            setState(() => isLoading = false);
          },

          onNavigationRequest: (request) {
            String url = request.url;

            debugPrint("Redirect URL: $url");

            // 🔥 SAME LOGIC (IMPORTANT)
            if (url.startsWith(allowedOrigin)) {

              sendResultAndFinish(url);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )

      ..loadRequest(Uri.parse(widget.trainingUrl));
  }

  // ================= RESULT RETURN =================

  void sendResultAndFinish(String url) {

    Navigator.pop(context, {
      "client_id": widget.clientId,
      "redirect_url": url,
    });
  }

  // ================= BACK HANDLING =================

  Future<bool> onBackPressed() async {

    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (await _controller.canGoBack()) {
          _controller.goBack();
        } else {
          Navigator.pop(context);
        }
      },

      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}