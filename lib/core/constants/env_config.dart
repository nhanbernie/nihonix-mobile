import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration
/// Dùng để lấy các giá trị từ .env file
class EnvConfig {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.nihonix.com';

  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  static String get appEnv => 
      dotenv.env['APP_ENV'] ?? 'development';

  static bool get enableDebug =>
      dotenv.env['ENABLE_DEBUG']?.toLowerCase() == 'true';

  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction => appEnv == 'production';

  // Print config (debug only)
  static void printConfig() {
    // if (enableDebug) {
    //   print('Environment: $appEnv');
    //   print('API URL: $apiBaseUrl');
    //   print('Timeout: ${apiTimeout}ms');
    // }
  }
}

