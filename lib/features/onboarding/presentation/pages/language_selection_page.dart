import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/core/storage/welcome_preferences.dart';
import '../widgets/language_option_card.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? _selectedLanguage;
  final _welcomePrefs = WelcomePreferences();

  Future<void> _handleLanguageSelection(String languageCode) async {
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Save language preference
    await _welcomePrefs.saveLanguage(languageCode);

    // Navigate to login
    if (mounted) {
      context.go(AppRoutes.login);
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
            child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s24,
              vertical: AppSizes.s32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & Title
                const Icon(
                  Icons.language,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSizes.s24),
                
                Text(
                  'Nihonix',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: AppSizes.s8),
                
                Text(
                  'Học tiếng Nhật hiệu quả',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.onBackgroundDark.withOpacity(0.7)
                            : AppColors.onBackground.withOpacity(0.7),
                      ),
                ),
                
                const SizedBox(height: AppSizes.s48),
                
                // Subtitle
                Text(
                  'Chọn ngôn ngữ / Select Language',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.onBackgroundDark
                            : AppColors.onBackground,
                      ),
                ),
                
                const SizedBox(height: AppSizes.s32),
                
                // Language Options
                LanguageOptionCard(
                  flag: '🇻🇳',
                  languageName: 'Tiếng Việt',
                  languageCode: 'vi',
                  isSelected: _selectedLanguage == 'vi',
                  onTap: () => _handleLanguageSelection('vi'),
                ),
                
                const SizedBox(height: AppSizes.s16),
                
                LanguageOptionCard(
                  flag: '🇬🇧',
                  languageName: 'English',
                  languageCode: 'en',
                  isSelected: _selectedLanguage == 'en',
                  onTap: () => _handleLanguageSelection('en'),
                ),
                
                const SizedBox(height: AppSizes.s16),
                
                LanguageOptionCard(
                  flag: '🇯🇵',
                  languageName: '日本語',
                  languageCode: 'ja',
                  isSelected: _selectedLanguage == 'ja',
                  onTap: () => _handleLanguageSelection('ja'),
                ),
                
                const SizedBox(height: AppSizes.s48),

                // Footer with curved design
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
                  child: CustomPaint(
                    painter: _CurvedFooterPainter(
                      color: isDark
                          ? AppColors.onBackgroundDark.withOpacity(0.1)
                          : AppColors.onBackground.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s24,
                        vertical: AppSizes.s12,
                      ),
                      child: Text(
                        'Bạn có thể thay đổi ngôn ngữ sau trong Cài đặt',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.onBackgroundDark.withOpacity(0.5)
                                  : AppColors.onBackground.withOpacity(0.5),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

// Custom painter for curved footer background
class _CurvedFooterPainter extends CustomPainter {
  final Color color;

  _CurvedFooterPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from top-left with curve
    path.moveTo(0, 8);
    path.quadraticBezierTo(0, 0, 8, 0);

    // Top edge with slight curve down in middle
    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(
      size.width * 0.5, 4,
      size.width * 0.7, 0,
    );
    path.lineTo(size.width - 8, 0);

    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, 8);

    // Right edge
    path.lineTo(size.width, size.height - 8);

    // Bottom-right corner with curve
    path.quadraticBezierTo(
      size.width, size.height,
      size.width - 8, size.height,
    );

    // Bottom edge with curve up in middle
    path.lineTo(size.width * 0.7, size.height);
    path.quadraticBezierTo(
      size.width * 0.5, size.height - 4,
      size.width * 0.3, size.height,
    );
    path.lineTo(8, size.height);

    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - 8);

    // Left edge
    path.lineTo(0, 8);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

