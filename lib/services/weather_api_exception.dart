/// Thrown by [WeatherApiService] whenever the check fails, so the UI
/// can show a single, friendly error state.
class WeatherApiException implements Exception {
  final String message;

  const WeatherApiException(this.message);

  @override
  String toString() => message;
}
