import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopperxm_flutter/network/api_helper.dart';
import '../models/dashboard_filter_model.dart';
import '../models/freelancer_audit_model.dart';
import '../models/freelancer_dashboard_response.dart';

class DashboardApiService {
  final ApiBaseHelper _apiHelper = ApiBaseHelper();

  /// ----------------------------------------------------------
  /// Freelancer Audit List
  /// ----------------------------------------------------------
  ///
  /// Existing Flutter API:
  /// POST getFreelanceAuditList
  ///
  /// Native request:
  /// latitude
  /// longitude
  /// min_distance
  /// state - optional
  /// city  - optional
  ///
  Future<FreelancerDashboardResponse> getFreelanceAuditList({
    required BuildContext context,
    required String latitude,
    required String longitude,
    required DashboardFilterModel filter,
  }) async {
    final Map<String, dynamic> requestData =
    filter.toApiParams(
      latitude: latitude,
      longitude: longitude,
    );

    debugPrint(
      'getFreelanceAuditList Request: $requestData',
    );

    final response = await _apiHelper.postAPIWithHeader(
      'getFreelanceAuditList',
      requestData,
      context,
    );

    debugPrint(
      'getFreelanceAuditList Response: ${response.body}',
    );

    final dynamic decodedResponse = jsonDecode(response.body);

    if (decodedResponse is! Map) {
      throw Exception(
        'Invalid dashboard response',
      );
    }

    final Map<String, dynamic> jsonResponse =
    Map<String, dynamic>.from(decodedResponse);

    return FreelancerDashboardResponse.fromJson(
      jsonResponse,
    );
  }

  /// ----------------------------------------------------------
  /// State List
  /// ----------------------------------------------------------
  ///
  /// IMPORTANT:
  /// Replace the endpoint below with the actual value from
  /// Constant_Strings.getStatelist_webservice().
  ///
  Future<List<String>> getStateList({
    required BuildContext context,
    required String endpoint,
  }) async {
    debugPrint(
      'getStateList Endpoint: $endpoint',
    );

    final response = await _apiHelper.getWithHeader(
      endpoint,
      context,
    );

    debugPrint(
      'getStateList Response: ${response.body}',
    );

    final dynamic decodedResponse = jsonDecode(response.body);

    if (decodedResponse is! Map) {
      throw Exception(
        'Invalid state list response',
      );
    }

    final Map<String, dynamic> jsonResponse =
    Map<String, dynamic>.from(decodedResponse);

    return _parseLocationList(
      jsonResponse,
      title: 'Select State',
    );
  }

  /// ----------------------------------------------------------
  /// City List
  /// ----------------------------------------------------------
  ///
  /// Native API:
  /// POST
  ///
  /// Body:
  /// {
  ///   "state": "selected state"
  /// }
  ///
  /// IMPORTANT:
  /// Replace endpoint with actual value from
  /// Constant_Strings.getCityList_Webservice().
  ///
  Future<List<String>> getCityList({
    required BuildContext context,
    required String endpoint,
    required String state,
  }) async {
    final Map<String, dynamic> requestData = {
      'state': state,
    };

    debugPrint(
      'getCityList Request: $requestData',
    );

    final response = await _apiHelper.postAPIWithHeader(
      endpoint,
      requestData,
      context,
    );

    debugPrint(
      'getCityList Response: ${response.body}',
    );

    final dynamic decodedResponse = jsonDecode(response.body);

    if (decodedResponse is! Map) {
      throw Exception(
        'Invalid city list response',
      );
    }

    final Map<String, dynamic> jsonResponse =
    Map<String, dynamic>.from(decodedResponse);

    return _parseLocationList(
      jsonResponse,
      title: 'Select City',
    );
  }

  /// ----------------------------------------------------------
  /// Parse State / City API
  /// ----------------------------------------------------------

  List<String> _parseLocationList(
      Map<String, dynamic> response, {
        required String title,
      }) {
    final dynamic status = response['status'];

    final bool success =
        status == true ||
            status == 1 ||
            status?.toString().toLowerCase() == 'true' ||
            status?.toString() == '1';

    if (!success) {
      throw Exception(
        response['message']?.toString() ??
            'Unable to load location data',
      );
    }

    final dynamic data = response['data'];

    if (data is! List) {
      return [title];
    }

    final List<String> result = data
        .map(
          (item) => item?.toString().trim() ?? '',
    )
        .where(
          (item) => item.isNotEmpty,
    )
        .toList();

    /// Same as native:
    /// Collections.sort(list, String.CASE_INSENSITIVE_ORDER)
    result.sort(
          (a, b) => a.toLowerCase().compareTo(
        b.toLowerCase(),
      ),
    );

    /// Same as native:
    /// list.add(0, "Select State")
    /// list.add(0, "Select City")
    result.insert(0, title);

    return result;
  }

  /// ----------------------------------------------------------
  /// Sort audits by distance
  /// ----------------------------------------------------------

  List<FreelancerAuditModel> sortAuditsByDistance(
      List<FreelancerAuditModel> audits,
      ) {
    final List<FreelancerAuditModel> sorted =
    List<FreelancerAuditModel>.from(audits);

    sorted.sort(
          (a, b) => a.distance.compareTo(
        b.distance,
      ),
    );

    return sorted;
  }

  /// ----------------------------------------------------------
  /// Calculate total audit value
  /// ----------------------------------------------------------

  double calculateTotalAuditValue(
      List<FreelancerAuditModel> audits,
      ) {
    double total = 0;

    for (final audit in audits) {
      total += audit.priceDouble;
    }

    return total;
  }
}