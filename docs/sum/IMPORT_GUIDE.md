# 🎯 Import Guide - HTTP Exceptions

## 📦 Các Cách Import

Sau khi tách file, bạn có **3 cách import** exceptions:

### 1️⃣ Import Trực Tiếp (Direct Import)

```dart
import 'package:nihonix/core/network/http_exceptions.dart';

// Dùng khi chỉ cần exceptions, không cần interceptor
try {
  await apiCall();
} on UnauthorizedException catch (e) {
  print(e.message);
}
```

**✅ Ưu điểm:** Rõ ràng, chỉ import những gì cần
**❌ Nhược điểm:** Phải import nhiều file nếu dùng cả exceptions và interceptor

---

### 2️⃣ Import Nhiều Files

```dart
import 'package:nihonix/core/network/http_exceptions.dart';
import 'package:nihonix/core/network/auth_interceptor.dart';

// Dùng khi cần cả exceptions và interceptor
class ApiClient {
  final dio = Dio()..interceptors.add(
    AuthInterceptor(
      tokenStore: tokenStore,
      // ...
    ),
  );
}
```

**✅ Ưu điểm:** Kiểm soát chính xác những gì import
**❌ Nhược điểm:** Dài dòng nếu import nhiều files

---

### 3️⃣ Import Tất Cả (Barrel Export) ⭐ RECOMMENDED

```dart
import 'package:nihonix/core/network/network.dart';

// Một import cho tất cả network classes!
// - HttpException và 8 exception classes
// - AuthInterceptor
// - TokenStore, NetworkInfo, AuthRemoteDataSource interfaces
```

**✅ Ưu điểm:**

- Ngắn gọn, chỉ 1 dòng import
- Dễ maintain khi thêm/xóa files
- Kiểu "import all you need from network"

**❌ Nhược điểm:**

- Import cả những class không dùng (nhưng tree-shaking sẽ xóa khi build)

---

## 🎨 Khi Nào Dùng Cách Nào?

### Dùng Direct Import khi:

✅ File nhỏ, chỉ cần 1-2 classes
✅ Muốn rõ ràng dependencies
✅ Đang viết test cho 1 class cụ thể

```dart
// auth_repository_test.dart
import 'package:nihonix/core/network/http_exceptions.dart';

test('should throw UnauthorizedException', () {
  // ...
});
```

---

### Dùng Barrel Export khi:

✅ Cần nhiều classes từ cùng module
✅ Viết feature code (không phải test)
✅ Muốn code ngắn gọn

```dart
// auth_repository.dart
import 'package:nihonix/core/network/network.dart';

class AuthRepository {
  // Có thể dùng AuthInterceptor, exceptions, interfaces...
}
```

---

## 📚 Examples

### Example 1: Repository Layer

```dart
import 'package:nihonix/core/network/network.dart';
import 'package:dio/dio.dart';

class UserRepository {
  final Dio dio;

  UserRepository(this.dio);

  Future<User> getProfile() async {
    try {
      final response = await dio.get('/user/profile');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      // Exceptions đã được AuthInterceptor map sẵn
      if (e.error is UnauthorizedException) {
        throw UnauthorizedException(message: 'Please login again');
      } else if (e.error is NoInternetException) {
        throw NoInternetException();
      }
      rethrow;
    }
  }
}
```

---

### Example 2: Presentation Layer

```dart
import 'package:nihonix/core/network/network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserRepository repository;

  ProfileNotifier(this.repository) : super(ProfileState.initial());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await repository.getProfile();
      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } on UnauthorizedException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } on NoInternetException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } on ServerException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    }
  }
}
```

---

### Example 3: Setup Dio với Interceptor

```dart
import 'package:nihonix/core/network/network.dart';
import 'package:dio/dio.dart';

class DioFactory {
  static Dio create({
    required TokenStore tokenStore,
    required NetworkInfo networkInfo,
    required AuthRemoteDataSource authRemote,
    required VoidCallback onUnauthorized,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
      ),
    );

    // Add AuthInterceptor
    dio.interceptors.add(
      AuthInterceptor(
        tokenStore: tokenStore,
        networkInfo: networkInfo,
        authRemote: authRemote,
        onUnauthorized: onUnauthorized,
        paths: AuthPathsConfig(
          excludedPaths: ['/auth/login', '/auth/register'],
          refreshPath: '/auth/refresh',
        ),
      ),
    );

    return dio;
  }
}
```

---

## 🔄 Migration Guide

Nếu code cũ đang import từ `auth_interceptor.dart`:

### Trước:

```dart
import 'package:nihonix/core/network/auth_interceptor.dart';

try {
  await apiCall();
} on UnauthorizedException catch (e) {
  // ❌ Lỗi: UnauthorizedException không có trong auth_interceptor.dart nữa
}
```

### Sau - Option 1: Import cả 2 files

```dart
import 'package:nihonix/core/network/auth_interceptor.dart';
import 'package:nihonix/core/network/http_exceptions.dart';  // ✅ Thêm này

try {
  await apiCall();
} on UnauthorizedException catch (e) {
  // ✅ OK
}
```

### Sau - Option 2: Dùng barrel export

```dart
import 'package:nihonix/core/network/network.dart';  // ✅ Thay bằng này

try {
  await apiCall();
} on UnauthorizedException catch (e) {
  // ✅ OK
}
```

---

## 🎓 Best Practice

### ✅ DO:

```dart
// 1. Dùng barrel export trong feature code
import 'package:nihonix/core/network/network.dart';

// 2. Dùng direct import trong test
import 'package:nihonix/core/network/http_exceptions.dart';

// 3. Catch specific exceptions trước, generic sau
try {
  await apiCall();
} on UnauthorizedException catch (e) {
  // Handle 401
} on NoInternetException catch (e) {
  // Handle no internet
} on ServerException catch (e) {
  // Handle 5xx
} catch (e) {
  // Handle unknown
}
```

### ❌ DON'T:

```dart
// 1. ❌ Import cả package lớn không cần thiết
import 'package:nihonix/nihonix.dart';  // Too broad!

// 2. ❌ Catch generic exception trước specific
try {
  await apiCall();
} catch (e) {
  // Handle all - never reach specific catches!
} on UnauthorizedException catch (e) {
  // ❌ Unreachable code
}

// 3. ❌ Import file internal
import 'package:nihonix/core/network/auth_interceptor.dart';
import '../../../core/network/http_exceptions.dart';  // ❌ Relative import!
```

---

## 📊 Summary Table

| Import Type          | Use Case                  | Example                                                         |
| -------------------- | ------------------------- | --------------------------------------------------------------- |
| **Direct Import**    | Test, specific needs      | `import 'http_exceptions.dart'`                                 |
| **Multiple Imports** | Need specific files       | `import 'http_exceptions.dart'; import 'auth_interceptor.dart'` |
| **Barrel Export**    | Feature code, convenience | `import 'network.dart'`                                         |

---

## ✅ Checklist After Refactoring

Sau khi tách exceptions, đảm bảo:

- [x] Tạo `http_exceptions.dart` với tất cả exception classes
- [x] Tách exceptions khỏi `auth_interceptor.dart`
- [x] Thêm `import 'http_exceptions.dart'` vào `auth_interceptor.dart`
- [x] Tạo `network.dart` barrel export file
- [x] Update tất cả files đang dùng exceptions:
  - [x] `auth_remote_datasource.dart`
  - [x] `auth_provider.dart`
  - [x] `profile_example.dart`
  - [x] `auth_interceptor_test.dart`
- [x] Chạy `flutter analyze` → No errors
- [x] Chạy tests → All pass
- [x] Update documentation

---

🎉 **Hoàn thành! Giờ bạn có thể import exceptions dễ dàng từ bất kỳ đâu!**
