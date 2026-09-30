import 'package:flutter/material.dart';

import '../models/training_model.dart';
import '../training_colors.dart';

class TrainingCard extends StatelessWidget {
  const TrainingCard({
    super.key,
    required this.training,
    required this.onTap,
  });

  final TrainingModel training;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percentage =
        training.progressPercentage;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 5,
      shadowColor:
      Colors.black.withValues(alpha: 0.18),
      color: TrainingColors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              _TrainingImage(
                imageUrl:
                training.imageUrl,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      training.title,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color:
                        TrainingColors.primaryBlue,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(6),
                      child:
                      LinearProgressIndicator(
                        value:
                        training.progress,
                        minHeight: 6,
                        backgroundColor:
                        TrainingColors.lightGray,
                        valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                          TrainingColors.primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$percentage% Completed',
                            style:
                            const TextStyle(
                              color: TrainingColors
                                  .primaryBlue,
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),

                        if (training
                            .isTrainingCompleted)
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color:
                            TrainingColors.passed,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainingImage extends StatelessWidget {
  const _TrainingImage({
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 100,
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(8),
        child: imageUrl != null
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) {
            return const _DefaultTrainingImage();
          },
          loadingBuilder:
              (
              context,
              child,
              loadingProgress,
              ) {
            if (loadingProgress ==
                null) {
              return child;
            }

            return const Center(
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          },
        )
            : const _DefaultTrainingImage(),
      ),
    );
  }
}

class _DefaultTrainingImage
    extends StatelessWidget {
  const _DefaultTrainingImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TrainingColors.lightGray,
      child: const Center(
        child: Icon(
          Icons.school_outlined,
          size: 42,
          color: TrainingColors.gray,
        ),
      ),
    );
  }
}