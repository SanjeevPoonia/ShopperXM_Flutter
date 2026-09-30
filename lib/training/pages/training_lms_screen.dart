import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../training_colors.dart';

class TrainingLmsScreen
    extends StatefulWidget {
  const TrainingLmsScreen({
    super.key,
    required this.trainingUrl,
  });

  final String trainingUrl;

  @override
  State<TrainingLmsScreen> createState() =>
      _TrainingLmsScreenState();
}

class _TrainingLmsScreenState
    extends State<TrainingLmsScreen> {
  late final WebViewController
  _controller;

  bool _isLoading = true;
  int _progress = 0;

  static const String allowedOrigin =
      'https://lms.qdegrees.com';

  @override
  void initState() {
    super.initState();

    _controller =
    WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) {
              return;
            }

            setState(() {
              _progress = progress;
            });
          },

          onPageStarted: (_) {
            if (!mounted) {
              return;
            }

            setState(() {
              _isLoading = true;
            });
          },

          onPageFinished: (_) {
            if (!mounted) {
              return;
            }

            setState(() {
              _isLoading = false;
              _progress = 100;
            });
          },

          onWebResourceError: (error) {
            if (!mounted) {
              return;
            }

            setState(() {
              _isLoading = false;
            });
          },

          onNavigationRequest:
              (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Android',
        onMessageReceived:
            (message) {
          _handleJavaScriptMessage(
            message.message,
          );
        },
      )
      ..loadRequest(
        Uri.parse(
          widget.trainingUrl,
        ),
      );
  }

  void _handleJavaScriptMessage(
      String message,
      ) {
    /*
     * Your Android implementation expects:
     *
     * Android.closeActivity(origin)
     *
     * Flutter WebView's JavaScript channel
     * sends the message as a string.
     *
     * Therefore LMS can send:
     *
     * Android.postMessage(
     *   'https://lms.qdegrees.com/...'
     * )
     */

    if (message.startsWith(
      allowedOrigin,
    )) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<bool> _handleBack() async {
    final canGoBack =
    await _controller.canGoBack();

    if (canGoBack) {
      await _controller.goBack();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult:
          (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldClose =
        await _handleBack();

        if (shouldClose &&
            context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor:
        TrainingColors.background,
        appBar: AppBar(
          backgroundColor:
          TrainingColors.primaryBlue,
          foregroundColor:
          TrainingColors.white,
          elevation: 0,
          title: const Text(
            'Training',
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller:
              _controller,
            ),

            if (_isLoading)
              const LinearProgressIndicator(
                minHeight: 3,
                valueColor:
                AlwaysStoppedAnimation<
                    Color>(
                  TrainingColors
                      .shopperOrange,
                ),
              ),

            if (_isLoading)
              Center(
                child: Container(
                  padding:
                  const EdgeInsets.all(20),
                  decoration:
                  BoxDecoration(
                    color:
                    TrainingColors.white,
                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black
                            .withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ],
                  ),
                  child:
                  const CircularProgressIndicator(
                    color: TrainingColors
                        .primaryBlue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}