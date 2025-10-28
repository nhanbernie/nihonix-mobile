/// Dependency Injection Providers cho Auth Feature
///
/// Pattern 2025: Riverpod Code Generation với @riverpod annotation.
///
/// Architecture:
/// UseCases → Repository → DataSource → API
///
/// Tất cả dependencies được inject tự động qua Riverpod providers.
library;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/auth_interceptor.dart' show TokenStore;
import '../../../../core/storage/token_store.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';

part 'auth_di.g.dart';

/// Provider cho Dio instance (không có AuthInterceptor).
@riverpod
Dio authDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
}

/// Provider cho AuthApi (Retrofit).
@riverpod
AuthApi authApi(Ref ref) {
  final dio = ref.watch(authDioProvider);
  return AuthApi(dio);
}

/// Provider cho AuthRemoteDataSource.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final api = ref.watch(authApiProvider);
  return AuthRemoteDataSource(api);
}

/// Provider cho TokenStore.
@riverpod
TokenStore tokenStore(Ref ref) {
  return HiveTokenStore();
}

/// Provider cho AuthRepository.
///
/// Pattern: Interface injection - code depends on abstraction, not implementation.
@riverpod
AuthRepository authRepository(Ref ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final tokenStore = ref.watch(tokenStoreProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    tokenStore: tokenStore,
  );
}

/// Provider cho LoginUseCase.
/// Clean Architecture: UI không biết về Repository implementation.
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

/// Provider cho LogoutUseCase.
@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
}

/// Provider cho GetCurrentUserUseCase.
@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

/// Provider cho RegisterUseCase.
@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
}
