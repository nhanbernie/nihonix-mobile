import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration
/// Dùng để lấy các giá trị từ .env file
class EnvConfig {
  static String get apiBaseUrl {
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }

    // Fallback nếu không có ENV
    return 'https://api.example.com';
  }

  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '60000') ??
      60000; // Tăng lên 60 giây

  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';

  static bool get enableDebug =>
      dotenv.env['ENABLE_DEBUG']?.toLowerCase() == 'true';

  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction => appEnv == 'production';

  // Print config (debug only)
  static void printConfig() {
    if (enableDebug) {
      print('🔧 Environment: $appEnv');
      print('🌐 API URL: $apiBaseUrl');
      print('⏱️ Timeout: ${apiTimeout}ms');
    }
  }
}
