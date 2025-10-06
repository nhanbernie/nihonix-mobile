import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nihonix/core/network/providers.dart';
import 'package:nihonix/core/network/http_exceptions.dart';

part 'auth_provider.freezed.dart';

/// State cho authentication
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? error,
  }) = _AuthState;
}

/// Provider cho authentication logic
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Login với email và password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final apiClient = ref.read(apiClientProvider);

      // Gọi API login
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Parse response
      final data = response.data as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;

      // Lưu tokens
      await apiClient.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      );
    } on DioException catch (e) {
      String errorMessage = 'Đã xảy ra lỗi';

      if (e.error is NoInternetException) {
        errorMessage = 'Không có kết nối mạng';
      } else if (e.error is UnauthorizedException) {
        errorMessage = 'Email hoặc mật khẩu không đúng';
      } else if (e.error is BadRequestException) {
        final exception = e.error as BadRequestException;
        errorMessage = exception.message;
      } else if (e.error is ServerException) {
        errorMessage = 'Lỗi máy chủ. Vui lòng thử lại sau';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    final apiClient = ref.read(apiClientProvider);
    await apiClient.clearTokens();
    state = const AuthState();
  }

  /// Kiểm tra authentication status
  Future<void> checkAuth() async {
    final apiClient = ref.read(apiClientProvider);
    final isAuth = await apiClient.isAuthenticated;
    state = state.copyWith(isAuthenticated: isAuth);
  }
}

/// Provider cho AuthNotifier
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
