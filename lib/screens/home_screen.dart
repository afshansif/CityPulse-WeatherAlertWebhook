import 'package:flutter/material.dart';

import '../models/weather_response.dart';
import '../services/weather_api_exception.dart';
import '../services/weather_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/city_selector.dart';
import '../widgets/error_card.dart';
import '../widgets/weather_result_card.dart';

enum _CheckState { idle, loading, success, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherApiService _apiService = WeatherApiService();

  String _selectedCity = '';
  _CheckState _state = _CheckState.idle;
  WeatherResponse? _result;
  String? _errorMessage;

  bool get _isLoading => _state == _CheckState.loading;

  Future<void> _checkCity() async {
    final city = _selectedCity.trim();
    if (city.isEmpty) {
      setState(() {
        _state = _CheckState.error;
        _errorMessage = 'Please select a city first.';
      });
      return;
    }

    setState(() {
      _state = _CheckState.loading;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.checkCity(city);
      if (!mounted) return;
      setState(() {
        _result = result;
        _state = _CheckState.success;
      });
    } on WeatherApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _state = _CheckState.error;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Something unexpected happened. Please try again.';
        _state = _CheckState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 480;
            final maxContentWidth = constraints.maxWidth < 720 ? 520.0 : 560.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? AppSpacing.md : AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(isCompact: isCompact),
                      const SizedBox(height: AppSpacing.lg),
                      _CheckPanel(
                        isLoading: _isLoading,
                        onCityChanged: (value) =>
                            setState(() => _selectedCity = value),
                        onCheckPressed: _isLoading ? null : _checkCity,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _ResultArea(
                        state: _state,
                        result: _result,
                        errorMessage: _errorMessage,
                        onRetry: _checkCity,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isCompact;

  const _Header({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.cloud_outlined, color: Colors.white, size: 28),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'CityPulse',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'Select a city to check current weather conditions.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _CheckPanel extends StatelessWidget {
  final bool isLoading;
  final ValueChanged<String> onCityChanged;
  final VoidCallback? onCheckPressed;

  const _CheckPanel({
    required this.isLoading,
    required this.onCityChanged,
    required this.onCheckPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'City',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          CitySelector(onChanged: onCityChanged, enabled: !isLoading),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: onCheckPressed,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text('Check City'),
          ),
        ],
      ),
    );
  }
}

class _ResultArea extends StatelessWidget {
  final _CheckState state;
  final WeatherResponse? result;
  final String? errorMessage;
  final VoidCallback onRetry;

  const _ResultArea({
    required this.state,
    required this.result,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _CheckState.idle:
        return const SizedBox.shrink();
      case _CheckState.loading:
        return const _LoadingCard();
      case _CheckState.success:
        if (result == null) return const SizedBox.shrink();
        return WeatherResultCard(result: result!);
      case _CheckState.error:
        return ErrorCard(
          message: errorMessage ?? 'Please try again.',
          onRetry: onRetry,
        );
    }
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Checking current weather…',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
