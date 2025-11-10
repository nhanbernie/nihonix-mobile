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
  bool _isLoading = false;
  final _welcomePrefs = WelcomePreferences();

  void _selectLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  Future<void> _handleLanguageSelection(String languageCode) async {
    setState(() {
      _isLoading = true;
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
            padding: const EdgeInsets.only(
              left: AppSizes.s24,
              right: AppSizes.s24,
              top: AppSizes.s32,
              bottom: 80, // Space for floating button
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
                  onTap: () => _selectLanguage('vi'),
                ),

                const SizedBox(height: AppSizes.s16),

                LanguageOptionCard(
                  flag: '🇬🇧',
                  languageName: 'English',
                  languageCode: 'en',
                  isSelected: _selectedLanguage == 'en',
                  onTap: () => _selectLanguage('en'),
                ),

                const SizedBox(height: AppSizes.s16),

                LanguageOptionCard(
                  flag: '🇯🇵',
                  languageName: '日本語',
                  languageCode: 'ja',
                  isSelected: _selectedLanguage == 'ja',
                  onTap: () => _selectLanguage('ja'),
                ),
              ],
            ),
          ),
        ),
      ),
      // Floating confirm button
      floatingActionButton: _selectedLanguage != null && !_isLoading
          ? Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.s24,
                right: AppSizes.s24,
                // bottom: AppSizes.s24, // Add bottom padding for system nav bar
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FloatingActionButton.extended(
                  onPressed: () => _handleLanguageSelection(_selectedLanguage!),
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

