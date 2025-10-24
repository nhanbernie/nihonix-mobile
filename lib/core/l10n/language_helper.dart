import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Helper class for language management
class LanguageHelper {
  /// Supported languages
  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇬🇧',
    ),
    LanguageModel(
      code: 'vi',
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      flag: '🇻🇳',
    ),
    LanguageModel(
      code: 'ja',
      name: 'Japanese',
      nativeName: '日本語',
      flag: '🇯🇵',
    ),
  ];

  /// Get current language
  static LanguageModel getCurrentLanguage(BuildContext context) {
    final currentLocale = context.locale;
    return supportedLanguages.firstWhere(
      (lang) => lang.code == currentLocale.languageCode,
      orElse: () => supportedLanguages[0],
    );
  }

  /// Change language
  static Future<void> changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    final locale = Locale(languageCode);
    await context.setLocale(locale);
  }

  /// Get language by code
  static LanguageModel? getLanguageByCode(String code) {
    try {
      return supportedLanguages.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }
}

/// Language model
class LanguageModel {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  Locale get locale => Locale(code);

  @override
  String toString() => '$flag $nativeName';
}

