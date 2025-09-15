import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );

      // Navigate back to home
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.s32),

              // Login icon
              Icon(
                Icons.account_circle,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: AppSizes.s32),

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
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

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chức năng đang phát triển!'),
                      ),
                    );
                  },
                  child: const Text(AppStrings.forgotPassword),
                ),
              ),

              const SizedBox(height: AppSizes.s24),

              // Login button
              CustomButton(
                onPressed: _isLoading ? null : _handleLogin,
                isLoading: _isLoading,
                child: const Text(AppStrings.login),
              ),

              const SizedBox(height: AppSizes.s16),

              // Register button
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chức năng đăng ký đang phát triển!'),
                    ),
                  );
                },
                child: const Text(AppStrings.register),
              ),

              const Spacer(),

              // Demo credentials info
              Container(
                padding: const EdgeInsets.all(AppSizes.s16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
    );
  }
}
