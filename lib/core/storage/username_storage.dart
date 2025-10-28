import 'package:shared_preferences/shared_preferences.dart';

/// Username storage for Remember Me functionality
class UsernameStorage {
  static const String _keyUsername = 'remembered_username';

  /// Save username to SharedPreferences
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  /// Get saved username from SharedPreferences
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  /// Clear saved username from SharedPreferences
  static Future<void> clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
  }

  /// Check if username is saved
  static Future<bool> hasUsername() async {
    final username = await getUsername();
    return username != null && username.isNotEmpty;
  }
}
