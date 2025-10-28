import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:formz/formz.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/l10n/locale_keys.dart';
import '../../../../core/validation/models/username.dart';
import '../../../../core/validation/models/email.dart';
import '../../../../core/validation/models/password.dart';
import '../../../../core/validation/models/full_name.dart';
import '../../../../core/validation/validation_errors.dart';
import '../../../../shared/widgets/custom_input_field.dart';
import '../../../../shared/widgets/auth_form.dart';
import '../../../../shared/layouts/auth_layout.dart';
import '../providers/auth_provider.dart';

/// Register page with Clean Architecture & Riverpod
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  // Formz models
  Username _username = const Username.pure();
  Email _email = const Email.pure();
  Password _password = const Password.pure();
  FullName _fullName = const FullName.pure();

  // UI state
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

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

  void _onFullNameChanged(String value) {
    setState(() {
      _fullName = FullName.dirty(value);
    });
  }

  void _onAgreeToTermsChanged(bool value) {
    setState(() {
      _agreeToTerms = value;
    });
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đồng ý với điều khoản và điều kiện'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement register logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng đăng ký đang phát triển!'),
      ),
    );
  }

  void _handleLogin() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: LocaleKeys.auth_get_started.tr(),
      subtitle: LocaleKeys.auth_by_creating_account.tr(),
      illustrationPath: 'assets/images/login_illustration.png',
      showSocialLogin: false,
      child: AuthForm(
        formKey: _formKey,
        onSubmit: _handleRegister,
        submitButtonText: LocaleKeys.auth_get_started.tr(),
        isLoading: false,
        secondaryButtonText: LocaleKeys.auth_already_have_account.tr(),
        onSecondaryPressed: _handleLogin,
        children: [
          // Full name field
          CustomInputField(
            controller: _fullNameController,
            labelText: LocaleKeys.auth_full_name.tr(),
            prefixIcon: Icons.person,
            validator: (value) => _fullName.error?.message,
            onChanged: _onFullNameChanged,
          ),

          // Username field
          CustomInputField(
            controller: _usernameController,
            labelText: LocaleKeys.auth_username.tr(),
            prefixIcon: Icons.person_outline,
            validator: (value) => _username.error?.message,
            onChanged: _onUsernameChanged,
          ),

          // Email field
          CustomInputField(
            controller: _emailController,
            labelText: LocaleKeys.auth_email.tr(),
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => _email.error?.message,
            onChanged: _onEmailChanged,
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

          // Terms and conditions checkbox
          Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(text: LocaleKeys.auth_by_checking_box.tr()),
                      TextSpan(
                        text: LocaleKeys.auth_terms_and_conditions.tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
