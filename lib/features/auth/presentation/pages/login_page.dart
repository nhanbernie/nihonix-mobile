import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/l10n/locale_keys.dart';
import '../../../../core/router/route_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/validation/models/username.dart';
import '../../../../core/validation/models/password.dart';
import '../../../../core/validation/validation_errors.dart';
import '../../../../core/storage/username_storage.dart';
import '../../../../shared/widgets/custom_input_field.dart';
import '../../../../shared/layouts/auth_layout.dart';
import '../widgets/remember_me_checkbox.dart';
import '../widgets/social_login_buttons.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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

  void _onUsernameChanged(String value) {
    setState(() {
      _username = Username.dirty(value);
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = Password.dirty(value);
    });
  }

  void _onRememberMeChanged(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
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

      context.go(AppRoutes.home);
      context.pop();
    }
  }

  void _handleSignUp() {
    context.go(AppRoutes.register);
  }

  void _handleForgotPassword() {
    context.go(AppRoutes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return AuthLayout(
      title: LocaleKeys.auth_welcome_back.tr(),
      subtitle: LocaleKeys.auth_sign_in_to_access.tr(),
      illustrationPath: 'assets/images/login_illustration.png',
      showSocialLogin: false,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Username field
            CustomInputField(
              controller: _usernameController,
              labelText: LocaleKeys.auth_username.tr(),
              hintText: LocaleKeys.auth_username.tr(),
              validator: (value) => _username.error?.message,
              onChanged: _onUsernameChanged,
            ),
            const SizedBox(height: 16),

            // Password field
            CustomInputField(
              controller: _passwordController,
              labelText: LocaleKeys.auth_password.tr(),
              hintText: LocaleKeys.auth_password.tr(),
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF666666),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              validator: (value) => _password.error?.message,
              onChanged: _onPasswordChanged,
            ),
            const SizedBox(height: 16),

            // Remember me and Forgot password in same row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RememberMeCheckbox(
                  initialValue: _rememberMe,
                  onChanged: _onRememberMeChanged,
                ),
                // Forgot password link
                TextButton(
                  onPressed: isLoading ? null : _handleForgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    LocaleKeys.auth_forgot_password.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Social login buttons (includes divider)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: SocialLoginButtons(),
            ),
            const SizedBox(height: 24),

            // Login button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        LocaleKeys.auth_sign_in.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Don't have account? Sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.auth_dont_have_account.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: isLoading ? null : _handleSignUp,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    LocaleKeys.auth_sign_up.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
