import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/weather_response.dart';
import 'weather_api_exception.dart';

/// Talks to the Make.com "Weather Alert Webhook" scenario.
///
/// Sends: { "city": "<name>" }
/// Expects back either a "normal" or an "alert" JSON payload
/// (see [WeatherResponse]).
class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherResponse> checkCity(String city) async {
    final trimmedCity = city.trim();
    if (trimmedCity.isEmpty) {
      throw const WeatherApiException('Please select a city first.');
    }

    Uri uri;
    try {
      uri = Uri.parse(ApiConstants.webhookUrl);
    } catch (_) {
      throw const WeatherApiException(
        'The weather service is not configured correctly.',
      );
    }

    http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'city': trimmedCity}),
          )
          .timeout(ApiConstants.requestTimeout);
    } catch (_) {
      throw const WeatherApiException(
        'Could not reach the weather service. Check your connection and try again.',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const WeatherApiException(
        'The weather service could not process this request. Please try again.',
      );
    }

    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Unexpected response shape');
      }
      data = decoded;
    } catch (_) {
      throw const WeatherApiException(
        'Received an unexpected response from the weather service.',
      );
    }

    try {
      return WeatherResponse.fromJson(data);
    } catch (_) {
      throw const WeatherApiException(
        'Received an incomplete response from the weather service.',
      );
    }
  }
}
