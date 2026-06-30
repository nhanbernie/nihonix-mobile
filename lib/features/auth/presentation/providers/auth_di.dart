library;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:nihonix/core/constants/env_config.dart';
import 'package:nihonix/core/storage/token_store.dart';
import 'package:nihonix/features/auth/data/datasources/auth_api.dart';
import 'package:nihonix/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nihonix/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';
import 'package:nihonix/features/auth/domain/usecases/get_current_user.dart';
import 'package:nihonix/features/auth/domain/usecases/login.dart';
import 'package:nihonix/features/auth/domain/usecases/logout.dart';
import 'package:nihonix/features/auth/domain/usecases/register.dart';

part 'auth_di.g.dart';

/// Provider cho Dio instance (không có AuthInterceptor).
@riverpod
Dio authDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: EnvConfig().apiBaseUrl,
      connectTimeout: Duration(milliseconds: EnvConfig().apiTimeout),
      receiveTimeout: Duration(milliseconds: EnvConfig().apiTimeout),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
}

@riverpod
AuthApi authApi(Ref ref) {
  final dio = ref.watch(authDioProvider);
  return AuthApi(dio);
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final api = ref.watch(authApiProvider);
  return AuthRemoteDataSource(api);
}

@riverpod
TokenStore tokenStore(Ref ref) {
  return SecureTokenStore();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final tokenStore = ref.watch(tokenStoreProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    tokenStore: tokenStore,
  );
}

/// Provider for LoginUseCase.
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
}
