import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/common_app_bar.dart';
import '../../../../shared/widgets/level_success_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_providers.dart';
import '../providers/profile_provider.dart';
import '../widgets/avatar_picker_button.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _fullNameController;
  String? _selectedLanguage;
  String? _selectedLevel;
  bool _isUpdatingLevel = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current user data
    final user = ref.read(authProvider).user;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _fullNameController = TextEditingController(text: user?.name ?? '');
    _selectedLanguage = user?.language ?? 'vi';
    _selectedLevel = user?.levelCode;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.read(authProvider).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy thông tin người dùng')),
      );
      return;
    }

    // Call update profile
    await ref.read(profileProvider.notifier).updateProfile(
          userId: user.id,
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          fullName: _fullNameController.text.trim(),
          language: _selectedLanguage,
        );

    // Check result
    final profileState = ref.read(profileProvider);
    if (mounted) {
      if (profileState.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin thành công'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else if (profileState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${profileState.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final user = ref.watch(authProvider).user;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CommonAppBar(title: 'Edit Profile'),
        body: Column(
          children: [
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSizes.s24),

                      // Avatar picker button
                      AvatarPickerButton(
                        currentAvatarUrl: user?.avatar,
                        size: 100.0,
                        onImageSelected: (imageFile) async {
                          // Upload avatar
                          await ref.read(profileProvider.notifier).uploadAvatar(
                                imageFile: imageFile,
                              );

                          // Show result
                          if (mounted) {
                            final state = ref.read(profileProvider);
                            if (state.isSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cập nhật avatar thành công!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (state.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Lỗi: ${state.error}'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          }
                        },
                      ),

                      const SizedBox(height: AppSizes.s40),

                      // Username
                      _buildInputField(
                        label: 'Tên đăng nhập',
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập tên đăng nhập';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.s20),

                      // Email
                      _buildInputField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!value.contains('@')) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.s20),

                      // Full Name
                      _buildInputField(
                        label: 'Họ và tên',
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập họ và tên';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.s20),

                      // Language Dropdown
                      _buildLanguageDropdown(),

                      const SizedBox(height: AppSizes.s20),

                      // Level Selection
                      _buildLevelSelector(),

                      const SizedBox(height: AppSizes.s40),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              profileState.isLoading ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: profileState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: AppSizes.s24),
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding:
              const EdgeInsets.only(left: AppSizes.s4, bottom: AppSizes.s8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        // Input field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFBDBDBD),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            enabled: enabled,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: enabled ? const Color(0xFF333333) : Colors.grey.shade500,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.s20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding:
              const EdgeInsets.only(left: AppSizes.s4, bottom: AppSizes.s8),
          child: Text(
            'Ngôn ngữ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        // Dropdown
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFBDBDBD),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: DropdownButtonFormField<String>(
            initialValue: _selectedLanguage,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.s20,
                vertical: 16,
              ),
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
            ),
            dropdownColor: Colors.white,
            items: const [
              DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'jp', child: Text('日本語')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLevelSelector() {
    final levels = [
      {
        'code': 'N5',
        'name': 'Sơ cấp',
        'description': 'Cơ bản nhất',
        'color': Color(0xFF4CAF50),
        'icon': Icons.looks_5,
      },
      {
        'code': 'N4',
        'name': 'Sơ - Trung cấp',
        'description': 'Cơ bản',
        'color': Color(0xFF2196F3),
        'icon': Icons.looks_4,
      },
      {
        'code': 'N3',
        'name': 'Trung cấp',
        'description': 'Trung bình',
        'color': Color(0xFFFF9800),
        'icon': Icons.looks_3,
      },
      {
        'code': 'N2',
        'name': 'Trung - Cao cấp',
        'description': 'Nâng cao',
        'color': Color(0xFFE91E63),
        'icon': Icons.looks_two,
      },
      {
        'code': 'N1',
        'name': 'Cao cấp',
        'description': 'Thành thạo',
        'color': Color(0xFF9C27B0),
        'icon': Icons.looks_one,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Cấp độ học tập',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),

        // Level cards
        ...levels.map((level) {
          final isSelected = _selectedLevel == level['code'];
          final color = level['color'] as Color;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isUpdatingLevel
                    ? null
                    : () async {
                        setState(() {
                          _selectedLevel = level['code'] as String;
                          _isUpdatingLevel = true;
                        });

                        try {
                          final useCase =
                              ref.read(updateUserLevelUseCaseProvider);
                          await useCase(_selectedLevel!);

                          ref
                              .read(authProvider.notifier)
                              .setUserLevelLocally(_selectedLevel!);

                          if (mounted) {
                            // Show success dialog with Lottie
                            SmartDialog.show(
                              builder: (_) => LevelSuccessDialog(
                                levelCode: level['code'] as String,
                                levelName: level['name'] as String,
                                levelColor: color,
                              ),
                              maskColor: Colors.black.withValues(alpha: 0.6),
                              alignment: Alignment.center,
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Lỗi: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            setState(() {
                              final user = ref.read(authProvider).user;
                              _selectedLevel = user?.levelCode;
                            });
                          }
                        } finally {
                          if (mounted) {
                            setState(() => _isUpdatingLevel = false);
                          }
                        }
                      },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Icon(
                        level['icon'] as IconData,
                        color: isSelected ? color : Colors.grey.shade400,
                        size: 28,
                      ),

                      const SizedBox(width: 14),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${level['code']} - ${level['name']}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? color : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              level['description'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Check mark
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: color,
                          size: 22,
                        )
                      else
                        Icon(
                          Icons.circle_outlined,
                          color: Colors.grey.shade300,
                          size: 22,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),

        // Loading indicator
        if (_isUpdatingLevel)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Đang cập nhật...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
