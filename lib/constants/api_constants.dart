/// Backend configuration for CityPulse.
///
/// IMPORTANT: Replace [webhookUrl] with the live "WeatherRequestWebhook"
/// URL from the Make.com scenario (Webhook module, id 2721027).
/// It looks like: https://hook.us2.make.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxx
class ApiConstants {
  ApiConstants._();

  static const String webhookUrl =
      'https://hook.us2.make.com/YOUR_WEBHOOK_URL_HERE';

  static const Duration requestTimeout = Duration(seconds: 20);
}
