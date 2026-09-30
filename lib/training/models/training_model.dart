class TrainingModel {
  final String id;
  final String title;
  final String? imageUrl;

  final double progress;

  final int trainingType;

  final String? description;

  final bool isCompleted;

  const TrainingModel({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.progress,
    required this.trainingType,
    this.description,
    required this.isCompleted,
  });

  bool get isAssigned => trainingType == 0;

  bool get isTrainingCompleted => trainingType == 1;

  int get progressPercentage {
    final value = progress * 100;

    if (value < 0) {
      return 0;
    }

    if (value > 100) {
      return 100;
    }

    return value.round();
  }

  factory TrainingModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final trainingType =
    _parseInt(
      json['training_type'] ??
          json['trainingType'] ??
          json['type'],
    );

    final progress =
    _parseProgress(
      json['progress'] ??
          json['completion_percentage'] ??
          json['completed_percentage'] ??
          json['percentage'] ??
          0,
    );

    final title =
    _parseString(
      json['training_title'] ??
          json['training_name'] ??
          json['title'] ??
          json['name'],
      fallback: 'Training',
    );

    final id =
    _parseString(
      json['id'] ??
          json['training_id'] ??
          json['trainingId'],
      fallback: '',
    );

    final image =
    _parseNullableString(
      json['training_image'] ??
          json['image'] ??
          json['image_url'] ??
          json['imageUrl'],
    );

    final description =
    _parseNullableString(
      json['description'],
    );

    return TrainingModel(
      id: id,
      title: title,
      imageUrl: image,
      progress: progress,
      trainingType: trainingType,
      description: description,
      isCompleted: trainingType == 1 || progress >= 1,
    );
  }

  static String _parseString(
      dynamic value, {
        required String fallback,
      }) {
    if (value == null) {
      return fallback;
    }

    final result = value.toString().trim();

    if (result.isEmpty) {
      return fallback;
    }

    return result;
  }

  static String? _parseNullableString(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    if (result.isEmpty ||
        result.toLowerCase() == 'null') {
      return null;
    }

    return result;
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _parseProgress(dynamic value) {
    if (value is num) {
      final number = value.toDouble();

      // Supports both:
      // 0.5  -> 50%
      // 50   -> 50%

      if (number > 1) {
        return (number / 100).clamp(
          0.0,
          1.0,
        );
      }

      return number.clamp(
        0.0,
        1.0,
      );
    }

    final parsed =
        double.tryParse(
          value?.toString() ?? '',
        ) ??
            0;

    if (parsed > 1) {
      return (parsed / 100).clamp(
        0.0,
        1.0,
      );
    }

    return parsed.clamp(
      0.0,
      1.0,
    );
  }
}