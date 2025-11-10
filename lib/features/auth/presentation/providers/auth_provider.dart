import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';
import 'auth_di.dart'; // Provides: loginUseCaseProvider, logoutUseCaseProvider, getCurrentUserUseCaseProvider

part 'auth_provider.freezed.dart';

/// State
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    User? user,
    String? accessToken,
    String? error,
  }) = _AuthState;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  /// UI -> AuthNotifier (tự động trỏ tới UseCase) -> LoginUseCase -> AuthRepository -> AuthRemoteDataSource -> API
  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (!state.isLoading) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      // Get UseCase from Riverpod DI
      final loginUseCase = ref.read(loginUseCaseProvider);

      // Delegate business logic to UseCase
      final loginResult = await loginUseCase(
        username: username,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: loginResult.user,
        accessToken: loginResult.accessToken,
        error: null,
      );
    } catch (e) {
      // Map domain exceptions to user-friendly messages
      String errorMessage = _mapErrorToMessage(e);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
        error: errorMessage,
      );
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    if (!state.isLoading) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      // Get UseCase from Riverpod DI
      final registerUseCase = ref.read(registerUseCaseProvider);

      // Delegate business logic to UseCase
      final user = await registerUseCase(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: user,
        error: null,
      );
    } catch (e) {
      // Map domain exceptions to user-friendly messages
      String errorMessage = _mapErrorToMessage(e);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
        error: errorMessage,
      );
    }
  }

  // NOTE
  Future<void> logout() async {
    try {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      // TODO: Get refresh token from storage
      await logoutUseCase(refreshToken: '');
      state = const AuthState();
    } catch (e) {
      // Even if logout fails on server, clear local state
      state = const AuthState(
        error: 'Đăng xuất thất bại nhưng đã xóa phiên cục bộ',
      );
    }
  }

  Future<void> checkAuth() async {
    // Don't set loading if already loading to avoid UI flicker
    if (!state.isLoading) {
      state = state.copyWith(isLoading: true);
    }

    try {
      final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
      final user = await getCurrentUserUseCase();

      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
        error: null,
      );
    }
  }

  /// Update the current user's levelCode locally without calling the server.
  /// This helps route guards and UI update immediately after onboarding
  /// when the server update succeeded but fetching current user may fail
  /// transiently.
  void setUserLevelLocally(String levelCode) {
    final current = state.user;
    if (current != null) {
      // user is a Freezed class with copyWith
      final updated = current.copyWith(levelCode: levelCode);
      state = state.copyWith(user: updated);
    }
  }

  /// Update the current user data
  /// Used after profile update to sync auth state
  void updateUser(User updatedUser) {
    state = state.copyWith(user: updatedUser);
  }

  String _mapErrorToMessage(Object error) {
    if (error.toString().contains('NoInternetException')) {
      return 'Không có kết nối mạng';
    } else if (error.toString().contains('UnauthorizedException')) {
      return 'Email hoặc mật khẩu không đúng';
    } else if (error.toString().contains('ValidationException')) {
      return 'Dữ liệu không hợp lệ';
    } else if (error.toString().contains('ServerException')) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau';
    } else {
      return 'Đã xảy ra lỗi: ${error.toString()}';
    }
  }
}

/// Provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
