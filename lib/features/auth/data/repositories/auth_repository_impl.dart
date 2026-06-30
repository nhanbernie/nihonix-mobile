library;

import 'package:nihonix/core/network/http_exceptions.dart';
import 'package:nihonix/core/storage/token_store.dart';
import 'package:nihonix/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nihonix/features/auth/domain/entities/user.dart';
import 'package:nihonix/features/auth/domain/entities/login_result.dart';
import 'package:nihonix/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation của AuthRepository.
///
/// Responsibilities:
/// - Gọi Remote/Local Data Sources
/// - Convert Models <-> Entities
/// - Handle caching logic (nếu cần)
/// - Transform exceptions từ data layer sang domain exceptions
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStore _tokenStore;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStore tokenStore,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStore = tokenStore;

  @override
  Future<LoginResult> login({
    required String username,
    required String password,
  }) async {
    try {
      // 1. Gọi remote data source để login
      final loginResponse = await _remoteDataSource.login(
        username: username,
        password: password,
      );

      // 2. Save both tokens to secure storage for AuthInterceptor
      await _tokenStore.saveAccessToken(loginResponse.accessToken);
      await _tokenStore.saveRefreshToken(loginResponse.refreshToken);

      // 3. Convert Data Model -> Domain Entity và return LoginResult
      return LoginResult(
        user: loginResponse.user.toDomain(),
        accessToken: loginResponse.accessToken,
      );
    } catch (e) {
      // Re-throw domain exceptions
      // Data layer exceptions đã được map sang HttpException bởi AuthInterceptor
      rethrow;
    }
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    try {
      try {
        await _remoteDataSource.logout(refreshToken: refreshToken);
      } catch (e) {
        // Vẫn xóa local tokens dù API fail
      }

      await _tokenStore.clear();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final accessToken = await _tokenStore.readAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        return null;
      }

      final userModel = await _remoteDataSource.getCurrentUser();

      return userModel.toDomain();
    } on UnauthorizedException {
      await _tokenStore.clear();
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final accessToken = await _tokenStore.readAccessToken();
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final userModel = await _remoteDataSource.register(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );

      return userModel.toDomain();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> verifyResetCode({required String code}) async {
    try {
      return await _remoteDataSource.verifyResetCode(code: code);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        token: token,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resendCode({required String email}) async {
    try {
      await _remoteDataSource.resendCode(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
