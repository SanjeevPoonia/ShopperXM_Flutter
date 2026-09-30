import 'package:flutter/material.dart';

import '../training_colors.dart';

class TrainingErrorView
    extends StatelessWidget {
  const TrainingErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: TrainingColors.failed,
            ),

            const SizedBox(height: 16),

            const Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                TrainingColors.primaryBlue,
                fontSize: 18,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                TrainingColors.gray,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                TrainingColors.shopperOrange,
                foregroundColor:
                TrainingColors.white,
              ),
              child: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}