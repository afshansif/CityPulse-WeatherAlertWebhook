import 'package:flutter/material.dart';

import '../models/weather_response.dart';
import '../theme/app_theme.dart';

/// Displays the outcome of a weather check: status badge, temperature,
/// windspeed, and the normal message or alert advisory.
class WeatherResultCard extends StatelessWidget {
  final WeatherResponse result;

  const WeatherResultCard({super.key, required this.result});

  bool get _isAlert => result.status == WeatherStatus.alert;

  @override
  Widget build(BuildContext context) {
    final badgeBg = _isAlert ? AppColors.alertBg : AppColors.normalBg;
    final badgeFg = _isAlert ? AppColors.alertFg : AppColors.normalFg;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14112A46),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.city.isNotEmpty ? result.city : 'Unknown city',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              _StatusBadge(
                label: _isAlert ? 'Alert' : 'Normal',
                icon: _isAlert ? Icons.warning_amber_rounded : Icons.check_circle,
                background: badgeBg,
                foreground: badgeFg,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: '${result.temperature.toStringAsFixed(1)}°C',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetricTile(
                  icon: Icons.air,
                  label: 'Windspeed',
                  value: '${result.windspeed.toStringAsFixed(1)} km/h',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _isAlert ? Icons.campaign_rounded : Icons.info_outline,
                  color: badgeFg,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    result.summary,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: badgeFg, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  const _StatusBadge({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.mistBlue,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.blueSlate, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
