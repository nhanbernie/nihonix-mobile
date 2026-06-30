/// Giải thích: Interface vs Implementation - Token Storage
///
/// Đây là ví dụ minh họa cách AuthInterceptor sử dụng TokenStore interface
/// và có thể có nhiều implementations khác nhau.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:nihonix/core/network/auth_interceptor.dart';

// ============================================================================
// IMPLEMENTATION 1: Dùng Hive (đang dùng trong project)
// ============================================================================

/// Implementation sử dụng Hive để lưu token.
///
/// Ưu điểm: Nhanh, encrypted, offline-first
/// Nhược điểm: Không an toàn bằng FlutterSecureStorage trên production
class HiveTokenStore implements TokenStore {
final Box<String> \_box;

// Keys để lưu trong Hive
static const String \_accessTokenKey = 'access_token';
static const String \_refreshTokenKey = 'refresh_token';

HiveTokenStore(this.\_box);

@override
Future<String?> readAccessToken() async {
return \_box.get(\_accessTokenKey); // ← ĐÂY LÀ CODE THỰC
}

@override
Future<String?> readRefreshToken() async {
return \_box.get(\_refreshTokenKey); // ← ĐÂY LÀ CODE THỰC
}

@override
Future<void> saveAccessToken(String token) async {
await \_box.put(\_accessTokenKey, token); // ← ĐÂY LÀ CODE THỰC
}

@override
Future<void> saveRefreshToken(String token) async {
await \_box.put(\_refreshTokenKey, token); // ← ĐÂY LÀ CODE THỰC
}

@override
Future<void> clear() async {
await \_box.clear(); // ← ĐÂY LÀ CODE THỰC
}
}

// ============================================================================
// IMPLEMENTATION 2: Dùng FlutterSecureStorage (an toàn hơn cho production)
// ============================================================================

/// Implementation sử dụng FlutterSecureStorage để lưu token.
///
/// Ưu điểm:
/// - An toàn nhất (sử dụng Keychain trên iOS, KeyStore trên Android)
/// - Token được encrypt tự động
/// - Best practice cho production
///
/// Nhược điểm:
/// - Chậm hơn Hive một chút
/// - Cần thêm dependency
class SecureTokenStore implements TokenStore {
final FlutterSecureStorage \_storage;

static const String \_accessTokenKey = 'secure_access_token';
static const String \_refreshTokenKey = 'secure_refresh_token';

SecureTokenStore(this.\_storage);

@override
Future<String?> readAccessToken() async {
return await \_storage.read(key: \_accessTokenKey); // ← CODE THỰC khác
}

@override
Future<String?> readRefreshToken() async {
return await \_storage.read(key: \_refreshTokenKey); // ← CODE THỰC khác
}

@override
Future<void> saveAccessToken(String token) async {
await \_storage.write(key: \_accessTokenKey, value: token); // ← CODE THỰC khác
}

@override
Future<void> saveRefreshToken(String token) async {
await \_storage.write(key: \_refreshTokenKey, value: token); // ← CODE THỰC khác
}

@override
Future<void> clear() async {
await \_storage.deleteAll(); // ← CODE THỰC khác
}
}

// ============================================================================
// IMPLEMENTATION 3: Dùng SharedPreferences (ít an toàn, dùng cho dev/testing)
// ============================================================================

/// Implementation sử dụng SharedPreferences.
///
/// ⚠️ CHỈ DÙNG CHO DEVELOPMENT/TESTING
/// Không an toàn cho production vì token lưu dạng plain text!
class SharedPrefsTokenStore implements TokenStore {
// Implementation tương tự...

@override
Future<String?> readAccessToken() async {
// Code read từ SharedPreferences
throw UnimplementedError();
}

@override
Future<String?> readRefreshToken() async {
throw UnimplementedError();
}

@override
Future<void> saveAccessToken(String token) async {
throw UnimplementedError();
}

@override
Future<void> saveRefreshToken(String token) async {
throw UnimplementedError();
}

@override
Future<void> clear() async {
throw UnimplementedError();
}
}

// ============================================================================
// VÍ DỤ CÁCH DÙNG: AuthInterceptor KHÔNG BIẾT implementation nào được dùng!
// ============================================================================

/// AuthInterceptor chỉ biết interface TokenStore, KHÔNG biết implementation.
/// Đây là "Dependency Injection" - inject implementation từ bên ngoài.
class Example {
void setupDioWithHive() {
// Scenario 1: Dùng Hive
final hiveBox = Hive.box<String>('auth');
final tokenStore = HiveTokenStore(hiveBox); // ← Implementation cụ thể

    final interceptor = AuthInterceptor(
      tokenStore: tokenStore,  // ← Inject vào đây
      // ... other params
    );

    // Khi AuthInterceptor gọi: await _tokenStore.readAccessToken()
    // → Thực tế gọi: HiveTokenStore.readAccessToken()
    // → Thực thi: return _box.get('access_token')

}

void setupDioWithSecureStorage() {
// Scenario 2: Dùng FlutterSecureStorage
final storage = FlutterSecureStorage();
final tokenStore = SecureTokenStore(storage); // ← Implementation khác

    final interceptor = AuthInterceptor(
      tokenStore: tokenStore,  // ← Inject vào đây
      // ... other params
    );

    // Khi AuthInterceptor gọi: await _tokenStore.readAccessToken()
    // → Thực tế gọi: SecureTokenStore.readAccessToken()
    // → Thực thi: return await _storage.read(key: 'secure_access_token')

}

void setupForTesting() {
// Scenario 3: Mock cho testing
final mockTokenStore = MockTokenStore(); // Fake implementation

    final interceptor = AuthInterceptor(
      tokenStore: mockTokenStore,  // ← Inject mock
      // ... other params
    );

    // Trong test, mockTokenStore có thể return giá trị fake

}
}

// ============================================================================
// FLOW THỰC TẾ KHI GỌI readAccessToken()
// ============================================================================

/// Minh họa flow khi AuthInterceptor gọi \_tokenStore.readAccessToken()
void explainFlow() {
/\*
BƯỚC 1: Setup (trong main.dart hoặc providers.dart)
════════════════════════════════════════════════════

final box = await Hive.openBox<String>('auth');
final tokenStore = HiveTokenStore(box); ← Tạo implementation

final interceptor = AuthInterceptor(
tokenStore: tokenStore, ← Truyền vào constructor
// ...
);

BƯỚC 2: AuthInterceptor lưu reference
════════════════════════════════════════════════════

class AuthInterceptor {
final TokenStore \_tokenStore; ← Lưu như interface

    AuthInterceptor({
      required TokenStore tokenStore,  ← Nhận interface
    }) : _tokenStore = tokenStore;  ← Gán vào field

}

→ \_tokenStore lúc này trỏ đến HiveTokenStore instance

BƯỚC 3: Khi gọi readAccessToken()
════════════════════════════════════════════════════

// Trong AuthInterceptor:
final token = await \_tokenStore.readAccessToken();
│
│ Compile time: Biết method này tồn tại (vì interface khai báo)
│ Runtime: Gọi implementation thực tế (HiveTokenStore)
│
↓
// Thực tế chạy code này:
return \_box.get('access_token'); // Từ HiveTokenStore

BƯỚC 4: Flow hoàn chỉnh
════════════════════════════════════════════════════

AuthInterceptor.\_tokenStore.readAccessToken()
↓ (Dart runtime tìm implementation)
HiveTokenStore.readAccessToken()
↓ (Thực thi code)
\_box.get('access_token')
↓ (Hive query)
return "eyJhbGciOiJIUzI1NiIs..." // Access token
\*/
}

// ============================================================================
// TẠI SAO LÀM VẬY? (Clean Code Benefits)
// ============================================================================

/// ✅ LỢI ÍCH 1: Flexibility (Linh hoạt)
///
/// Có thể đổi storage mà không sửa AuthInterceptor:
/// - Dev: Dùng SharedPreferences (dễ debug)
/// - Production: Dùng FlutterSecureStorage (an toàn)
/// - Testing: Dùng Mock (không cần database thật)
void benefit1() {
// Chỉ cần đổi implementation khi setup:
// final tokenStore = HiveTokenStore(box); ← DEV
// final tokenStore = SecureTokenStore(storage); ← PROD
// final tokenStore = MockTokenStore(); ← TEST

// AuthInterceptor code KHÔNG ĐỔI gì!
}

/// ✅ LỢI ÍCH 2: Testability (Dễ test)
///
/// Có thể test AuthInterceptor mà không cần Hive thật:
class MockTokenStore implements TokenStore {
String? fakeAccessToken;
String? fakeRefreshToken;

@override
Future<String?> readAccessToken() async => fakeAccessToken;

@override
Future<String?> readRefreshToken() async => fakeRefreshToken;

@override
Future<void> saveAccessToken(String token) async {
fakeAccessToken = token;
}

@override
Future<void> saveRefreshToken(String token) async {
fakeRefreshToken = token;
}

@override
Future<void> clear() async {
fakeAccessToken = null;
fakeRefreshToken = null;
}
}

/// ✅ LỢI ÍCH 3: Separation of Concerns (Tách biệt trách nhiệm)
///
/// - AuthInterceptor chỉ lo logic auth (401, refresh token, retry)
/// - TokenStore lo việc lưu/đọc token (Hive/SecureStorage/SharedPrefs)
///
/// → Mỗi class có 1 trách nhiệm duy nhất (Single Responsibility Principle)

/// ✅ LỢI ÍCH 4: Dependency Inversion (Phụ thuộc vào abstraction)
///
/// High-level module (AuthInterceptor) không phụ thuộc vào low-level (Hive)
/// Cả 2 đều phụ thuộc vào abstraction (TokenStore interface)
///
/// ❌ KHÔNG CLEAN:
/// class AuthInterceptor {
/// final Box<String> \_box; ← Phụ thuộc trực tiếp vào Hive!
///
/// // Đổi sang SecureStorage phải sửa toàn bộ AuthInterceptor!
/// }
///
/// ✅ CLEAN CODE:
/// class AuthInterceptor {
/// final TokenStore \_tokenStore; ← Phụ thuộc vào interface!
///
/// // Đổi storage chỉ cần đổi implementation khi inject
/// }
