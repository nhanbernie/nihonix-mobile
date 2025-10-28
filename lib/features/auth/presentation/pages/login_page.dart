import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/l10n/locale_keys.dart';
import '../../../../core/validation/models/username.dart';
import '../../../../core/validation/models/password.dart';
import '../../../../core/validation/validation_errors.dart';
import '../../../../core/storage/username_storage.dart';
import '../../../../shared/widgets/custom_input_field.dart';
import '../../../../shared/widgets/auth_form.dart';
import '../../../../shared/layouts/auth_layout.dart';
import '../widgets/remember_me_checkbox.dart';
import '../providers/auth_provider.dart';

/// LoginPage với Clean Architecture & Riverpod.
/// - ConsumerStatefulWidget để access Riverpod providers
/// - Không có business logic, chỉ UI và state management
/// - Delegate authentication logic cho AuthProvider
///
/// Architecture flow:
/// LoginPage (UI) -> AuthProvider -> LoginUseCase -> Repository -> DataSource -> API
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Form key để validate tất cả fields
  final _formKey = GlobalKey<FormState>();

  // Controllers cho TextFormFields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Formz models for validation
  Username _username = const Username.pure();
  Password _password = const Password.pure();

  // Local UI state
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedUsername();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Load remembered username from storage
  Future<void> _loadRememberedUsername() async {
    final rememberedUsername = await UsernameStorage.getUsername();
    if (rememberedUsername != null) {
      _usernameController.text = rememberedUsername;
      _rememberMe = true;
      setState(() {
        _username = Username.dirty(rememberedUsername);
      });
    }
  }

  /// Handle username change with formz validation
  void _onUsernameChanged(String value) {
    setState(() {
      _username = Username.dirty(value);
    });
  }

  /// Handle password change with formz validation
  void _onPasswordChanged(String value) {
    setState(() {
      _password = Password.dirty(value);
    });
  }

  /// Handle remember me checkbox change
  void _onRememberMeChanged(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  /// Handle login với Clean Architecture pattern.
  ///
  /// Flow:
  /// 1. Validate form
  /// 2. Call AuthProvider.login() -> LoginUseCase -> Repository
  /// 3. Listen to AuthState changes via ref.watch()
  /// 4. Show success/error messages
  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Get AuthNotifier and call login
    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.login(
      email: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    // Check result
    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (authState.error != null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error!),
          backgroundColor: Colors.red,
        ),
      );
    } else if (authState.isAuthenticated) {
      // Handle remember me
      if (_rememberMe) {
        await UsernameStorage.saveUsername(_usernameController.text.trim());
      } else {
        await UsernameStorage.clearUsername();
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Đăng nhập thành công! Xin chào ${authState.user?.name ?? ""}'),
          backgroundColor: Colors.green,
        ),
      );

      context.pop();
    }
  }

  /// Handle sign up navigation
  void _handleSignUp() {
    // TODO: Navigate to register page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng đăng ký đang phát triển!'),
      ),
    );
  }

  /// Handle forgot password
  void _handleForgotPassword() {
    // TODO: Navigate to forgot password page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng quên mật khẩu đang phát triển!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch AuthState for reactive UI updates
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return AuthLayout(
      title: LocaleKeys.auth_welcome_back.tr(),
      subtitle: LocaleKeys.auth_sign_in_to_access.tr(),
      illustrationPath: 'assets/images/login_illustration.png',
      showSocialLogin: true,
      child: AuthForm(
        formKey: _formKey,
        onSubmit: _handleLogin,
        submitButtonText: LocaleKeys.auth_sign_in.tr(),
        isLoading: isLoading,
        secondaryButtonText: LocaleKeys.auth_dont_have_account.tr(),
        onSecondaryPressed: _handleSignUp,
        children: [
          // Username field
          CustomInputField(
            controller: _usernameController,
            labelText: LocaleKeys.auth_username.tr(),
            prefixIcon: Icons.person,
            validator: (value) => _username.error?.message,
            onChanged: _onUsernameChanged,
          ),

          // Password field
          CustomInputField(
            controller: _passwordController,
            labelText: LocaleKeys.auth_password.tr(),
            prefixIcon: Icons.lock,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            validator: (value) => _password.error?.message,
            onChanged: _onPasswordChanged,
          ),

          // Remember me checkbox
          RememberMeCheckbox(
            initialValue: _rememberMe,
            onChanged: _onRememberMeChanged,
          ),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading ? null : _handleForgotPassword,
              child: Text(LocaleKeys.auth_forgot_password.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
