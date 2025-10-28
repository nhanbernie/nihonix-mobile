import 'package:shared_preferences/shared_preferences.dart';

class WelcomePreferences {
  static const String _keyFirstTime = 'is_first_time';

  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstTime) ?? true;
  }

  Future<void> setNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstTime, false);
  }
}
