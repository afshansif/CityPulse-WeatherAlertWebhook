/// The status the webhook reports back.
enum WeatherStatus { normal, alert }

/// Parsed response from the Make.com "Weather Alert Webhook".
///
/// Normal payload:
/// { "status": "normal", "city": "...", "temperature": 0, "windspeed": 0,
///   "message": "Weather conditions are normal." }
///
/// Alert payload:
/// { "status": "alert", "city": "...", "temperature": 0, "windspeed": 0,
///   "advisory": "..." }
class WeatherResponse {
  final WeatherStatus status;
  final String city;
  final double temperature;
  final double windspeed;
  final String? message;
  final String? advisory;

  const WeatherResponse({
    required this.status,
    required this.city,
    required this.temperature,
    required this.windspeed,
    this.message,
    this.advisory,
  });

  /// The user-facing summary line, regardless of status.
  String get summary => status == WeatherStatus.alert
      ? (advisory ?? 'A weather advisory is in effect for this city.')
      : (message ?? 'Weather conditions are normal.');

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final rawStatus = (json['status'] as String?)?.toLowerCase().trim();
    final status =
        rawStatus == 'alert' ? WeatherStatus.alert : WeatherStatus.normal;

    return WeatherResponse(
      status: status,
      city: (json['city'] as String?)?.trim() ?? '',
      temperature: _toDouble(json['temperature']),
      windspeed: _toDouble(json['windspeed']),
      message: json['message'] as String?,
      advisory: json['advisory'] as String?,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
