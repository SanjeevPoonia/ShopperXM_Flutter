import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/payment_model.dart';
import '../models/transaction_claim_model.dart';

class PaymentApiService {
  PaymentApiService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  static const String paymentListWebservice =
      'https://retailanalytics.qdegrees.com/api/get/auditor/payment-list';

  static const String transListApi =
      'https://retailanalytics.qdegrees.com/api/get-trans-list-freelancer';

  static const Duration _requestTimeout = Duration(seconds: 30);

  /// Fetches the Earned / Payment list.
  ///
  /// API Method: POST
  ///
  /// Parameters:
  /// - user_id
  /// - start_date
  /// - end_date
  ///
  /// Header:
  /// - Authorization
  Future<PaymentListResponse> getPaymentList({
    required String userId,
    required String startDate,
    required String endDate,
    required String accessToken,
  }) async {
    final Uri url = Uri.parse(paymentListWebservice);

    try {
      final http.Response response = await _client
          .post(
        url,
        headers: _headers(accessToken),
        body: {
          'user_id': userId,
          'start_date': startDate,
          'end_date': endDate,
        },
      )
          .timeout(_requestTimeout);

      return _parsePaymentResponse(response);
    } on TimeoutException {
      throw PaymentApiException(
        'Request timed out. Please check your internet connection and try again.',
      );
    } on http.ClientException catch (e) {
      throw PaymentApiException(
        'Unable to connect to the server: ${e.message}',
      );
    } on FormatException {
      throw PaymentApiException(
        'Invalid response received from the server.',
      );
    }
  }

  /// Fetches the Transaction Claim list.
  ///
  /// API Method: POST
  ///
  /// Parameters:
  /// - user_id
  /// - start_date
  /// - end_date
  ///
  /// Header:
  /// - Authorization
  Future<TransactionClaimListResponse> getTransactionClaimList({
    required String userId,
    required String startDate,
    required String endDate,
    required String accessToken,
  }) async {
    final Uri url = Uri.parse(transListApi);

    try {
      final http.Response response = await _client
          .post(
        url,
        headers: _headers(accessToken),
        body: {
          'user_id': userId,
          'start_date': startDate,
          'end_date': endDate,
        },
      )
          .timeout(_requestTimeout);

      return _parseTransactionClaimResponse(response);
    } on TimeoutException {
      throw PaymentApiException(
        'Request timed out. Please check your internet connection and try again.',
      );
    } on http.ClientException catch (e) {
      throw PaymentApiException(
        'Unable to connect to the server: ${e.message}',
      );
    } on FormatException {
      throw PaymentApiException(
        'Invalid response received from the server.',
      );
    }
  }

  Map<String, String> _headers(String accessToken) {
    return {
      'Authorization': accessToken,
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };
  }

  PaymentListResponse _parsePaymentResponse(
      http.Response response,
      ) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw PaymentApiException(
        'Server returned status code ${response.statusCode}.',
        statusCode: response.statusCode,
      );
    }

    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw PaymentApiException(
        'Invalid payment response format.',
      );
    }

    final bool status = _parseStatus(decoded['status']);
    final String message = _stringValue(decoded['message']);

    if (!status) {
      return PaymentListResponse(
        success: false,
        message: message.isNotEmpty
            ? message
            : 'Unable to fetch payment details.',
        data: const [],
      );
    }

    final List<PaymentModel> payments = _parsePaymentData(
      decoded['data'],
    );

    return PaymentListResponse(
      success: true,
      message: message,
      data: payments,
    );
  }

  TransactionClaimListResponse _parseTransactionClaimResponse(
      http.Response response,
      ) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw PaymentApiException(
        'Server returned status code ${response.statusCode}.',
        statusCode: response.statusCode,
      );
    }

    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw PaymentApiException(
        'Invalid transaction claim response format.',
      );
    }

    final bool status = _parseStatus(decoded['status']);
    final String message = _stringValue(decoded['message']);

    if (!status) {
      return TransactionClaimListResponse(
        success: false,
        message: message.isNotEmpty
            ? message
            : 'Unable to fetch transaction claims.',
        data: const [],
      );
    }

    final List<TransactionClaimModel> transactions =
    _parseTransactionClaimData(
      decoded['data'],
    );

    return TransactionClaimListResponse(
      success: true,
      message: message,
      data: transactions,
    );
  }

  List<PaymentModel> _parsePaymentData(dynamic data) {
    if (data == null) {
      return [];
    }

    if (data is! List) {
      throw PaymentApiException(
        'Invalid payment data format.',
      );
    }

    return data
        .whereType<Map>()
        .map(
          (item) => PaymentModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  List<TransactionClaimModel> _parseTransactionClaimData(
      dynamic data,
      ) {
    if (data == null) {
      return [];
    }

    if (data is! List) {
      throw PaymentApiException(
        'Invalid transaction claim data format.',
      );
    }

    return data
        .whereType<Map>()
        .map(
          (item) => TransactionClaimModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  bool _parseStatus(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final String status = value?.toString().toLowerCase().trim() ?? '';

    return status == 'true' ||
        status == '1' ||
        status == 'success' ||
        status == 'successful';
  }

  String _stringValue(dynamic value) {
    return value?.toString() ?? '';
  }

  void dispose() {
    _client.close();
  }
}


// ---------------------------------------------------------------------------
// Payment API Response
// ---------------------------------------------------------------------------

class PaymentListResponse {
  final bool success;
  final String message;
  final List<PaymentModel> data;

  const PaymentListResponse({
    required this.success,
    required this.message,
    required this.data,
  });
}


// ---------------------------------------------------------------------------
// Transaction Claim API Response
// ---------------------------------------------------------------------------

class TransactionClaimListResponse {
  final bool success;
  final String message;
  final List<TransactionClaimModel> data;

  const TransactionClaimListResponse({
    required this.success,
    required this.message,
    required this.data,
  });
}


// ---------------------------------------------------------------------------
// API Exception
// ---------------------------------------------------------------------------

class PaymentApiException implements Exception {
  final String message;
  final int? statusCode;

  const PaymentApiException(
      this.message, {
        this.statusCode,
      });

  @override
  String toString() {
    if (statusCode != null) {
      return 'PaymentApiException($statusCode): $message';
    }

    return 'PaymentApiException: $message';
  }
}