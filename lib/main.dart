import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/env_config.dart';
import 'core/l10n/multiple_json_asset_loader.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DEVELOPMENT: Uncomment dòng này khi dev
  await dotenv.load(fileName: ".env.develop");

  // PRODUCTION: Uncomment dòng này khi build production
  // await dotenv.load(fileName: ".env.production");

  // Print config (chỉ hiện khi ENABLE_DEBUG=true)
  EnvConfig.printConfig();

  // Set system UI overlay style (status bar & navigation bar)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Khởi tạo EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Khởi tạo Hive (cho các storage khác nếu cần)
  await Hive.initFlutter();

  // TokenStore không cần init() vì sử dụng flutter_secure_storage

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
        Locale('ja'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('vi'), // Mặc định tiếng Việt
      // Sử dụng MultipleJsonAssetLoader để load nhiều file JSON
      assetLoader: const MultipleJsonAssetLoader(),
      child: const ProviderScope(
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      // EasyLocalization integration
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
