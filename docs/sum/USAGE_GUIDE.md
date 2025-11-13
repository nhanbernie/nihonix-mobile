# AuthInterceptor - Hướng dẫn sử dụng

## ✅ Đã implement

### 1. Dependencies
- ✅ **TokenStore** - `HiveTokenStore` (sử dụng Hive đã có sẵn)
- ✅ **NetworkInfo** - `ConnectivityNetworkInfo` (sử dụng connectivity_plus)
- ✅ **AuthRemoteDataSource** - `AuthRemoteDataSourceImpl`
- ✅ **ApiClient** - Dio client với AuthInterceptor đã cấu hình
- ✅ **Providers** - Riverpod providers cho dependency injection
- ✅ **Examples** - Login và Profile screens

### 2. Files đã tạo

```
lib/
├── core/
│   ├── network/
│   │   ├── auth_interceptor.dart       # Main interceptor
│   │   ├── api_client.dart             # ✅ Dio client setup
│   │   ├── network_info.dart           # ✅ Network check
│   │   └── providers.dart              # ✅ Riverpod providers
│   └── storage/
│       └── token_store.dart            # ✅ Token storage
├── features/
│   ├── auth/
│   │   ├── data/datasources/
│   │   │   └── auth_remote_datasource.dart  # ✅ Refresh token API
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart       # ✅ Auth logic
│   │       └── pages/
│   │           └── login_example.dart       # ✅ Login screen
│   └── profile/
│       └── presentation/pages/
│           └── profile_example.dart         # ✅ API usage example
└── main.dart                           # ✅ Hive initialization
```

## 🚀 Cách sử dụng

### 1. Khởi tạo (đã setup trong main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Hive
  await Hive.initFlutter();

  // Khởi tạo TokenStore
  final tokenStore = HiveTokenStore();
  await tokenStore.init();

  runApp(const ProviderScope(child: MainApp()));
}
```

### 2. Sử dụng ApiClient với Riverpod

```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    
    return ElevatedButton(
      onPressed: () async {
        try {
          // AuthInterceptor tự động gắn Bearer token
          final response = await apiClient.dio.get('/users/me');
          print('User: ${response.data}');
        } on DioException catch (e) {
          // Xử lý errors
          if (e.error is NoInternetException) {
            showSnackBar('Không có kết nối mạng');
          } else if (e.error is UnauthorizedException) {
            // onUnauthorized đã tự động navigate về login
            showSnackBar('Phiên đăng nhập đã hết hạn');
          }
        }
      },
      child: Text('Fetch User'),
    );
  }
}
```

### 3. Login flow

```dart
// Trong auth_provider.dart
Future<void> login({
  required String email,
  required String password,
}) async {
  final apiClient = ref.read(apiClientProvider);

  // Gọi API login (không cần Bearer token)
  final response = await apiClient.dio.post(
    '/auth/login',
    data: {'email': email, 'password': password},
  );

  // Lưu tokens
  await apiClient.saveTokens(
    accessToken: response.data['access_token'],
    refreshToken: response.data['refresh_token'],
  );
}
```

### 4. Authenticated requests

```dart
// AuthInterceptor tự động gắn Bearer token
final response = await apiClient.dio.get('/users/me');

// POST request
final createResponse = await apiClient.dio.post(
  '/posts',
  data: {'title': 'Hello', 'content': 'World'},
);

// PUT request
final updateResponse = await apiClient.dio.put(
  '/users/me',
  data: {'name': 'New Name'},
);
```

### 5. Logout

```dart
Future<void> logout() async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.clearTokens();
  // Navigate to login
}
```

### 6. Xử lý errors

```dart
try {
  final response = await apiClient.dio.get('/users/me');
} on DioException catch (e) {
  if (e.error is NoInternetException) {
    // Không có mạng
    showError('Không có kết nối mạng');
  } else if (e.error is UnauthorizedException) {
    // Token hết hạn, refresh thất bại
    // onUnauthorized callback đã được gọi
    showError('Phiên đăng nhập đã hết hạn');
  } else if (e.error is ForbiddenException) {
    // Không có quyền
    showError('Bạn không có quyền truy cập');
  } else if (e.error is NotFoundException) {
    // Không tìm thấy
    showError('Không tìm thấy dữ liệu');
  } else if (e.error is BadRequestException) {
    // Request không hợp lệ
    final exception = e.error as BadRequestException;
    showError(exception.message);
  } else if (e.error is ServerException) {
    // Lỗi server
    showError('Lỗi máy chủ. Vui lòng thử lại sau');
  } else if (e.error is RequestTimeoutException) {
    // Timeout
    showError('Yêu cầu quá thời gian chờ');
  } else {
    // Lỗi khác
    showError('Đã xảy ra lỗi không xác định');
  }
}
```

## 🔧 Cấu hình

### 1. Thay đổi base URL

Sửa trong `lib/core/network/providers.dart`:

```dart
final apiClientProvider = Provider<ApiClient>((ref) {
  const baseUrl = 'https://your-api.com'; // Thay đổi ở đây
  
  return ApiClient(
    baseUrl: baseUrl,
    tokenStore: ref.read(tokenStoreProvider),
    networkInfo: ref.read(networkInfoProvider),
    onUnauthorized: () async {
      // Navigate to login
      ref.read(routerProvider).go('/login');
    },
  );
});
```

### 2. Thay đổi excluded paths

Sửa trong `lib/core/network/api_client.dart`:

```dart
dio.interceptors.add(
  AuthInterceptor(
    // ...
    paths: AuthPathsConfig(
      excludedPaths: [
        '/auth/login',
        '/auth/register',
        '/auth/refresh',
        '/public',        // Thêm paths không cần token
      ],
      refreshPath: '/auth/refresh',
    ),
  ),
);
```

### 3. Thay đổi timeout

```dart
ApiClient(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 15),  // Thay đổi
  receiveTimeout: const Duration(seconds: 30),  // Thay đổi
  // ...
)
```

### 4. Thay đổi retry config

Sửa trong `lib/core/network/api_client.dart`:

```dart
dio.interceptors.add(
  AuthInterceptor(
    // ...
    retryIdempotentMethods: const ['GET', 'HEAD', 'OPTIONS'],
    maxRetries: 3,  // Thay đổi số lần retry
  ),
);
```

## 📝 Examples

### Example 1: Login Screen

Xem file: `lib/features/auth/presentation/pages/login_example.dart`

```dart
// Sử dụng auth provider
await ref.read(authProvider.notifier).login(
  email: email,
  password: password,
);

// Kiểm tra state
final authState = ref.read(authProvider);
if (authState.isAuthenticated) {
  // Navigate to home
}
```

### Example 2: Profile Screen

Xem file: `lib/features/profile/presentation/pages/profile_example.dart`

```dart
// Fetch user data
final apiClient = ref.read(apiClientProvider);
final response = await apiClient.dio.get('/users/me');

// Update profile
await apiClient.dio.put('/users/me', data: {...});
```

## 🎯 Tính năng tự động

### 1. Auto attach Bearer token
- ✅ Tự động gắn token vào mọi request (trừ excluded paths)
- ✅ Không cần thêm header manually

### 2. Auto refresh token
- ✅ Tự động refresh khi nhận 401
- ✅ Queue và replay các request bị 401
- ✅ Single-flight pattern (tránh race condition)

### 3. Network check
- ✅ Kiểm tra mạng trước khi gửi request
- ✅ Throw NoInternetException nếu offline

### 4. Retry logic
- ✅ Retry idempotent methods (GET, HEAD, OPTIONS)
- ✅ Exponential backoff: 200ms → 600ms → 1400ms
- ✅ Retry với timeout và 5xx errors

### 5. Error handling
- ✅ Map DioException sang custom exceptions
- ✅ Extract message từ response
- ✅ Thông báo lỗi thân thiện

## 🔒 Bảo mật

- ✅ Token được lưu trong Hive (encrypted nếu cần)
- ✅ Token được mask trong logs
- ✅ Chỉ log trong debug mode
- ✅ Clear token khi logout

## 🧪 Testing

Xem file: `test/core/network/auth_interceptor_test.dart`

```bash
# Run tests
flutter test test/core/network/auth_interceptor_test.dart
```

## 📚 Tài liệu

- [AUTH_INTERCEPTOR_README.md](AUTH_INTERCEPTOR_README.md) - Documentation đầy đủ
- [QUICK_START.md](QUICK_START.md) - Quick start guide
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Implementation summary

## ✨ Next Steps

1. **Thay đổi base URL** theo API thực tế của bạn
2. **Implement onUnauthorized** để navigate về login screen
3. **Test với API thực** để đảm bảo format response đúng
4. **Customize error messages** cho phù hợp với app
5. **Thêm analytics** để track errors và refresh failures

## 🎉 Hoàn thành!

AuthInterceptor đã sẵn sàng sử dụng! Chỉ cần:
1. Thay đổi base URL
2. Implement onUnauthorized callback
3. Gọi API như bình thường

AuthInterceptor sẽ tự động xử lý:
- ✅ Token management
- ✅ Network check
- ✅ Auto refresh
- ✅ Retry logic
- ✅ Error handling

