library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStore {
  Future<void> saveAccessToken(String token);

  Future<String?> readAccessToken();

  Future<void> saveRefreshToken(String token);

  Future<String?> readRefreshToken();

  Future<void> clear();

  void dispose();
}

class SecureTokenStore implements TokenStore {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<String?> readAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> readRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  @override
  void dispose() {
    // FlutterSecureStorage không cần dispose
  }
}
