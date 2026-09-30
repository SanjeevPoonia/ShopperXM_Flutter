import 'package:flutter/material.dart';

import '../training_colors.dart';

class TrainingEmptyView
    extends StatelessWidget {
  const TrainingEmptyView({
    super.key,
    required this.onRefresh,
    this.message =
    'No training available.',
  });

  final VoidCallback onRefresh;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color:
                TrainingColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 55,
                color:
                TrainingColors.gray,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                TrainingColors.emptyText,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                TrainingColors.shopperOrange,
                foregroundColor:
                TrainingColors.white,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Refresh',
              ),
            ),
          ],
        ),
      ),
    );
  }
}