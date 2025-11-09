import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
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

  Future<void> _handleLevelSelection(String levelCode) async {
    setState(() {
      _selectedLevel = levelCode;
      _isLoading = true;
    });

    try {
      // TODO: Call API to update user level
      // await ref.read(updateUserLevelProvider(levelCode).future);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        // Navigate to home
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: AppColors.error,
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
          child: SafeArea(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s24,
                    vertical: AppSizes.s16,
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
                          : () => _handleLevelSelection(level['code']),
                    );
                  },
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(AppSizes.s24),
                child: Text(
                  'Bạn có thể thay đổi trình độ sau trong Cài đặt',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.onBackgroundDark.withOpacity(0.5)
                            : AppColors.onBackground.withOpacity(0.5),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

