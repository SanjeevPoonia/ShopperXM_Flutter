import 'freelancer_audit_model.dart';
import 'profile_status_model.dart';

class FreelancerDashboardResponse {
  final bool success;
  final String message;
  final List<FreelancerAuditModel> audits;
  final ProfileStatusModel profileStatus;

  const FreelancerDashboardResponse({
    required this.success,
    required this.message,
    required this.audits,
    required this.profileStatus,
  });

  factory FreelancerDashboardResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final dynamic data = json['data'];

    final List<FreelancerAuditModel> audits = [];

    if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          audits.add(
            FreelancerAuditModel.fromJson(item),
          );
        }
      }
    }

    Map<String, dynamic>? profileJson;

    if (json['user_profile_stage'] is Map) {
      profileJson = Map<String, dynamic>.from(
        json['user_profile_stage'] as Map,
      );
    }

    return FreelancerDashboardResponse(
      success: _parseStatus(json['status']),
      message: json['message']?.toString() ?? '',
      audits: audits,
      profileStatus: ProfileStatusModel.fromJson(profileJson),
    );
  }

  static bool _parseStatus(dynamic status) {
    if (status == true) {
      return true;
    }

    if (status is int) {
      return status == 1;
    }

    if (status is String) {
      return status == '1' ||
          status.toLowerCase() == 'true';
    }

    return false;
  }
}