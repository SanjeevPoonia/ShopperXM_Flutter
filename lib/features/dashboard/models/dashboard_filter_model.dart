class DashboardFilterModel {
  final int distance;
  final String state;
  final String city;

  const DashboardFilterModel({
    required this.distance,
    required this.state,
    required this.city,
  });

  factory DashboardFilterModel.initial() {
    return const DashboardFilterModel(
      distance: 300,
      state: '',
      city: '',
    );
  }

  DashboardFilterModel copyWith({
    int? distance,
    String? state,
    String? city,
  }) {
    return DashboardFilterModel(
      distance: distance ?? this.distance,
      state: state ?? this.state,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toApiParams({
    required String latitude,
    required String longitude,
  }) {
    final Map<String, dynamic> params = {
      'latitude': latitude,
      'longitude': longitude,
      'min_distance': distance.toString(),
    };

    if (state.trim().isNotEmpty) {
      params['state'] = state.trim();
    }

    if (city.trim().isNotEmpty) {
      params['city'] = city.trim();
    }

    return params;
  }

  bool get hasStateFilter {
    return state.trim().isNotEmpty;
  }

  bool get hasCityFilter {
    return city.trim().isNotEmpty;
  }

  bool get hasLocationFilter {
    return hasStateFilter || hasCityFilter;
  }
}