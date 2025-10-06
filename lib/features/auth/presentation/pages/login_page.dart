import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/custom_button.dart';

/// [LoginPage] là một màn hình (route) có state.
/// Được dựng (build) bởi Flutter khi bạn điều hướng tới path tương ứng
/// trong cấu hình GoRouter (xem ví dụ ở cuối).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
  // ↑ Được Flutter gọi ngay sau khi widget được insert vào cây widget
  //   để tạo ra một đối tượng State quản lý vòng đời & dữ liệu UI.
}

class _LoginPageState extends State<LoginPage> {
  // ↓ Khóa để Form biết cách chạy validate() trên tất cả TextFormField con.
  final _formKey = GlobalKey<FormState>();

  // ↓ Controllers nắm dữ liệu nhập của user.
  //   Được TextFormField đọc/ghi mỗi khi user gõ, và khi build().
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ↓ State UI cục bộ. setState() sẽ trigger build() lại màn hình.
  bool _isLoading = false; // Bật tắt loading cho nút đăng nhập
  bool _obscurePassword = true; // Hiển thị/ẩn mật khẩu

  @override
  void dispose() {
    // ↓ Được Flutter gọi khi State sắp bị gỡ khỏi cây (pop route).
    //   Nơi dọn dẹp tài nguyên để tránh rò rỉ bộ nhớ.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Hàm được gọi khi user bấm nút "Đăng nhập".
  /// Nguồn gọi: onPressed của [CustomButton] ở dưới.
  Future<void> _handleLogin() async {
    // ↓ Gọi validate() trên toàn bộ Form: sẽ chạy từng validator trong các
    //   TextFormField. Nếu có field trả về chuỗi lỗi != null -> false.
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Kích hoạt loading UI cho nút
    });

    // ↓ Demo: giả lập API call 2 giây.
    //   Thực tế: bạn thay bằng call vào AuthRepository / usecase (Dio/Riverpod…).
    await Future.delayed(const Duration(seconds: 2));

    // ↓ "mounted" đảm bảo State còn nằm trong cây (tránh setState sau khi pop).
    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // ↓ Hiện thông báo thành công:
      //   Nguồn gọi: [ScaffoldMessenger] tìm Scaffold gần nhất trong cây.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );

      // ↓ Điều hướng: context.pop() là của go_router.
      //   Nguồn gọi: nó pop route hiện tại, quay về màn trước đó trong stack.
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ↓ build() được Flutter gọi:
    //   - Lần đầu khi widget lên màn
    //   - Mỗi lần setState()
    //   - Khi InheritedWidget/Theme thay đổi…
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.login), // Nguồn text: core/constants
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Form(
          key: _formKey, // Nguồn validate(): _formKey.currentState!.validate()
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.s32),

              // Icon minh họa ở đầu: chỉ là UI thuần, lấy màu từ Theme hiện tại.
              Icon(
                Icons.account_circle,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: AppSizes.s32),

              // === EMAIL FIELD ===
              // Nguồn dữ liệu: _emailController.text
              // Nguồn validate: validator bên dưới (được Form gọi)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: AppStrings.email,
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  // ↓ Được Form gọi khi:
                  //   - bạn gọi _formKey.currentState!.validate()
                  //   - hoặc field thay đổi (nếu autovalidateMode bật)
                  if (value == null || value.isEmpty) {
                    return AppStrings.required;
                  }
                  if (!value.contains('@')) {
                    return AppStrings.invalidEmail;
                  }
                  return null; // null = hợp lệ
                },
              ),

              const SizedBox(height: AppSizes.s16),

              // === PASSWORD FIELD ===
              // Nguồn dữ liệu: _passwordController.text
              // suffixIcon gọi setState để toggle hiện/ẩn mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Nguồn cập nhật UI: setState -> build() chạy lại
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
                  // ↓ Được Form gọi thông qua _formKey.currentState!.validate()
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
              // Nguồn gọi: onPressed -> hiển thị SnackBar (tạm thời)
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

              // === Nút ĐĂNG NHẬP ===
              // Nguồn gọi: onPressed -> _handleLogin()
              // UI loading đến từ _isLoading
              CustomButton(
                onPressed: _isLoading ? null : _handleLogin,
                isLoading: _isLoading,
                child: const Text(AppStrings.login),
              ),

              const SizedBox(height: AppSizes.s16),

              // === Nút ĐĂNG KÝ (demo) ===
              // Nguồn gọi: onPressed -> hiện SnackBar (placeholder)
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

              // === Hộp thông tin tài khoản demo ===
              // Thuần UI, không có logic. Dùng Theme để phối màu.
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
