# 📋 Quick Reference: HTTP Exceptions

## 🚀 Import Nhanh

```dart
// ⭐ RECOMMENDED: Import tất cả
import 'package:nihonix/core/network/network.dart';

// Hoặc import riêng nếu chỉ cần exceptions:
import 'package:nihonix/core/network/http_exceptions.dart';
```

---

## 📦 8 Exception Classes

| Exception                 | Status Code | Khi Nào Xảy Ra                |
| ------------------------- | ----------- | ----------------------------- |
| `NoInternetException`     | -           | Không có kết nối mạng         |
| `BadRequestException`     | 400         | Dữ liệu request không hợp lệ  |
| `UnauthorizedException`   | 401         | Token hết hạn / chưa login    |
| `ForbiddenException`      | 403         | Không có quyền truy cập       |
| `NotFoundException`       | 404         | Resource không tồn tại        |
| `RequestTimeoutException` | 408         | Request quá thời gian chờ     |
| `ServerException`         | 5xx         | Lỗi server (500, 502, 503...) |
| `UnknownHttpException`    | \*          | Lỗi không xác định            |

---

## 💻 Code Templates

### Template 1: Repository với Error Handling

```dart
import 'package:nihonix/core/network/network.dart';

class YourRepository {
  final Dio dio;

  YourRepository(this.dio);

  Future<YourModel> yourMethod() async {
    try {
      final response = await dio.get('/your-endpoint');
      return YourModel.fromJson(response.data);
    } on DioException catch (e) {
      // AuthInterceptor đã map sang custom exceptions
      if (e.error is UnauthorizedException) {
        throw UnauthorizedException(message: 'Your custom message');
      } else if (e.error is NoInternetException) {
        throw NoInternetException();
      } else if (e.error is ServerException) {
        throw ServerException(message: 'Server error');
      }
      rethrow;
    }
  }
}
```

---

### Template 2: Presentation với UI Error

```dart
import 'package:nihonix/core/network/network.dart';

class YourNotifier extends StateNotifier<YourState> {
  final YourRepository repository;

  YourNotifier(this.repository) : super(YourState.initial());

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await repository.yourMethod();
      state = state.copyWith(
        isLoading: false,
        data: data,
      );
    } on UnauthorizedException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,  // "Phiên đăng nhập hết hạn..."
      );
      // Navigate to login
    } on NoInternetException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,  // "Không có kết nối mạng..."
      );
    } on ServerException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,  // "Lỗi máy chủ..."
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Đã xảy ra lỗi: $e',
      );
    }
  }
}
```

---

### Template 3: Widget với Error Display

```dart
import 'package:nihonix/core/network/network.dart';

class YourWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(yourProvider);

    return Column(
      children: [
        if (state.error != null)
          ErrorBanner(
            message: state.error!,
            onRetry: () => ref.read(yourProvider.notifier).loadData(),
          ),
        if (state.isLoading)
          CircularProgressIndicator(),
        if (state.data != null)
          YourDataWidget(data: state.data!),
      ],
    );
  }
}
```

---

## 🎯 Pattern Matching (Dart 3.0+)

```dart
try {
  await repository.yourMethod();
} on DioException catch (e) {
  final message = switch (e.error) {
    UnauthorizedException() => 'Vui lòng đăng nhập lại',
    NoInternetException() => 'Kiểm tra kết nối mạng',
    ServerException(:final statusCode) => 'Lỗi server $statusCode',
    RequestTimeoutException() => 'Yêu cầu quá thời gian',
    _ => 'Lỗi không xác định',
  };

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
```

---

## 🔧 Custom Exception Messages

```dart
// Throw với custom message:
throw UnauthorizedException(
  message: 'Email hoặc mật khẩu không đúng',  // Custom
  requestOptions: requestOptions,
  data: responseData,
);

// Throw với default message:
throw NoInternetException();  // "Không có kết nối mạng..."
```

---

## 📱 Accessing Exception Properties

```dart
try {
  await apiCall();
} on DioException catch (e) {
  if (e.error is HttpException) {
    final exception = e.error as HttpException;

    print('Message: ${exception.message}');
    print('Status Code: ${exception.statusCode}');
    print('Request Path: ${exception.requestOptions?.path}');
    print('Response Data: ${exception.data}');
  }
}
```

---

## ✅ Checklist Khi Dùng Exceptions

- [ ] Import `package:nihonix/core/network/network.dart`
- [ ] Wrap API call trong `try-catch`
- [ ] Catch `DioException` trước
- [ ] Check `e.error is YourException`
- [ ] Cast sang exception type: `e.error as YourException`
- [ ] Hiển thị `exception.message` cho user
- [ ] Log full exception cho debugging

---

## 🐛 Debug Tips

```dart
// Print full exception info:
try {
  await apiCall();
} on DioException catch (e, stackTrace) {
  print('Error type: ${e.error.runtimeType}');
  print('Error message: ${e.error}');
  print('Response: ${e.response}');
  print('Stack trace: $stackTrace');

  if (e.error is HttpException) {
    final httpError = e.error as HttpException;
    print('Status code: ${httpError.statusCode}');
    print('Request path: ${httpError.requestOptions?.path}');
  }
}
```

---

## 📚 Liên Kết Nhanh

- **Full Guide**: `docs/HTTP_EXCEPTIONS_REFACTORING.md`
- **Import Guide**: `docs/IMPORT_GUIDE.md`
- **Summary**: `docs/REFACTORING_SUMMARY.md`
- **Source Code**: `lib/core/network/http_exceptions.dart`
- **Barrel Export**: `lib/core/network/network.dart`

---

**💡 Tip**: Bookmark page này để reference nhanh khi code!
