import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/training_model.dart';

class TrainingApiException implements Exception {
  final String message;

  const TrainingApiException(this.message);

  @override
  String toString() {
    return message;
  }
}

class TrainingApiService {
  TrainingApiService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  static const String trainingStatusApi =
      'https://lms.qdegrees.com/api/get-user-training';

  static const String trainingListApi =
      'https://lms.qdegrees.com/api/get-all-trainings';

  static const String trainingUrlApi =
      'https://lms.qdegrees.com/api/get-training-url';

  Future<List<TrainingModel>> getUserTrainings({
    required String email,
    required int trainingType,
  }) async {
    try {
      /*
       * IMPORTANT:
       *
       * The exact request structure of this API was not included
       * in the provided Java code.
       *
       * This implementation uses query parameters.
       *
       * If your existing API uses POST/body instead,
       * change only this request section.
       */

      final uri = Uri.parse(
        trainingListApi,
      ).replace(
        queryParameters: {
          'email': email,
          'status': trainingType.toString(),
        },
      );

      final response = await _client.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      debugPrint('===============${jsonDecode(response.body)}');

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw TrainingApiException(
          'Training API failed '
              '(${response.statusCode})',
        );
      }

      final dynamic decoded =
      jsonDecode(response.body);


      return _extractTrainingList(
        decoded,
        trainingType,
      );
    } on TrainingApiException {
      rethrow;
    } on FormatException {
      throw const TrainingApiException(
        'Invalid response received from training server.',
      );
    } catch (e) {
      throw TrainingApiException(
        'Unable to load trainings: $e',
      );
    }
  }

  Future<String> getTrainingUrl({
    required String trainingId,
    required String email,

  }) async {
    try {
      final uri = Uri.parse(
        trainingUrlApi,
      ).replace(
        queryParameters: {
          'training_id': trainingId,
          'email': email,
        },
      );

      final response = await _client.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw TrainingApiException(
          'Unable to get training URL '
              '(${response.statusCode})',
        );
      }

      final dynamic decoded =
      jsonDecode(response.body);

      final url =
      _extractUrl(decoded);

      if (url == null || url.isEmpty) {
        throw const TrainingApiException(
          'Training URL was not returned by the server.',
        );
      }

      return url;
    } on TrainingApiException {
      rethrow;
    } on FormatException {
      throw const TrainingApiException(
        'Invalid training URL response.',
      );
    } catch (e) {
      throw TrainingApiException(
        'Unable to open training: $e',
      );
    }
  }

  List<TrainingModel> _extractTrainingList(
      dynamic data,
      int trainingType,
      ) {
    dynamic list;

    if (data is List) {
      list = data;
    } else if (data is Map) {
      list =
          data['data'] ??
              data['result'] ??
              data['trainings'] ??
              data['training'] ??
              data['records'];

      if (list is Map) {
        list =
            list['data'] ??
                list['result'] ??
                list['trainings'] ??
                list['records'];
      }
    }

    if (list is! List) {
      return const [];
    }

    return list
        .whereType<Map>()
        .map(
          (item) => TrainingModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .where(
          (training) =>
      training.trainingType ==
          trainingType,
    )
        .toList();
  }

  String? _extractUrl(dynamic data) {
    if (data is String) {
      return data;
    }

    if (data is Map) {
      final directUrl =
          data['training_url'] ??
              data['trainingUrl'] ??
              data['url'];

      if (directUrl != null) {
        return directUrl.toString();
      }

      final nested =
          data['data'] ??
              data['result'];

      if (nested is Map) {
        return _extractUrl(nested);
      }
    }

    return null;
  }

  void dispose() {
    _client.close();
  }
}