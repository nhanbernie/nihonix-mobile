import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/auth/presentation/providers/auth_provider.dart';
import '../providers/onboarding_providers.dart';
import '../widgets/level_card.dart';

class LevelSelectionPage extends ConsumerStatefulWidget {
  const LevelSelectionPage({super.key});

  @override
  ConsumerState<LevelSelectionPage> createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends ConsumerState<LevelSelectionPage> {
  String? _selectedLevel;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _levels = [
    {
      'code': 'BEGINNER',
      'name': 'Chưa học bao giờ',
      'description': 'Bắt đầu từ con số 0',
      'icon': Icons.emoji_emotions,
      'color': AppColors.accent4,
    },
    {
      'code': 'N5',
      'name': 'N5 - Sơ cấp',
      'description': 'Hiragana, Katakana, từ vựng cơ bản',
      'icon': Icons.local_florist,
      'color': AppColors.accent4,
    },
    {
      'code': 'N4',
      'name': 'N4 - Trung cấp thấp',
      'description': 'Ngữ pháp cơ bản, giao tiếp đơn giản',
      'icon': Icons.park,
      'color': AppColors.accent3,
    },
    {
      'code': 'N3',
      'name': 'N3 - Trung cấp',
      'description': 'Đọc hiểu văn bản, giao tiếp tự nhiên',
      'icon': Icons.forest,
      'color': AppColors.accent2,
    },
    {
      'code': 'N2',
      'name': 'N2 - Trung cao cấp',
      'description': 'Hiểu tin tức, báo chí, văn học',
      'icon': Icons.landscape,
      'color': AppColors.accent1,
    },
    {
      'code': 'N1',
      'name': 'N1 - Cao cấp',
      'description': 'Thành thạo, gần như người bản xứ',
      'icon': Icons.emoji_events,
      'color': AppColors.primary,
    },
  ];

  void _selectLevel(String levelCode) {
    setState(() {
      _selectedLevel = levelCode;
    });
  }

  Future<void> _handleLevelSelection(String levelCode) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(updateUserLevelProvider(levelCode).future);

      if (mounted) {
        // show quick success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật trình độ thành công'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 700),
          ),
        );

        // Refresh auth state so route guard sees updated user.levelCode
        // Update local auth state so route guard won't redirect back to login
        try {
          ref.read(authProvider.notifier).setUserLevelLocally(levelCode);
        } catch (e) {
          // ignore: avoid_print
          print('[Onboarding] setUserLevelLocally error: $e');
        }

  ref.read(authProvider.notifier).checkAuth();

        // Use path-based navigation (same approach as login page)
        try {
          context.go(AppRoutes.home);
        } catch (navErr) {
          // ignore: avoid_print
          print('[Onboarding] navigation error: $navErr');
        }
      }
    } catch (e) {
      String message = 'Có lỗi xảy ra';
      try {
        message = e.toString();
      } catch (_) {}

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $message'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: colorScheme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: colorScheme.brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            colorScheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.accent3.withOpacity(0.05),
              ],
            ),
          ),
            child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSizes.s24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.school,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSizes.s16),
                    Text(
                      'Trình độ tiếng Nhật của bạn?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.onBackgroundDark
                                : AppColors.onBackground,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      'Chọn trình độ phù hợp để chúng tôi gợi ý nội dung học tập',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.onBackgroundDark.withOpacity(0.7)
                                : AppColors.onBackground.withOpacity(0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Level options (scrollable)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    left: AppSizes.s24,
                    right: AppSizes.s24,
                    top: AppSizes.s16,
                    bottom: 80, // Space for floating button
                  ),
                  itemCount: _levels.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.s16),
                  itemBuilder: (context, index) {
                    final level = _levels[index];
                    return LevelCard(
                      code: level['code'],
                      name: level['name'],
                      description: level['description'],
                      icon: level['icon'],
                      color: level['color'],
                      isSelected: _selectedLevel == level['code'],
                      isLoading: _isLoading && _selectedLevel == level['code'],
                      onTap: _isLoading
                          ? null
                          : () => _selectLevel(level['code']),
                    );
                  },
                ),
              ),
            ],
          ),
      ),
      // Floating confirm button
      floatingActionButton: _selectedLevel != null && !_isLoading
          ? Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.s24,
                right: AppSizes.s24,
                bottom: AppSizes.s24,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FloatingActionButton.extended(
                  onPressed: () => _handleLevelSelection(_selectedLevel!),
                  backgroundColor: AppColors.primary,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Xác nhận',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: AppSizes.s8),
                      const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ),
    );
  }
}

