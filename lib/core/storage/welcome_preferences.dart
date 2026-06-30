import 'package:shared_preferences/shared_preferences.dart';

class WelcomePreferences {
  static const String _keyFirstTime = 'is_first_time';
  static const String _keyLanguageSelected = 'language_selected';
  static const String _keyAppLanguage = 'app_language';

  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstTime) ?? true;
  }

  Future<void> setNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstTime, false);
  }

  /// Check if user has selected language
  Future<bool> hasSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLanguageSelected) ?? false;
  }

  /// Save selected language and mark as selected
  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppLanguage, languageCode);
    await prefs.setBool(_keyLanguageSelected, true);
  }

  /// Get saved language (default: 'vi')
  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAppLanguage) ?? 'vi';
  }

  /// Clear language selection (for testing)
  Future<void> clearLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLanguageSelected);
    await prefs.remove(_keyAppLanguage);
  }
}
