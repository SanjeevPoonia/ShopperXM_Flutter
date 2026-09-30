import 'package:flutter/material.dart';

import '../models/training_model.dart';
import '../services/training_api_service.dart';
import '../training_colors.dart';
import '../widgets/training_card.dart';
import '../widgets/training_empty_view.dart';
import '../widgets/training_error_view.dart';
import 'training_lms_screen.dart';

class TrainingListScreen
    extends StatefulWidget {
  const TrainingListScreen({
    super.key,
    required this.email,
    required this.trainingType,
  });

  final String email;
  /// 0 = Assigned
  /// 1 = Completed
  final int trainingType;

  @override
  State<TrainingListScreen> createState() =>
      _TrainingListScreenState();
}

class _TrainingListScreenState
    extends State<TrainingListScreen> {
  late final TrainingApiService
  _apiService;

  List<TrainingModel> _trainings =
  const [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _apiService = TrainingApiService();
    _loadTrainings();
  }

  Future<void> _loadTrainings({
    bool showLoader = true,
  }) async {
    if (showLoader && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final result = await _apiService.getUserTrainings(
        email: widget.email,
        trainingType: widget.trainingType,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _trainings = result;
        _isLoading = false;
        _errorMessage = null;
      });
    } on TrainingApiException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            e.message;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
        'Unable to load training.';
      });
    }
  }

  Future<void> _openTraining(
      TrainingModel training,
      ) async {
    if (training.id.isEmpty) {
      _showMessage(
        'Training ID is missing.',
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child:
          CircularProgressIndicator(
            color:
            TrainingColors.primaryBlue,
          ),
        );
      },
    );

    try {
      final url =
      await _apiService
          .getTrainingUrl(
        trainingId: training.id,
        email: widget.email,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              TrainingLmsScreen(
                trainingUrl: url,
              ),
        ),
      );

      // Refresh when returning from LMS.
      await _loadTrainings(
        showLoader: false,
      );
    } on TrainingApiException catch (e) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();

      _showMessage(
        e.message,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();

      _showMessage(
        'Unable to open training.',
      );
    }
  }

  void _showMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  String get _screenTitle {
    if (widget.trainingType == 0) {
      return 'Assigned Training';
    }

    return 'Completed Training';
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      TrainingColors.background,
      appBar: AppBar(
        backgroundColor:
        TrainingColors.primaryBlue,
        foregroundColor:
        TrainingColors.white,
        elevation: 0,
        title: Text(
          _screenTitle,
          style: const TextStyle(
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child:
        CircularProgressIndicator(
          color:
          TrainingColors.primaryBlue,
        ),
      );
    }

    if (_errorMessage != null) {
      return TrainingErrorView(
        message:
        _errorMessage!,
        onRetry: () =>
            _loadTrainings(),
      );
    }

    if (_trainings.isEmpty) {
      return TrainingEmptyView(
        message: widget.trainingType == 0
            ? 'No assigned training available.'
            : 'No completed training available.',
        onRefresh: () =>
            _loadTrainings(),
      );
    }

    return RefreshIndicator(
      color:
      TrainingColors.primaryBlue,
      onRefresh: () =>
          _loadTrainings(
            showLoader: false,
          ),
      child: ListView.builder(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding:
        const EdgeInsets.symmetric(
          vertical: 8,
        ),
        itemCount:
        _trainings.length,
        itemBuilder:
            (context, index) {
          final training =
          _trainings[index];

          return TrainingCard(
            training: training,
            onTap: () =>
                _openTraining(
                  training,
                ),
          );
        },
      ),
    );
  }
}