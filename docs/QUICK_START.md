# AuthInterceptor - Quick Start Guide

## 🚀 5 phút để tích hợp

### Bước 1: Thêm dependencies vào `pubspec.yaml`

```yaml
dependencies:
  dio: ^5.4.0
  flutter_secure_storage: ^9.0.0
  connectivity_plus: ^5.0.0
```

### Bước 2: Implement TokenStore

Tạo file `lib/core/storage/secure_token_store.dart`:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nihonix_mobile/core/network/auth_interceptor.dart';

class SecureTokenStore implements TokenStore {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> readAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  @override
  Future<String?> readRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
```

### Bước 3: Implement NetworkInfo

Tạo file `lib/core/network/connectivity_network_info.dart`:

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nihonix_mobile/core/network/auth_interceptor.dart';

class ConnectivityNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
```

### Bước 4: Implement AuthRemoteDataSource

Tạo file `lib/data/datasources/auth_remote_datasource.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:nihonix_mobile/core/network/auth_interceptor.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<({String accessToken, String refreshToken})> refreshToken(
    String refreshToken,
  ) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    final data = response.data as Map<String, dynamic>;
    return (
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
  }
}
```

### Bước 5: Setup Dio với AuthInterceptor

Tạo file `lib/core/network/dio_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:nihonix_mobile/core/network/auth_interceptor.dart';
import 'package:nihonix_mobile/core/storage/secure_token_store.dart';
import 'package:nihonix_mobile/core/network/connectivity_network_info.dart';
import 'package:nihonix_mobile/data/datasources/auth_remote_datasource.dart';

class DioClient {
  late final Dio dio;

  DioClient({
    required String baseUrl,
    required Function() onUnauthorized,
  }) {
    // 1. Tạo dependencies
    final tokenStore = SecureTokenStore();
    final networkInfo = ConnectivityNetworkInfo();

    // 2. Tạo Dio riêng cho auth API (không có interceptor)
    final authDio = Dio(BaseOptions(baseUrl: baseUrl));
    final authRemote = AuthRemoteDataSourceImpl(authDio);

    // 3. Tạo Dio chính với AuthInterceptor
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 4. Thêm AuthInterceptor
    dio.interceptors.add(
      AuthInterceptor(
        tokenStore: tokenStore,
        networkInfo: networkInfo,
        authRemote: authRemote,
        onUnauthorized: onUnauthorized,
        paths: AuthPathsConfig(
          excludedPaths: [
            '/auth/login',
            '/auth/register',
            '/auth/refresh',
            '/public/health',
          ],
          refreshPath: '/auth/refresh',
        ),
      ),
    );

    // 5. (Optional) Thêm logging trong debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }
}
```

### Bước 6: Sử dụng trong app

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:nihonix_mobile/core/network/dio_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late final DioClient dioClient;

  MyApp({super.key}) {
    dioClient = DioClient(
      baseUrl: 'https://api.example.com',
      onUnauthorized: () async {
        // Navigate to login screen
        // navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
        print('User unauthorized, please login again');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nihonix',
      home: HomeScreen(dio: dioClient.dio),
    );
  }
}

// home_screen.dart
class HomeScreen extends StatelessWidget {
  final Dio dio;

  const HomeScreen({super.key, required this.dio});

  Future<void> fetchUserData() async {
    try {
      final response = await dio.get('/users/me');
      print('User data: ${response.data}');
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        // Show no internet dialog
        print('No internet connection');
      } else if (e.error is UnauthorizedException) {
        // Already handled by onUnauthorized callback
        print('Unauthorized');
      } else if (e.error is ServerException) {
        // Show server error dialog
        print('Server error');
      } else {
        // Show generic error
        print('Unknown error: ${e.error}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: fetchUserData,
          child: const Text('Fetch User Data'),
        ),
      ),
    );
  }
}
```

## ✅ Xong!

Bây giờ app của bạn đã có:
- ✅ Tự động gắn Bearer token
- ✅ Kiểm tra mạng trước khi gửi request
- ✅ Tự động refresh token khi hết hạn
- ✅ Retry logic cho lỗi tạm thời
- ✅ Exception handling thân thiện

## 🧪 Test thử

```dart
// Test login
final response = await dio.post('/auth/login', data: {
  'email': 'user@example.com',
  'password': 'password123',
});

// Save tokens
await tokenStore.saveAccessToken(response.data['access_token']);
await tokenStore.saveRefreshToken(response.data['refresh_token']);

// Test authenticated request
final userResponse = await dio.get('/users/me');
print('User: ${userResponse.data}');
```

## 📚 Đọc thêm

- [AUTH_INTERCEPTOR_README.md](AUTH_INTERCEPTOR_README.md) - Documentation đầy đủ
- [auth_interceptor_example.dart](auth_interceptor_example.dart) - Ví dụ chi tiết
- [auth_interceptor_test.dart](../../test/core/network/auth_interceptor_test.dart) - Unit tests

## 🐛 Troubleshooting

### Lỗi: Vòng lặp vô hạn khi refresh token

**Giải pháp**: Đảm bảo Dio instance cho auth API không có AuthInterceptor:

```dart
// ❌ SAI
final authDio = dio; // Sử dụng cùng Dio instance

// ✅ ĐÚNG
final authDio = Dio(BaseOptions(baseUrl: baseUrl)); // Tạo Dio mới
```

### Lỗi: Token không được gắn vào request

**Giải pháp**: Kiểm tra path có nằm trong excludedPaths không:

```dart
AuthPathsConfig(
  excludedPaths: ['/auth/login', '/auth/refresh'], // Không gắn token cho các path này
  refreshPath: '/auth/refresh',
)
```

### Lỗi: onUnauthorized được gọi nhiều lần

**Giải pháp**: AuthInterceptor đã implement debounce (2 giây). Nếu vẫn gặp vấn đề, kiểm tra logic navigation.

## 💡 Tips

1. **Sử dụng dependency injection**: Dùng get_it hoặc riverpod để quản lý dependencies
2. **Tách API client**: Tạo class ApiClient wrapper để dễ test
3. **Monitor errors**: Thêm analytics để track refresh token failures
4. **Customize messages**: Thay đổi error messages trong custom exceptions cho phù hợp với app

