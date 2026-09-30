import 'package:flutter/material.dart';

import '../models/dashboard_filter_model.dart';

class DashboardFilterSheet extends StatefulWidget {
  final DashboardFilterModel initialFilter;

  final List<String> states;

  final bool isLoadingStates;

  /// Called when user selects a state.
  ///
  /// Must return the cities received from the API.
  final Future<List<String>> Function(String state)
  onLoadCities;

  final Future<void> Function(DashboardFilterModel filter) onApply;

  const DashboardFilterSheet({
    super.key,
    required this.initialFilter,
    required this.states,
    required this.isLoadingStates,
    required this.onLoadCities,
    required this.onApply,
  });

  @override
  State<DashboardFilterSheet> createState() =>
      _DashboardFilterSheetState();
}

class _DashboardFilterSheetState
    extends State<DashboardFilterSheet> {
  late int _selectedDistance;

  String _selectedState = '';
  String _selectedCity = '';

  List<String> _cities = ['Select City'];

  bool _isLoadingCities = false;

  final List<int> _distanceList = const [
    10,
    20,
    30,
    40,
    50,
    75,
    100,
    150,
    200,
    250,
    300,
  ];
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();

    _selectedDistance =
        widget.initialFilter.distance;

    _selectedState =
        widget.initialFilter.state;

    _selectedCity =
        widget.initialFilter.city;
  }

  Future<void> _handleApply() async {
    if (_isApplying) {
      return;
    }

    if (_selectedDistance < 10 || _selectedDistance > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Distance must be between 10 and 300 Kms'),
        ),
      );
      return;
    }

    final DashboardFilterModel filter = DashboardFilterModel(
      distance: _selectedDistance,
      state: _selectedState,
      city: _selectedCity,
    );

    setState(() {
      _isApplying = true;
    });

    try {
      await widget.onApply(filter);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isApplying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to apply filter: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom:
            MediaQuery.of(context).viewInsets.bottom +
                20,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // -----------------------------------------
              // HANDLE
              // -----------------------------------------

              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // -----------------------------------------
              // HEADER
              // -----------------------------------------

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // -----------------------------------------
              // DISTANCE
              // -----------------------------------------

              const Text(
                'Find Stores within Kms',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<int>(
                value: _distanceList.contains(
                  _selectedDistance,
                )
                    ? _selectedDistance
                    : 300,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items: _distanceList.map(
                      (distance) {
                    return DropdownMenuItem<int>(
                      value: distance,
                      child: Text(
                        '$distance Km',
                      ),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedDistance = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              // -----------------------------------------
              // STATE
              // -----------------------------------------

              const Text(
                'State',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              _buildStateDropdown(),

              const SizedBox(height: 18),

              // -----------------------------------------
              // CITY
              // -----------------------------------------

              const Text(
                'City',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              _buildCityDropdown(),

              const SizedBox(height: 25),

              // -----------------------------------------
              // APPLY
              // -----------------------------------------

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isApplying ? null : _handleApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00407E),
                    disabledBackgroundColor: const Color(0xFF00407E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isApplying
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                      : const Text(
                    'APPLY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // STATE DROPDOWN
  // =====================================================

  Widget _buildStateDropdown() {
    if (widget.isLoadingStates) {
      return Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding:
        const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
          ),
          borderRadius:
          BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Loading states...',
            ),
          ],
        ),
      );
    }

    final List<String> stateItems =
    widget.states.isEmpty
        ? ['Select State']
        : widget.states;

    String? selectedValue;

    if (_selectedState.isNotEmpty &&
        stateItems.contains(_selectedState)) {
      selectedValue = _selectedState;
    } else {
      selectedValue = 'Select State';
    }

    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
        ),
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      items: stateItems.map(
            (state) {
          return DropdownMenuItem<String>(
            value: state,
            child: Text(
              state,
              overflow:
              TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
      onChanged: _onStateChanged,
    );
  }

  // =====================================================
  // CITY DROPDOWN
  // =====================================================

  Widget _buildCityDropdown() {
    if (_isLoadingCities) {
      return Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding:
        const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
          ),
          borderRadius:
          BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Loading cities...',
            ),
          ],
        ),
      );
    }

    final List<String> cityItems =
    _cities.isEmpty
        ? ['Select City']
        : _cities;

    String? selectedValue;

    if (_selectedCity.isNotEmpty &&
        cityItems.contains(_selectedCity)) {
      selectedValue = _selectedCity;
    } else {
      selectedValue = 'Select City';
    }

    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(8),
        ),
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      items: cityItems.map(
            (city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(
              city,
              overflow:
              TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
      onChanged:
      _selectedState.isEmpty
          ? null
          : (city) {
        if (city == null) {
          return;
        }

        setState(() {
          _selectedCity =
          city == 'Select City'
              ? ''
              : city;
        });
      },
    );
  }

  // =====================================================
  // STATE CHANGE
  // =====================================================

  Future<void> _onStateChanged(
      String? state,
      ) async {
    if (state == null) {
      return;
    }

    if (state == 'Select State') {
      setState(() {
        _selectedState = '';
        _selectedCity = '';
        _cities = ['Select City'];
      });

      return;
    }

    // Immediately update selected state.
    setState(() {
      _selectedState = state;
      _selectedCity = '';
      _cities = ['Select City'];
      _isLoadingCities = true;
    });

    try {
      final List<String> cities =
      await widget.onLoadCities(state);

      if (!mounted) {
        return;
      }

      setState(() {
        _cities = cities.isEmpty
            ? ['Select City']
            : cities;

        _isLoadingCities = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _cities = ['Select City'];
        _isLoadingCities = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Unable to load cities: $e',
          ),
        ),
      );
    }
  }

  // =====================================================
  // APPLY
  // =====================================================

  void _applyFilter() {
    if (_selectedDistance < 10) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Minimum distance should be 10 Kms',
          ),
        ),
      );

      return;
    }

    if (_selectedDistance > 300) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Maximum distance should be 300 Kms',
          ),
        ),
      );

      return;
    }

    final DashboardFilterModel filter =
    DashboardFilterModel(
      distance: _selectedDistance,
      state: _selectedState,
      city: _selectedCity,
    );

    widget.onApply(filter);
  }
}