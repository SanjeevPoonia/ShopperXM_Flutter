class ProfileStatusModel {
  final String profileStatus;
  final String deduction;

  const ProfileStatusModel({
    required this.profileStatus,
    required this.deduction,
  });

  factory ProfileStatusModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProfileStatusModel(
        profileStatus: '',
        deduction: '',
      );
    }

    return ProfileStatusModel(
      profileStatus: _stringValue(json['profile_status']),
      deduction: _stringValue(json['deduction']),
    );
  }

  bool get shouldShowDialog {
    return profileStatus.isNotEmpty &&
        profileStatus != '0%' &&
        profileStatus != '100%';
  }

  static String _stringValue(dynamic value) {
    if (value == null) {
      return '';
    }

    final result = value.toString().trim();

    if (result.toLowerCase() == 'null') {
      return '';
    }

    return result;
  }
}