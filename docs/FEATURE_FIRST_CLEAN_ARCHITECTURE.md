# 🏗️ Feature-First + Clean Architecture Guide

Tài liệu này giải thích **từng bước** cách chúng ta tổ chức một feature theo kiến trúc **Feature-First** kết hợp với **Clean Architecture** trong dự án Flutter. Mục tiêu là bạn có thể lần lượt tạo đủ các lớp (domain, data, presentation), hiểu chúng nằm ở đâu và được gọi như thế nào trong flow thực tế.

---

## 0. Tổng quan nhanh

- **Feature-First**: Mỗi tính năng có thư mục riêng trong `lib/features/<feature_name>/`.
- **Clean Architecture**: Chia thành 3 tầng chính
  - **Domain** – Business logic thuần (không phụ thuộc Flutter hay thư viện bên ngoài)
  - **Data** – Chịu trách nhiệm làm việc với API/DB và chuyển đổi dữ liệu
  - **Presentation** – UI + State management
- Mỗi tầng chỉ phụ thuộc vào tầng bên trong nó (Presentation → Domain → Data).

```
lib/
 └─ features/
    └─ auth/
       ├─ domain/
       │  ├─ entities/
       │  ├─ repositories/
       │  └─ usecases/
       ├─ data/
       │  ├─ datasources/
       │  ├─ models/
       │  └─ repositories/
       └─ presentation/
          ├─ pages/
          ├─ providers/
          └─ widgets/
```

---

## 1. Domain Layer – Định nghĩa TRƯỚC

> Domain là nền tảng, nên luôn tạo domain trước rồi các tầng khác mới dựa vào.

### 1.1 Entity – Đại diện cho dữ liệu cốt lõi

- Tạo file trong `domain/entities/`, ví dụ `user.dart`.
- Dùng `freezed` để có bất biến (immutable) + copyWith + so sánh theo giá trị.
- Không viết bất kỳ logic JSON nào tại đây.

```dart
@freezed
sealed class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? avatar,
    @Default('user') String role,
    required DateTime createdAt,
  }) = _User;
}
```

### 1.2 Repository Interface – Giao diện giữa Domain và Data

- Đặt trong `domain/repositories/`, ví dụ `auth_repository.dart`.
- Khai báo các method mà Domain cần (login, logout, ...).
- Không import bất kỳ implementation nào từ data layer.

```dart
abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<void> logout();
  Future<User?> getCurrentUser();
  // ...các method khác
}
```

### 1.3 Use Cases – Business logic cụ thể

- Mỗi hành động chính có một use case, đặt trong `domain/usecases/`.
- Constructor nhận `AuthRepository` (dependency injection).
- Sử dụng `call()` để có thể gọi như một function.

```dart
class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<User> call({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email và password không được để trống');
    }
    return _repository.login(email: email.trim(), password: password);
  }
}
```

> 👉 **Sau bước này:** Domain layer đã hoàn chỉnh. Các tầng còn lại chỉ cần implement giao diện này.

---

## 2. Data Layer – Kết nối API/Storage

### 2.1 Models – DTO & JSON mapping

- Đặt trong `data/models/`, ví dụ `user_model.dart`, `login_request.dart`.
- Dùng `freezed` + `json_serializable` để sinh code JSON tự động.
- Cung cấp hàm chuyển đổi giữa Model ↔ Entity (`toDomain()`, `fromDomain()`).

```dart
@freezed
sealed class UserModel with _$UserModel {
  factory UserModel({
    required String id,
    required String email,
    required String name,
    String? avatar,
    @Default('user') String role,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) { ... }

  User toDomain() => User(
        id: id,
        email: email,
        name: name,
        avatar: avatar,
        role: role,
        createdAt: createdAt,
      );
}
```

### 2.2 Data Sources – Giao tiếp với thế giới bên ngoài

- Đặt trong `data/datasources/`, ví dụ `auth_remote_datasource.dart`.
- Đăng ký Retrofit interface (`auth_api.dart`) để định nghĩa endpoints.
- Bao bọc Retrofit bằng class DataSource để xử lý lỗi và mapping.

```dart
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest body);
  // ...các endpoint khác
}
```

```dart
class AuthRemoteDataSource {
  final AuthApi _api;
  AuthRemoteDataSource(this._api);

  Future<LoginResponse> login({required String email, required String password}) {
    final request = LoginRequest(email: email, password: password);
    return _api.login(request);
  }
}
```

### 2.3 Repository Implementation – Kết nối Domain ↔ Data

- Đặt trong `data/repositories/`, ví dụ `auth_repository_impl.dart`.
- Implements `AuthRepository` bằng cách gọi DataSource và convert Model → Entity.
- Xử lý cache/token nếu cần (ở đây dùng `TokenStore`).

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStore _tokenStore;

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _remote.login(email: email, password: password);
    await _tokenStore.saveAccessToken(response.accessToken);
    return response.user.toDomain();
  }
}
```

> 👉 **Sau bước này:** Domain đã có implementation thật sự để chạy.

---

## 3. Presentation Layer – UI & State Management

### 3.1 Providers – Kết nối UI với Use Case

- Đặt trong `presentation/providers/`.
- `auth_provider.dart` định nghĩa `AuthState` (Freezed) và `AuthNotifier` (extends `Notifier<AuthState>`).
- Inject `LoginUseCase`, `LogoutUseCase`, `GetCurrentUserUseCase` thông qua Riverpod.

```dart
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    final loginUseCase = ref.read(loginUseCaseProvider);
    final user = await loginUseCase(email: email, password: password);
    state = state.copyWith(isLoading: false, isAuthenticated: true, user: user);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
```

### 3.2 Widgets/Pages – Gọi Provider trong UI

- Đặt trong `presentation/pages/` hoặc `presentation/widgets/`.
- Ví dụ `login_page.dart` là `ConsumerStatefulWidget` để truy cập `ref`.
- Gọi `ref.read(authProvider.notifier).login()` khi user bấm nút.

```dart
class LoginPage extends ConsumerStatefulWidget { ... }

Future<void> _handleLogin() async {
  if (!_formKey.currentState!.validate()) return;
  await ref.read(authProvider.notifier).login(
    email: _emailController.text.trim(),
    password: _passwordController.text,
  );
}
```

> 👉 **Sau bước này:** UI đã liên kết với business logic.

---

## 4. Dependency Injection (DI) – Ghép nối tất cả

- File `presentation/providers/auth_di.dart` dùng `@riverpod` để tạo providers cho từng dependency.
- Cấu trúc đi từ dưới nhất (Dio) lên cao nhất (UseCase).

```dart
@riverpod
Dio authDio(Ref ref) => Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

@riverpod
AuthApi authApi(Ref ref) => AuthApi(ref.watch(authDioProvider));

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) => AuthRemoteDataSource(ref.watch(authApiProvider));

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  tokenStore: ref.watch(tokenStoreProvider),
);

@riverpod
LoginUseCase loginUseCase(Ref ref) => LoginUseCase(ref.watch(authRepositoryProvider));
// ...logoutUseCase, getCurrentUserUseCase
```

> **Flow khi UI gọi login:** > `LoginPage` → `AuthNotifier.login()` → `LoginUseCase` → `AuthRepositoryImpl` → `AuthRemoteDataSource` → `AuthApi` (Retrofit) → REST API.

---

## 5. Code Generation – Bước không thể quên

Các file dùng `@freezed` hoặc `@riverpod` cần chạy code generation.

```powershell
dart run build_runner build --delete-conflicting-outputs
```

> Chạy lệnh này mỗi khi bạn thêm/sửa entity, model, provider...

---

## 6. Kiểm thử nhanh

1. **Unit test cho UseCase** – Mock `AuthRepository` để test login logic.
2. **Unit test cho Repository** – Mock `AuthRemoteDataSource` và `TokenStore`.
3. **Widget test** – Dùng `ProviderScope` để bơm fake providers.

---

## 7. Bảng Tra Nhanh "Nó gọi ở đâu?"

| Component              | File                                           | Được gọi bởi       | Trả về/Tác động                     |
| ---------------------- | ---------------------------------------------- | ------------------ | ----------------------------------- |
| `LoginPage`            | `presentation/pages/login_page.dart`           | Người dùng bấm nút | Gọi `authProvider.notifier.login()` |
| `AuthNotifier`         | `presentation/providers/auth_provider.dart`    | UI                 | Chuyển state, gọi UseCase           |
| `LoginUseCase`         | `domain/usecases/login.dart`                   | AuthNotifier       | Gọi `AuthRepository.login()`        |
| `AuthRepositoryImpl`   | `data/repositories/auth_repository_impl.dart`  | UseCase            | Gọi DataSource + TokenStore         |
| `AuthRemoteDataSource` | `data/datasources/auth_remote_datasource.dart` | Repository         | Gọi Retrofit API                    |
| `AuthApi`              | `data/datasources/auth_api.dart`               | DataSource         | Thực hiện HTTP request              |

---

## 8. Checklist khi tạo feature mới

1. **Domain**
   - [ ] Entity(s)
   - [ ] Repository interface
   - [ ] UseCase(s)
2. **Data**
   - [ ] Model(s) + JSON mapping
   - [ ] DataSource(s) (Remote/Local)
   - [ ] Repository implementation
3. **Presentation**
   - [ ] Provider(s) / State management
   - [ ] UI widgets/pages
   - [ ] Navigation & listeners
4. **DI & Config**
   - [ ] Provider graph (DI file)
   - [ ] Base URL, interceptors, token store
   - [ ] build_runner đã chạy

---

## 9. Tham khảo trong dự án

| Hạng mục             | Ví dụ trong auth feature                                          |
| -------------------- | ----------------------------------------------------------------- |
| Entity               | `lib/features/auth/domain/entities/user.dart`                     |
| Repository Interface | `lib/features/auth/domain/repositories/auth_repository.dart`      |
| Use Cases            | `lib/features/auth/domain/usecases/login.dart` (và các file khác) |
| Model                | `lib/features/auth/data/models/user_model.dart`                   |
| Remote Data Source   | `lib/features/auth/data/datasources/auth_remote_datasource.dart`  |
| Repository Impl      | `lib/features/auth/data/repositories/auth_repository_impl.dart`   |
| Providers            | `lib/features/auth/presentation/providers/auth_provider.dart`     |
| DI Graph             | `lib/features/auth/presentation/providers/auth_di.dart`           |
| UI Page              | `lib/features/auth/presentation/pages/login_page.dart`            |

---

## 10. Ghi nhớ

- Luôn bắt đầu từ Domain để đảm bảo business logic rõ ràng.
- Data layer **không** trả trực tiếp Model cho UI – luôn chuyển về Entity.
- Presentation layer **không** biết API/HTTP – chỉ biết Provider & UseCase.
- Khi đổi API schema → sửa ở Model/DataSource, Domain & UI không ảnh hưởng.
- Chạy `build_runner` mỗi lần thay đổi file có annotation.

Chúc bạn xây feature mới thật tự tin với kiến trúc feature-first + clean architecture! 🎉
