import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/l10n/locale_keys.dart';
import '../../../../core/router/route_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/validation/models/username.dart';
import '../../../../core/validation/models/password.dart';
import '../../../../core/validation/models/email.dart';
import '../../../../core/validation/validation_errors.dart';
import '../../../../shared/widgets/custom_input_field.dart';
import '../../../../shared/layouts/auth_layout.dart';
import '../widgets/social_login_buttons.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // Form key to validate
  final _formKey = GlobalKey<FormState>();

  // Controllers for TextFormFields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  // Formz models for validation
  Username _username = const Username.pure();
  Email _email = const Email.pure();
  Password _password = const Password.pure();

  // Local UI state
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  /// Handle username change with formz validation
  void _onUsernameChanged(String value) {
    setState(() {
      _username = Username.dirty(value);
    });
  }

  void _onEmailChanged(String value) {
    setState(() {
      _email = Email.dirty(value);
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = Password.dirty(value);
    });
  }

  Future<void> _handleRegister() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Get AuthNotifier and call register
    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim().isEmpty
          ? null
          : _fullNameController.text.trim(),
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
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký thành công! Vui lòng đăng nhập để tiếp tục'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login page
      context.go(AppRoutes.login);
    }
  }

  /// Handle sign in navigation
  void _handleSignIn() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    // Watch AuthState for reactive UI updates
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return AuthLayout(
      title: LocaleKeys.auth_register.tr(),
      subtitle: LocaleKeys.auth_by_creating_account.tr(),
      illustrationPath: null,
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

            // Email field
            CustomInputField(
              controller: _emailController,
              labelText: LocaleKeys.auth_email.tr(),
              hintText: LocaleKeys.auth_email.tr(),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => _email.error?.message,
              onChanged: _onEmailChanged,
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

            // Full name field (optional)
            CustomInputField(
              controller: _fullNameController,
              labelText: LocaleKeys.auth_full_name.tr(),
              hintText: LocaleKeys.auth_full_name.tr(),
            ),
            const SizedBox(height: 24),

            // Social login buttons (includes divider)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: SocialLoginButtons(),
            ),
            const SizedBox(height: 24),

            // Register button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.8),
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
                        LocaleKeys.auth_sign_up.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.auth_already_have_account.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: isLoading ? null : _handleSignIn,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    LocaleKeys.auth_sign_in.tr(),
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
