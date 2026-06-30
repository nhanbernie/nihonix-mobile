# 🚀 OOP Cheat Sheet - Interface vs Implementation

## 📋 So Sánh Nhanh

| Khái Niệm    | Interface (Abstract Class)      | Implementation (Concrete Class)              |
| ------------ | ------------------------------- | -------------------------------------------- |
| **Là gì?**   | Contract, blueprint             | Code thực thi                                |
| **Khai báo** | `abstract class TokenStore`     | `class HiveTokenStore implements TokenStore` |
| **Methods**  | Chỉ signature, không có body    | Phải có body cho tất cả methods              |
| **Instance** | ❌ Không thể `new TokenStore()` | ✅ Có thể `new HiveTokenStore()`             |
| **Mục đích** | Định nghĩa "phải có gì"         | Định nghĩa "làm thế nào"                     |

---

## 💻 Code Minh Họa

### Interface (Contract)

```dart
// CHỈ ĐỊNH NGHĨA, không có code
abstract class TokenStore {
  Future<String?> readAccessToken();  // ← Không có body {}
  Future<void> saveAccessToken(String token);
  Future<void> clear();
}
```

### Implementation (Code Thực)

```dart
// CÓ CODE THỰC THI
class HiveTokenStore implements TokenStore {
  final Box<String> _box;

  @override
  Future<String?> readAccessToken() async {
    return _box.get('access_token');  // ← CÓ CODE
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _box.put('access_token', token);  // ← CÓ CODE
  }

  @override
  Future<void> clear() async {
    await _box.clear();  // ← CÓ CODE
  }
}
```

---

## 🔄 Flow: Từ Interface → Implementation

```dart
// 1. Tạo implementation
final HiveTokenStore tokenStore = HiveTokenStore(box);

// 2. Gán cho biến kiểu interface (upcast)
TokenStore store = tokenStore;  // ✅ OK

// 3. Gọi method
await store.readAccessToken();  // ← Runtime gọi HiveTokenStore.readAccessToken()

// Behind the scenes:
// Compile time: Check TokenStore có method readAccessToken()? ✓
// Runtime: Gọi implementation của HiveTokenStore
```

---

## 🎯 Tại Sao Dùng Interface?

### ❌ KHÔNG Dùng Interface

```dart
class AuthInterceptor {
  final HiveTokenStore _tokenStore;  // ← Cứng, phụ thuộc trực tiếp

  AuthInterceptor(this._tokenStore);

  // Muốn đổi sang SecureStorage?
  // → Phải sửa toàn bộ AuthInterceptor!
  // → Không thể test với mock!
}
```

### ✅ Dùng Interface

```dart
class AuthInterceptor {
  final TokenStore _tokenStore;  // ← Linh hoạt, phụ thuộc abstraction

  AuthInterceptor(this._tokenStore);

  // Đổi storage? Chỉ cần inject implementation khác!
  // Test? Inject MockTokenStore!
}

// Usage:
final interceptor1 = AuthInterceptor(HiveTokenStore(box));       // Dev
final interceptor2 = AuthInterceptor(SecureTokenStore(storage)); // Prod
final interceptor3 = AuthInterceptor(MockTokenStore());          // Test
```

---

## 🛠️ Debugging Tips

### Tip 1: Xem Type Thực Tế

```dart
print(_tokenStore.runtimeType);  // → HiveTokenStore
```

### Tip 2: Find Implementation trong IDE

```
Right click trên method → Go to Implementation (Ctrl+F12)
hoặc
Right click trên interface → Find Implementations
```

### Tip 3: Breakpoint + Step Into

```dart
// Đặt breakpoint:
final token = await _tokenStore.readAccessToken();  // ← Đây

// F5 (Run Debug) → Dừng tại đây
// F11 (Step Into) → Nhảy vào HiveTokenStore.readAccessToken()
```

---

## 📦 Các Implementation Có Thể Có

```dart
// Implementation 1: Hive (đang dùng)
class HiveTokenStore implements TokenStore {
  // Lưu trong local database (Hive)
}

// Implementation 2: Secure Storage (an toàn hơn cho prod)
class SecureTokenStore implements TokenStore {
  // Lưu trong iOS Keychain / Android KeyStore
}

// Implementation 3: In-Memory (cho test)
class MemoryTokenStore implements TokenStore {
  String? _accessToken;
  String? _refreshToken;

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<void> saveAccessToken(String token) async {
    _accessToken = token;
  }
}

// Implementation 4: Mock (cho unit test)
class MockTokenStore implements TokenStore {
  // Fake data, không cần database thật
}
```

---

## 🎓 Nguyên Tắc Clean Code

### 1. Dependency Inversion Principle

```
High-level module (AuthInterceptor)
    ↓ phụ thuộc
Interface (TokenStore)
    ↑ phụ thuộc
Low-level module (HiveTokenStore)
```

Cả 2 đều phụ thuộc vào abstraction, không phụ thuộc lẫn nhau!

### 2. Open/Closed Principle

- Open for extension: Thêm implementation mới (SecureTokenStore)
- Closed for modification: Không sửa AuthInterceptor

### 3. Single Responsibility

- AuthInterceptor: Lo logic auth
- TokenStore: Lo lưu/đọc token
- NetworkInfo: Lo check network
- AuthRemoteDataSource: Lo gọi API

---

## ✅ Checklist Khi Implement Interface

```dart
class MyTokenStore implements TokenStore {
  // ✅ Phải có @override cho MỌI method
  @override
  Future<String?> readAccessToken() async {
    // ✅ Phải có body (code thực thi)
    return /* code */;
  }

  @override
  Future<String?> readRefreshToken() async {
    return /* code */;
  }

  @override
  Future<void> saveAccessToken(String token) async {
    // ✅ Signature phải khớp 100%
    // Số parameter, kiểu return, async/sync...
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    /* code */
  }

  @override
  Future<void> clear() async {
    /* code */
  }

  // ✅ Nếu thiếu 1 method nào → Compile error!
}
```

---

## 🔍 Common Mistakes

### ❌ Sai: Quên implements

```dart
class MyTokenStore {  // ← Thiếu implements TokenStore
  Future<String?> readAccessToken() async { }
}

// Không thể dùng:
TokenStore store = MyTokenStore();  // ❌ Compile error!
```

### ❌ Sai: Signature không khớp

```dart
class MyTokenStore implements TokenStore {
  @override
  String? readAccessToken() {  // ❌ Thiếu Future, async
    return null;
  }
}
```

### ❌ Sai: Thiếu @override

```dart
class MyTokenStore implements TokenStore {
  Future<String?> readAccessToken() async {  // ⚠️ Thiếu @override
    return null;  // Nếu TokenStore đổi tên method → không phát hiện lỗi!
  }
}
```

### ✅ Đúng

```dart
class MyTokenStore implements TokenStore {
  @override  // ← Có @override
  Future<String?> readAccessToken() async {  // ← Signature khớp 100%
    return _box.get('access_token');
  }
}
```

---

## 📚 Đọc Thêm

- `docs/TOKEN_STORE_EXPLAINED.md` - Ví dụ chi tiết 3 implementations
- `docs/FLOW_DIAGRAM.md` - Flow diagram đầy đủ
- `docs/HTTP_EXCEPTIONS_REFACTORING.md` - Giải thích abstract class, extends, implements

---

**💡 Remember**: Interface = "Phải có gì", Implementation = "Làm thế nào"!
