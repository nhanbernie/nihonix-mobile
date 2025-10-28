import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/l10n/language_helper.dart';
import '../../../../core/l10n/locale_keys.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Language settings page
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLanguage = LanguageHelper.getCurrentLanguage(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile_language.tr()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.s16),
        itemCount: LanguageHelper.supportedLanguages.length,
        itemBuilder: (context, index) {
          final language = LanguageHelper.supportedLanguages[index];
          final isSelected = language.code == currentLanguage.code;

          return Card(
            margin: const EdgeInsets.only(bottom: AppSizes.s12),
            child: ListTile(
              leading: Text(
                language.flag,
                style: const TextStyle(fontSize: 32),
              ),
              title: Text(
                language.nativeName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(language.name),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                    )
                  : null,
              onTap: () async {
                if (!isSelected) {
                  await LanguageHelper.changeLanguage(context, language.code);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${LocaleKeys.profile_language.tr()}: ${language.nativeName}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}

