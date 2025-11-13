# 🔍 Flow Diagram: Cách TokenStore Hoạt Động

## 📋 TL;DR (Tóm Tắt Nhanh)

**Câu hỏi**: Khi `AuthInterceptor` gọi `_tokenStore.readAccessToken()`, code nào được chạy?

**Trả lời**: Code trong `HiveTokenStore.readAccessToken()` - lấy token từ Hive database.

---

## 🎯 Flow Đầy Đủ

### BƯỚC 1: Setup trong main.dart hoặc providers.dart

```dart
// 1.1: Khởi tạo Hive
await Hive.initFlutter();

// 1.2: Tạo HiveTokenStore (IMPLEMENTATION CỤ THỂ)
final tokenStore = HiveTokenStore();
await tokenStore.init();  // Mở Hive box

// 1.3: Tạo AuthInterceptor, INJECT tokenStore vào
final interceptor = AuthInterceptor(
  tokenStore: tokenStore,  ← INJECT Ở ĐÂY!
  networkInfo: networkInfo,
  authRemote: authRemote,
  onUnauthorized: () async => navigateToLogin(),
  paths: AuthPathsConfig(
    excludedPaths: ['/auth/login'],
    refreshPath: '/auth/refresh',
  ),
);

// 1.4: Add interceptor vào Dio
final dio = Dio();
dio.interceptors.add(interceptor);
```

---

### BƯỚC 2: AuthInterceptor Constructor

```dart
class AuthInterceptor {
  final TokenStore _tokenStore;  ← Khai báo field kiểu INTERFACE

  AuthInterceptor({
    required TokenStore tokenStore,  ← Parameter kiểu INTERFACE
  }) : _tokenStore = tokenStore;      ← Gán vào field

  // Lúc này _tokenStore TRỎ ĐẾN instance HiveTokenStore
  // (nhưng kiểu compile-time là TokenStore)
}
```

**Giải thích**:

- Compile time: `_tokenStore` có kiểu `TokenStore` (interface)
- Runtime: `_tokenStore` trỏ đến object `HiveTokenStore` (implementation)

---

### BƯỚC 3: Khi Request Nhận 401

```dart
// Trong AuthInterceptor.onError():
if (statusCode == 401 && !_isRefreshPath(path)) {
  _logDebug('Attempting to refresh token...');
  try {
    await _handleTokenRefresh();  ← Gọi method này
```

---

### BƯỚC 4: Inside \_handleTokenRefresh()

```dart
Future<void> _handleTokenRefresh() async {
  // ...

  // ĐÂY LÀ DÒNG BẠN HỎI! 👇
  final refreshToken = await _tokenStore.readRefreshToken();
                             //     ↑
                             //     GỌI METHOD NÀY

  if (refreshToken == null || refreshToken.isEmpty) {
    throw UnauthorizedException(message: 'Không tìm thấy refresh token');
  }

  // Gọi API refresh token
  final tokens = await _authRemote.refreshToken(refreshToken);

  // Lưu token mới 👇 GỌI 2 METHOD NÀY
  await _tokenStore.saveAccessToken(tokens.accessToken);
  await _tokenStore.saveRefreshToken(tokens.refreshToken);
}
```

---

### BƯỚC 5: Dart Runtime Dispatch (Phân Phối)

```
await _tokenStore.readRefreshToken()
         │
         │ Compile time check:
         │ - _tokenStore có kiểu TokenStore
         │ - TokenStore có method readRefreshToken()? ✓
         │
         ↓ Runtime dispatch:
         │ - _tokenStore thực tế trỏ đến object nào?
         │ - → HiveTokenStore instance
         │
         ↓ Jump to implementation:
HiveTokenStore.readRefreshToken()
```

---

### BƯỚC 6: Code Thực Được Chạy

```dart
// File: lib/core/storage/token_store.dart
class HiveTokenStore implements TokenStore {
  static const String _refreshTokenKey = 'refresh_token';
  Box<String>? _box;

  @override
  Future<String?> readRefreshToken() async {
    // ✅ ĐÂY LÀ CODE THỰC SỰ ĐƯỢC CHẠY!
    return _safeBox.get(_refreshTokenKey);
         //   ↓
         //   Hive query: SELECT value FROM auth_tokens WHERE key = 'refresh_token'
         //   Return: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

## 🎨 ASCII Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. SETUP (main.dart)                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  final tokenStore = HiveTokenStore();  ← Tạo implementation     │
│  await tokenStore.init();                                       │
│                                                                 │
│  final interceptor = AuthInterceptor(                           │
│    tokenStore: tokenStore,  ← Inject vào đây                    │
│  );                                                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                          │
                          ↓
┌─────────────────────────────────────────────────────────────────┐
│ 2. AUTHINTERCEPTOR CONSTRUCTOR                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  class AuthInterceptor {                                        │
│    final TokenStore _tokenStore;  ← Lưu reference               │
│                                                                 │
│    AuthInterceptor({                                            │
│      required TokenStore tokenStore,                            │
│    }) : _tokenStore = tokenStore;  ← Gán                        │
│  }                                                              │
│                                                                 │
│  Memory:                                                        │
│  ┌─────────────────┐                                           │
│  │ _tokenStore     │ ──────────┐                               │
│  │ (type: TokenStore) │        │                               │
│  └─────────────────┘          │                               │
│                                │                               │
│                                ↓                               │
│                    ┌─────────────────────┐                     │
│                    │ HiveTokenStore      │                     │
│                    │ instance            │                     │
│                    │ (_box = Hive box)   │                     │
│                    └─────────────────────┘                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                          │
                          ↓
┌─────────────────────────────────────────────────────────────────┐
│ 3. REQUEST BỊ 401                                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  onError() {                                                    │
│    if (statusCode == 401) {                                     │
│      await _handleTokenRefresh();  ← Gọi                        │
│    }                                                            │
│  }                                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                          │
                          ↓
┌─────────────────────────────────────────────────────────────────┐
│ 4. HANDLE TOKEN REFRESH                                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  _handleTokenRefresh() {                                        │
│    // BẠN HỎI Ở ĐÂY! 👇                                         │
│    final token = await _tokenStore.readRefreshToken();          │
│                        //    ↑                                  │
│                        //    METHOD CALL                        │
│  }                                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                          │
                          ↓
┌─────────────────────────────────────────────────────────────────┐
│ 5. DART RUNTIME DISPATCH                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  _tokenStore.readRefreshToken()                                 │
│       │                                                         │
│       │ Compile time:                                           │
│       │ - _tokenStore có kiểu TokenStore                        │
│       │ - Method readRefreshToken() tồn tại? ✓                 │
│       │                                                         │
│       ↓ Runtime:                                                │
│       │ - _tokenStore trỏ đến object nào?                       │
│       │ - → HiveTokenStore instance                             │
│       │                                                         │
│       ↓ Virtual method dispatch:                                │
│       │ - Jump đến HiveTokenStore.readRefreshToken()            │
│       │                                                         │
└───────┼─────────────────────────────────────────────────────────┘
        │
        ↓
┌─────────────────────────────────────────────────────────────────┐
│ 6. HIVETOKENSTORE IMPLEMENTATION                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  class HiveTokenStore implements TokenStore {                   │
│    Box<String>? _box;                                           │
│                                                                 │
│    @override                                                    │
│    Future<String?> readRefreshToken() async {                  │
│      // ✅ CODE NÀY ĐƯỢC CHẠY!                                  │
│      return _safeBox.get('refresh_token');                      │
│            //  ↓                                                │
│            //  Hive database query                              │
│            //  ↓                                                │
│            //  Return: "eyJhbGc..."                             │
│    }                                                            │
│  }                                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                          │
                          ↓
┌─────────────────────────────────────────────────────────────────┐
│ 7. HIVE DATABASE                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Box: auth_tokens                                               │
│  ┌─────────────────────┬───────────────────────────────────┐   │
│  │ Key                 │ Value                             │   │
│  ├─────────────────────┼───────────────────────────────────┤   │
│  │ access_token        │ eyJhbGciOiJIUzI1NiIsInR5cC...     │   │
│  │ refresh_token       │ eyJhbGciOiJIUzI1NiIsInR5cC...  ← │   │
│  └─────────────────────┴───────────────────────────────────┘   │
│                                                                 │
│  Return giá trị này ↑                                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🤔 Tại Sao Khi Trỏ Vào `readAccessToken()` Nó Nhảy Về Interface?

**IDE (VS Code) behavior:**

1. Khi bạn Ctrl+Click vào `_tokenStore.readAccessToken()`
2. IDE nhìn vào kiểu của `_tokenStore` → `TokenStore` (interface)
3. IDE nhảy đến định nghĩa của `TokenStore.readAccessToken()`

**Để nhảy đến implementation:**

Option 1: **Find Implementations** (IDE feature)

```
Right click on readAccessToken()
→ Go to Implementation (Ctrl+F12 trên Windows)
→ Sẽ show list tất cả implementations:
  - HiveTokenStore.readAccessToken()
  - SecureTokenStore.readAccessToken()
  - MockTokenStore.readAccessToken()
```

Option 2: **Trỏ vào class**

```dart
final TokenStore _tokenStore;  ← Trỏ vào TokenStore này
// → Right click → Find Implementations
// → Sẽ show: HiveTokenStore, SecureTokenStore, MockTokenStore
```

Option 3: **Debug mode**

```dart
// Đặt breakpoint tại dòng này:
final token = await _tokenStore.readAccessToken();

// Run debug, khi dừng lại:
// - Step Into (F11) → Nhảy vào implementation thực
// - Hoặc xem Debug Console → Object type = HiveTokenStore
```

---

## 🎓 Khái Niệm OOP

### 1. **Interface (Abstract Class)**

```dart
abstract class TokenStore {
  Future<String?> readAccessToken();  ← CHỈ KH BÁAO, không có body {}
}
```

- Định nghĩa "contract" - những method phải có
- Không có code thực thi
- Không thể tạo instance trực tiếp

### 2. **Implementation (Concrete Class)**

```dart
class HiveTokenStore implements TokenStore {
  @override
  Future<String?> readAccessToken() async {
    return _box.get('access_token');  ← CÓ CODE THỰC THI
  }
}
```

- Phải implement TẤT CẢ methods từ interface
- Có code thực thi
- Có thể tạo instance

### 3. **Polymorphism (Đa hình)**

```dart
TokenStore store1 = HiveTokenStore();        // ✓ OK
TokenStore store2 = SecureTokenStore();      // ✓ OK
TokenStore store3 = MockTokenStore();        // ✓ OK

// Cùng kiểu TokenStore, nhưng behavior khác nhau
await store1.readAccessToken();  // → Đọc từ Hive
await store2.readAccessToken();  // → Đọc từ SecureStorage
await store3.readAccessToken();  // → Return mock data
```

### 4. **Dependency Injection**

```dart
// ❌ KHÔNG CLEAN: Hard-coded dependency
class AuthInterceptor {
  final HiveTokenStore _tokenStore = HiveTokenStore();  // ← Cứng!
}

// ✅ CLEAN: Injected dependency
class AuthInterceptor {
  final TokenStore _tokenStore;

  AuthInterceptor({required TokenStore tokenStore})
    : _tokenStore = tokenStore;  // ← Linh hoạt!
}
```

---

## ✅ Tóm Tắt Cho Người Mới

1. **TokenStore là interface** - chỉ định nghĩa methods
2. **HiveTokenStore là implementation** - có code thực chạy
3. **AuthInterceptor nhận interface** - không biết implementation cụ thể
4. **Khi runtime** - Dart tự động gọi đúng implementation
5. **Lợi ích** - Dễ thay đổi, dễ test, clean code

**Analogy (Ví dụ thực tế)**:

- `TokenStore` = Hợp đồng thuê xe (định nghĩa: xe phải có 4 bánh, chạy được)
- `HiveTokenStore` = Xe Toyota thực tế (implement: có 4 bánh Bridgestone, động cơ V6)
- `AuthInterceptor` = Tài xế (chỉ cần biết xe theo hợp đồng, không cần biết xe gì)
- Khi chạy = Tài xế lái xe Toyota thực tế, không phải hợp đồng giấy!

---

**📚 Đọc thêm**: `docs/TOKEN_STORE_EXPLAINED.md` - Ví dụ đầy đủ với multiple implementations
