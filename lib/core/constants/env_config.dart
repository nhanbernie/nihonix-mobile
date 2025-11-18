import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration
class EnvConfig {
  static String get apiBaseUrl {
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }

    return 'https://nihonix-server.onrender.com/api';
  }

  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '60000') ??
      60000; 

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
