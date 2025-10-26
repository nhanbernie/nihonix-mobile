import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/custom_button.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Local UI state
  bool _obscurePassword = true; // Hiển thị/ẩn mật khẩu

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
      email: _emailController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    // Watch AuthState for reactive UI updates
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.login),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.s16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSizes.s32),

                      Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      const SizedBox(height: AppSizes.s32),

                      // === EMAIL FIELD ===
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading, // Disable khi loading
                        decoration: const InputDecoration(
                          labelText: AppStrings.email,
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.required;
                          }
                          if (!value.contains('@')) {
                            return AppStrings.invalidEmail;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.s16),

                      // === PASSWORD FIELD ===
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        enabled: !isLoading, // Disable khi loading
                        decoration: InputDecoration(
                          labelText: AppStrings.password,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.required;
                          }
                          if (value.length < 6) {
                            return AppStrings.passwordTooShort;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.s8),

                      // === Quên mật khẩu ===
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Chức năng đang phát triển!'),
                                    ),
                                  );
                                },
                          child: const Text(AppStrings.forgotPassword),
                        ),
                      ),

                      const SizedBox(height: AppSizes.s24),

                      // === Nút ĐĂNG NHẬP ===
                      // Loading state từ AuthProvider qua ref.watch()
                      CustomButton(
                        onPressed: isLoading ? null : _handleLogin,
                        isLoading: isLoading,
                        child: const Text(AppStrings.login),
                      ),

                      const SizedBox(height: AppSizes.s16),

                      // === Nút ĐĂNG KÝ (demo) ===
                      // Nguồn gọi: onPressed -> hiện SnackBar (placeholder)
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Chức năng đăng ký đang phát triển!'),
                            ),
                          );
                        },
                        child: const Text(AppStrings.register),
                      ),

                      const Spacer(),

                      // === Hộp thông tin tài khoản demo ===
                      // Thuần UI, không có logic. Dùng Theme để phối màu.
                      Container(
                        padding: const EdgeInsets.all(AppSizes.s16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Demo Credentials',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSizes.s8),
                            const Text('Email: demo@example.com'),
                            const Text('Password: 123456'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
