// import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration
class EnvConfig {
  String get apiBaseUrl {
    const defineUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (defineUrl.isNotEmpty) {
      return defineUrl;
    }

    // final envUrl = dotenv.env['API_BASE_URL'];
    // if (envUrl != null && envUrl.isNotEmpty) {
    //   return envUrl;
    // }

    return 'https://nihonix-server.onrender.com/api';
  }

  int get apiTimeout =>
      int.tryParse(
        const String.fromEnvironment(
          'API_TIMEOUT',
          defaultValue: '',
        ),
      ) ??
      // int.tryParse(dotenv.env['API_TIMEOUT'] ?? '') ??
      60000;

  String get appEnv => const String.fromEnvironment(
        'APP_ENV',
        defaultValue: '',
      ).isNotEmpty
          ? const String.fromEnvironment('APP_ENV', defaultValue: 'development')
          : /*dotenv.env['APP_ENV'] ??*/ 'development';

  bool get enableDebug {
    final defineValue =
        const String.fromEnvironment('ENABLE_DEBUG', defaultValue: '');
    if (defineValue.isNotEmpty) {
      return defineValue.toLowerCase() == 'true';
    }

    return (/*dotenv.env['ENABLE_DEBUG'] ?? */ 'false').toLowerCase() == 'true';
  }

  bool get isDevelopment => appEnv == 'development';
  bool get isProduction => appEnv == 'production';

  // Print config (debug only)
  void printConfig() {
    if (enableDebug) {
      print('🔧 Environment: $appEnv');
      print('🌐 API URL: $apiBaseUrl');
      print('⏱️ Timeout: ${apiTimeout}ms');
    }
  }
}
