# Hướng Dẫn Tách File trong Flutter - HTTP Exceptions

## 📚 Tổng Quan

Chúng ta vừa tách code từ 1 file lớn thành 2 files nhỏ hơn:

```
TRƯỚC:
lib/core/network/
└── auth_interceptor.dart (544 dòng)
    ├── Abstract interfaces (TokenStore, NetworkInfo...)
    ├── HTTP Exceptions (8 classes)
    └── AuthInterceptor (logic chính)

SAU:
lib/core/network/
├── http_exceptions.dart (200 dòng)
│   ├── HttpException (base class)
│   └── 8 specific exceptions
└── auth_interceptor.dart (350 dòng)
    ├── import 'http_exceptions.dart'  ← Import file mới
    ├── Abstract interfaces
    └── AuthInterceptor
```

---

## 🎯 Tại Sao Tách File?

### ✅ Lợi Ích

1. **Single Responsibility Principle (SRP)**

   - Mỗi file chỉ làm 1 việc
   - `http_exceptions.dart`: Định nghĩa exceptions
   - `auth_interceptor.dart`: Xử lý authentication logic

2. **Reusability (Tái sử dụng)**

   ```dart
   // Bây giờ có thể import exceptions ở nhiều nơi:

   // Trong dio_client.dart
   import 'package:nihonix/core/network/http_exceptions.dart';

   // Trong auth_repository.dart
   import 'package:nihonix/core/network/http_exceptions.dart';

   // Trong product_repository.dart
   import 'package:nihonix/core/network/http_exceptions.dart';
   ```

3. **Maintainability (Dễ bảo trì)**

   - Muốn thêm exception mới? → Chỉ sửa `http_exceptions.dart`
   - Muốn sửa interceptor logic? → Chỉ sửa `auth_interceptor.dart`

4. **Testability (Dễ test)**
   - Test exceptions riêng: `http_exceptions_test.dart`
   - Test interceptor riêng: `auth_interceptor_test.dart`

---

## 📖 Giải Thích Syntax Từng Bước

### 1. Abstract Class (Class Trừu Tượng)

```dart
// Keyword: abstract
abstract class HttpException implements Exception {
  final String message;
  final int? statusCode;  // ? = nullable (có thể null)

  HttpException({
    required this.message,  // required = bắt buộc
    this.statusCode,        // không có required = optional
  });
}
```

**Giải thích:**

- `abstract`: Không thể tạo instance trực tiếp

  ```dart
  // ❌ LỖI:
  var error = HttpException(message: 'error');

  // ✅ ĐÚNG:
  var error = UnauthorizedException();  // Dùng subclass
  ```

- `implements Exception`: Cho phép throw và catch

  ```dart
  throw UnauthorizedException();

  try {
    // code
  } catch (e) {
    if (e is HttpException) {
      print(e.message);
    }
  }
  ```

---

### 2. Class Inheritance (Kế Thừa)

```dart
class UnauthorizedException extends HttpException {
  UnauthorizedException({
    String? message,
    super.requestOptions,  // ← Super parameters (Dart 2.17+)
    super.data,
  }) : super(           // ← Initializer list
          message: message ?? 'Default message',
          statusCode: 401,
        );
}
```

**Giải thích:**

#### a) `extends` vs `implements`

```dart
// extends: Kế thừa toàn bộ implementation
class UnauthorizedException extends HttpException { }

// implements: Chỉ kế thừa interface (phải implement lại tất cả)
class MyException implements Exception {
  // Phải tự implement tất cả methods
}
```

#### b) `super.fieldName` (Super Parameters)

```dart
// Cách CŨ (Dart 2.16):
UnauthorizedException({
  RequestOptions? requestOptions,
  dynamic data,
}) : super(requestOptions: requestOptions, data: data);

// Cách MỚI (Dart 2.17+):
UnauthorizedException({
  super.requestOptions,  // ← Tự động truyền lên parent
  super.data,
}) : super(...);
```

**Lợi ích:** Ngắn gọn hơn, ít code lặp lại

#### c) `: super(...)` (Initializer List)

```dart
UnauthorizedException({
  String? message,
}) : super(                    // ← Gọi constructor của parent
      message: message ?? 'Default',
      statusCode: 401,
    );
```

**Thứ tự thực thi:**

1. Tham số của constructor (`String? message`)
2. Initializer list (`: super(...)`)
3. Body của constructor (`{ ... }`)

---

### 3. Import và Export

#### a) Import File Cục Bộ (Local)

```dart
// Trong auth_interceptor.dart:
import 'http_exceptions.dart';  // ← Relative import
```

**Lưu ý:**

- Cùng folder: `'http_exceptions.dart'`
- Folder con: `'sub_folder/file.dart'`
- Folder cha: `'../parent_folder/file.dart'`

#### b) Import Package

```dart
// Import từ package name (recommended):
import 'package:nihonix/core/network/http_exceptions.dart';

// Import từ các package khác:
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
```

**Best Practice:** Dùng package import cho file ở folder khác

---

### 4. Nullable Types

```dart
final String message;   // Non-nullable: Luôn phải có giá trị
final String? error;    // Nullable: Có thể null

// Sử dụng:
String? name;
print(name?.length);           // Safe navigation (null-aware)
print(name ?? 'Unknown');      // Null coalescing
print(name!);                  // Null assertion (dangerous!)
```

**Giải thích:**

- `?`: Type nullable
- `?.`: Chỉ gọi nếu không null
- `??`: Giá trị mặc định khi null
- `!`: Force unwrap (crash nếu null)

---

### 5. Named Parameters

```dart
// Positional parameters (theo thứ tự):
void oldWay(String name, int age, String city) { }
oldWay('John', 25, 'Hanoi');  // Phải đúng thứ tự

// Named parameters (theo tên):
void newWay({
  required String name,  // Bắt buộc
  int? age,              // Optional, có thể null
  String city = 'Hanoi', // Optional với default value
}) { }

newWay(name: 'John', age: 25);           // ✅
newWay(city: 'Saigon', name: 'John');    // ✅ Đổi thứ tự OK
newWay(name: 'John');                    // ✅ Bỏ qua age, city
```

---

### 6. Override và Annotations

```dart
abstract class HttpException implements Exception {
  @override  // ← Annotation: Đánh dấu override method từ parent
  String toString() => '$runtimeType: $message';
}
```

**Giải thích:**

- `@override`: Báo cho analyzer biết đang override
- Giúp phát hiện lỗi nếu parent method bị đổi tên
- `runtimeType`: Lấy tên class thực tế (runtime)

---

## 🔧 Cách Sử Dụng Sau Khi Tách

### 1. Trong Repository

```dart
import 'package:nihonix/core/network/http_exceptions.dart';

class AuthRepository {
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return User.fromJson(response.data);
    } on DioException catch (e) {
      // DioException đã được AuthInterceptor map sang custom exception
      if (e.error is UnauthorizedException) {
        throw UnauthorizedException(message: 'Email hoặc mật khẩu sai');
      } else if (e.error is NoInternetException) {
        throw NoInternetException();
      }
      rethrow;
    }
  }
}
```

### 2. Trong Presentation Layer

```dart
import 'package:nihonix/core/network/http_exceptions.dart';

class LoginController {
  Future<void> login() async {
    try {
      await authRepository.login(email, password);
      // Success
    } on UnauthorizedException catch (e) {
      showError(e.message);  // "Email hoặc mật khẩu sai"
    } on NoInternetException catch (e) {
      showError(e.message);  // "Không có kết nối mạng..."
    } on ServerException catch (e) {
      showError(e.message);  // "Lỗi máy chủ..."
    } catch (e) {
      showError('Đã xảy ra lỗi: $e');
    }
  }
}
```

### 3. Pattern Matching (Dart 3.0+)

```dart
try {
  await apiCall();
} on DioException catch (e) {
  final error = e.error;

  // Pattern matching với switch:
  final message = switch (error) {
    UnauthorizedException() => 'Vui lòng đăng nhập lại',
    NoInternetException() => 'Kiểm tra kết nối mạng',
    ServerException(:final statusCode) => 'Lỗi server $statusCode',
    _ => 'Lỗi không xác định',
  };

  showError(message);
}
```

---

## 📊 So Sánh Trước & Sau

| Tiêu chí            | Trước (1 file)                | Sau (2 files)                   |
| ------------------- | ----------------------------- | ------------------------------- |
| **Số dòng**         | 544 dòng                      | 350 + 200 dòng                  |
| **Reusability**     | ❌ Chỉ dùng trong interceptor | ✅ Import ở nhiều nơi           |
| **Testability**     | ❌ Khó test riêng exceptions  | ✅ Test riêng từng module       |
| **Maintainability** | ❌ Sửa 1 chỗ ảnh hưởng nhiều  | ✅ Mỗi file độc lập             |
| **Import**          | N/A                           | `import 'http_exceptions.dart'` |

---

## 💡 Best Practices

### 1. Đặt Tên File

```dart
// ✅ ĐÚNG: snake_case
http_exceptions.dart
auth_interceptor.dart
user_repository.dart

// ❌ SAI:
HttpExceptions.dart
authInterceptor.dart
UserRepository.dart
```

### 2. Tổ Chức Folder

```
lib/
├── core/
│   ├── network/
│   │   ├── http_exceptions.dart    ← Exceptions
│   │   ├── auth_interceptor.dart   ← Interceptor
│   │   ├── dio_client.dart         ← Dio setup
│   │   └── network_info.dart       ← Network check
│   ├── errors/                      ← Domain errors (khác HTTP errors)
│   └── utils/
└── features/
```

### 3. Export Pattern

```dart
// Tạo file network.dart để export tất cả:
// lib/core/network/network.dart
export 'http_exceptions.dart';
export 'auth_interceptor.dart';
export 'dio_client.dart';

// Bây giờ chỉ cần 1 import:
import 'package:nihonix/core/network/network.dart';
```

---

## 🎓 Tóm Tắt Cho Người Mới

1. **Abstract Class**: Không tạo instance trực tiếp, chỉ dùng để extend
2. **Extends**: Kế thừa code từ parent class
3. **Super**: Truyền giá trị lên constructor của parent
4. **Import**: Sử dụng code từ file khác
5. **Nullable (`?`)**: Cho phép giá trị null
6. **Named Parameters**: Gọi function theo tên, không theo thứ tự
7. **Override**: Ghi đè method từ parent

**Quy tắc tách file:**

- 1 file = 1 responsibility
- Tách khi file > 300-400 dòng
- Tách khi code được dùng lại nhiều nơi
- Giữ related code gần nhau

---

## ✅ Checklist Khi Tách File

- [x] Tạo file mới với tên rõ ràng (`http_exceptions.dart`)
- [x] Copy code cần tách sang file mới
- [x] Thêm import cần thiết ở file mới (`import 'package:dio/dio.dart'`)
- [x] Xóa code đã tách khỏi file cũ
- [x] Thêm import file mới vào file cũ (`import 'http_exceptions.dart'`)
- [x] Chạy `flutter analyze` để check lỗi
- [x] Chạy test để đảm bảo không break code
- [x] Commit changes với message rõ ràng

**Git commit message example:**

```
refactor(network): Extract HTTP exceptions to separate file

- Move all exception classes to http_exceptions.dart
- Update auth_interceptor.dart to import exceptions
- Improve code organization and reusability

BREAKING CHANGE: None (internal refactoring only)
```

---

🎉 **Chúc mừng bạn đã học xong cách tách file trong Flutter!**
