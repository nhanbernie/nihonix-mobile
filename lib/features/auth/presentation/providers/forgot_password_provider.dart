import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nihonix/features/auth/domain/entities/forgot_password_request.dart';
import 'package:nihonix/features/auth/domain/entities/verify_code_request.dart';
import 'package:nihonix/features/auth/domain/entities/reset_password_request.dart';
import 'package:nihonix/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:nihonix/features/auth/domain/usecases/verify_code_usecase.dart';
import 'package:nihonix/features/auth/domain/usecases/reset_password_usecase.dart';
import 'auth_di.dart';

part 'forgot_password_provider.g.dart';

@riverpod
class ForgotPasswordNotifier extends _$ForgotPasswordNotifier {
  @override
  ForgotPasswordState build() {
    return const ForgotPasswordState();
  }

  Future<void> sendResetCode(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final useCase = ref.read(forgotPasswordUseCaseProvider);
      await useCase(ForgotPasswordRequest(email: email));

      state = state.copyWith(
        isLoading: false,
        isCodeSent: true,
        email: email,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> verifyCode(String code) async {
    if (state.email == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final useCase = ref.read(verifyCodeUseCaseProvider);
      final result = await useCase(VerifyCodeRequest(
        email: state.email!,
        code: code,
      ));

      // Lưu token từ response
      final token = result['token'] as String?;

      state = state.copyWith(
        isLoading: false,
        isCodeVerified: true,
        verifiedCode: code,
        resetToken: token,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> resetPassword(String newPassword) async {
    if (state.resetToken == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final useCase = ref.read(resetPasswordUseCaseProvider);
      await useCase(ResetPasswordRequest(
        email: state.email!,
        code: state.resetToken!, // Sử dụng token thay vì code
        password: newPassword,
      ));

      state = state.copyWith(
        isLoading: false,
        isPasswordReset: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const ForgotPasswordState();
  }
}

@riverpod
ForgotPasswordUseCase forgotPasswordUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repository);
}

@riverpod
VerifyCodeUseCase verifyCodeUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyCodeUseCase(repository);
}

@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPasswordUseCase(repository);
}

class ForgotPasswordState {
  final bool isLoading;
  final bool isCodeSent;
  final bool isCodeVerified;
  final bool isPasswordReset;
  final String? email;
  final String? verifiedCode;
  final String? resetToken;
  final String? error;

  const ForgotPasswordState({
    this.isLoading = false,
    this.isCodeSent = false,
    this.isCodeVerified = false,
    this.isPasswordReset = false,
    this.email,
    this.verifiedCode,
    this.resetToken,
    this.error,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isCodeSent,
    bool? isCodeVerified,
    bool? isPasswordReset,
    String? email,
    String? verifiedCode,
    String? resetToken,
    String? error,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isCodeVerified: isCodeVerified ?? this.isCodeVerified,
      isPasswordReset: isPasswordReset ?? this.isPasswordReset,
      email: email ?? this.email,
      verifiedCode: verifiedCode ?? this.verifiedCode,
      resetToken: resetToken ?? this.resetToken,
      error: error,
    );
  }
}
