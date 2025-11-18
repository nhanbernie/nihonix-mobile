# AuthInterceptor - Production-Ready Authentication Interceptor

## 📋 Tổng quan

`AuthInterceptor` là một Dio interceptor production-ready được thiết kế để xử lý authentication tự động cho Flutter apps. Nó cung cấp các tính năng:

- ✅ Tự động gắn Bearer token vào mọi request
- ✅ Kiểm tra kết nối mạng trước khi gửi request
- ✅ Tự động refresh token khi nhận 401 (với single-flight pattern)
- ✅ Queue và replay các request bị 401 sau khi refresh thành công
- ✅ Retry logic cho idempotent requests với exponential backoff
- ✅ Map DioException sang custom exceptions thân thiện
- ✅ Thread-safe với Completer pattern
- ✅ Logging an toàn (mask token)
- ✅ Debounce onUnauthorized callback

## 🏗️ Kiến trúc

### Dependencies (Abstract Interfaces)

AuthInterceptor phụ thuộc vào các abstract interfaces sau:

```dart
// 1. TokenStore - Lưu/đọc token an toàn
abstract class TokenStore {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> clear();
}

// 2. NetworkInfo - Kiểm tra kết nối mạng
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// 3. AuthRemoteDataSource - Gọi API refresh token
abstract class AuthRemoteDataSource {
  Future<({String accessToken, String refreshToken})> refreshToken(String refreshToken);
}

// 4. OnUnauthorized - Callback khi refresh thất bại
typedef OnUnauthorized = Future<void> Function();

// 5. AuthPathsConfig - Cấu hình paths
class AuthPathsConfig {
  final List<String> excludedPaths; // không gắn Authorization
  final String refreshPath;         // path refresh token
}
```

### Custom Exceptions

AuthInterceptor map các DioException sang custom exceptions thân thiện:

- `NoInternetException` - Không có kết nối mạng
- `UnauthorizedException` - 401 Unauthorized
- `ForbiddenException` - 403 Forbidden
- `NotFoundException` - 404 Not Found
- `BadRequestException` - 400 Bad Request
- `RequestTimeoutException` - Timeout errors
- `ServerException` - 5xx Server errors
- `UnknownHttpException` - Fallback cho các lỗi khác

## 🚀 Cách sử dụng

### 1. Setup cơ bản

```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 20),
));

dio.interceptors.add(AuthInterceptor(
  tokenStore: tokenStore,
  networkInfo: networkInfo,
  authRemote: authRemoteDataSource,
  onUnauthorized: () async {
    // Navigate to login screen
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  },
  paths: AuthPathsConfig(
    excludedPaths: ['/auth/login', '/auth/refresh', '/public/health'],
    refreshPath: '/auth/refresh',
  ),
  retryIdempotentMethods: const ['GET', 'HEAD', 'OPTIONS'],
  maxRetries: 2,
));
```

### 2. Implement TokenStore

Sử dụng `flutter_secure_storage` để lưu token an toàn:

```dart
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
    await _storage.deleteAll();
  }
}
```

### 3. Implement NetworkInfo

Sử dụng `connectivity_plus` để kiểm tra mạng:

```dart
class ConnectivityNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
```

### 4. Implement AuthRemoteDataSource

```dart
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

### 5. Xử lý exceptions trong UI

```dart
try {
  final response = await dio.get('/users/me');
  print('User data: ${response.data}');
} on DioException catch (e) {
  if (e.error is NoInternetException) {
    showSnackBar('Không có kết nối mạng');
  } else if (e.error is UnauthorizedException) {
    showSnackBar('Phiên đăng nhập đã hết hạn');
  } else if (e.error is ServerException) {
    showSnackBar('Lỗi máy chủ. Vui lòng thử lại sau');
  } else {
    showSnackBar('Đã xảy ra lỗi không xác định');
  }
}
```

## 🔄 Luồng xử lý

### 1. onRequest Flow

```
Request → Check Network → Offline? → Throw NoInternetException
                       → Online → Check Excluded Path?
                                → Yes → Skip token
                                → No → Attach Bearer Token → Continue
```

### 2. onError Flow (401)

```
401 Error → Is Refresh Path? → Yes → Clear Token → onUnauthorized()
                            → No → Start Refresh (Single-Flight)
                                 → Refresh Success → Save New Token → Replay Request
                                 → Refresh Failed → Clear Token → onUnauthorized()
```

### 3. Retry Flow

```
Error → Is Idempotent? → No → Map Exception → Reject
                      → Yes → Is Temporary Error? → No → Map Exception → Reject
                                                  → Yes → Retry Count < Max?
                                                        → No → Map Exception → Reject
                                                        → Yes → Exponential Backoff → Retry
```

## 🧪 Testing

Xem file `auth_interceptor_test.dart` để biết cách test:

- ✅ Token attachment cho normal requests
- ✅ Không gắn token cho excluded paths
- ✅ Throw NoInternetException khi offline
- ✅ Refresh token và replay request khi 401
- ✅ Call onUnauthorized khi refresh thất bại
- ✅ Không retry khi 401 từ refresh endpoint
- ✅ Map exceptions đúng (400, 403, 404, 5xx)

## 🔒 Bảo mật

1. **Token Masking**: Token được mask trong logs
   - `Bearer abc123xyz` → `Bearer abc...xyz`

2. **Secure Storage**: Sử dụng FlutterSecureStorage để lưu token

3. **No Token Leakage**: Không log token rõ trong production

4. **Debounce onUnauthorized**: Tránh gọi callback nhiều lần

## ⚙️ Cấu hình

### Retry Configuration

```dart
AuthInterceptor(
  // ...
  retryIdempotentMethods: const ['GET', 'HEAD', 'OPTIONS'],
  maxRetries: 2, // Retry tối đa 2 lần
)
```

### Exponential Backoff

- Attempt 0: 200ms
- Attempt 1: 600ms
- Attempt 2: 1400ms

### Excluded Paths

Các path không cần Bearer token:

```dart
AuthPathsConfig(
  excludedPaths: [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
    '/public/health',
  ],
  refreshPath: '/auth/refresh',
)
```

## 📝 Best Practices

1. **Tách Dio instance cho auth API**: Tránh vòng lặp vô hạn khi refresh token
2. **Implement proper error handling**: Xử lý từng loại exception riêng biệt
3. **Use secure storage**: Luôn dùng FlutterSecureStorage cho token
4. **Test thoroughly**: Viết unit tests cho mọi edge cases
5. **Monitor refresh failures**: Log và track khi refresh token thất bại

## 🐛 Troubleshooting

### Vòng lặp vô hạn khi refresh token

**Nguyên nhân**: Dio instance dùng cho refresh token cũng có AuthInterceptor

**Giải pháp**: Tạo Dio instance riêng cho auth API không có interceptor

### onUnauthorized được gọi nhiều lần

**Nguyên nhân**: Nhiều request cùng nhận 401

**Giải pháp**: AuthInterceptor đã implement debounce (2 giây)

### Token không được gắn vào request

**Nguyên nhân**: Path nằm trong excludedPaths hoặc không có token

**Giải pháp**: Kiểm tra excludedPaths và đảm bảo token đã được lưu

## 📚 Tài liệu tham khảo

- [Dio Documentation](https://pub.dev/packages/dio)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Connectivity Plus](https://pub.dev/packages/connectivity_plus)

