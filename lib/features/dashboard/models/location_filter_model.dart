class LocationFilterModel {
  final List<String> states;
  final List<String> cities;

  const LocationFilterModel({
    required this.states,
    required this.cities,
  });

  factory LocationFilterModel.empty() {
    return const LocationFilterModel(
      states: [],
      cities: [],
    );
  }
}