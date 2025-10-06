import 'package:hive_flutter/hive_flutter.dart';
import 'package:nihonix/core/network/auth_interceptor.dart';

/// Implementation của TokenStore sử dụng Hive để lưu token.
/// 
/// Hive được chọn vì:
/// - Đã có sẵn trong project (không cần thêm dependency)
/// - Đủ an toàn cho token storage
/// - Nhanh và đơn giản
/// - Hỗ trợ encryption nếu cần (HiveAesCipher)
class HiveTokenStore implements TokenStore {
  static const String _boxName = 'auth_tokens';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Box<String>? _box;

  /// Khởi tạo Hive box. Gọi method này trước khi sử dụng.
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<String>(_boxName);
    }
  }

  /// Đảm bảo box đã được khởi tạo
  Box<String> get _safeBox {
    if (_box == null || !_box!.isOpen) {
      throw StateError(
        'TokenStore chưa được khởi tạo. Gọi init() trước khi sử dụng.',
      );
    }
    return _box!;
  }

  @override
  Future<String?> readAccessToken() async {
    return _safeBox.get(_accessTokenKey);
  }

  @override
  Future<String?> readRefreshToken() async {
    return _safeBox.get(_refreshTokenKey);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _safeBox.put(_accessTokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _safeBox.put(_refreshTokenKey, token);
  }

  @override
  Future<void> clear() async {
    await _safeBox.clear();
  }

  /// Đóng box khi không cần dùng nữa (thường khi dispose app)
  Future<void> dispose() async {
    await _box?.close();
  }
}

