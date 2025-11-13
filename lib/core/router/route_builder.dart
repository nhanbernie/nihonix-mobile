import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/features/auth_pages.dart';
import 'package:nihonix/features/main_pages.dart';
import 'package:nihonix/features/onboarding/presentation/pages/language_selection_page.dart';
import 'package:nihonix/features/onboarding/presentation/pages/level_selection_page.dart';
import 'package:nihonix/features/flashcard/presentation/pages/folder_detail_page.dart';
import 'package:nihonix/features/flashcard/presentation/pages/folder_edit_page.dart';
import 'package:nihonix/features/flashcard/presentation/pages/card_study_page.dart';
import 'package:nihonix/features/flashcard/presentation/pages/card_form_page.dart';
import 'package:nihonix/features/flashcard/presentation/pages/generate_flashcard_page.dart';
import 'package:nihonix/features/lesson/presentation/pages/topic_detail_page.dart';
import 'package:nihonix/features/vocabulary/presentation/pages/vocab_list_page.dart';
import 'package:nihonix/features/vocabulary/presentation/pages/vocab_folder_detail_page.dart';
import 'package:nihonix/features/grammar/presentation/pages/grammar_list_page.dart';
import 'package:nihonix/features/grammar/presentation/pages/grammar_pattern_list_page.dart';
import 'package:nihonix/shared/layouts/main_layout.dart';
import 'route_constants.dart';

List<RouteBase> buildAppRoutes() {
  return [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: AppRoutes.welcome,
      name: AppRoutes.welcomeName,
      builder: (context, state) => const WelcomePage(),
    ),

    GoRoute(
      path: AppRoutes.languageSelection,
      name: AppRoutes.languageSelectionName,
      builder: (context, state) => const LanguageSelectionPage(),
    ),

    GoRoute(
      path: AppRoutes.levelSelection,
      name: AppRoutes.levelSelectionName,
      builder: (context, state) => const LevelSelectionPage(),
    ),

    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.registerName,
      builder: (context, state) => const RegisterPage(),
    ),

    // Main shell with bottom navigation
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.lesson,
          name: AppRoutes.lessonName,
          builder: (context, state) => const LessonPage(),
        ),
        GoRoute(
          path: AppRoutes.flashcard,
          name: AppRoutes.flashcardName,
          builder: (context, state) => const FlashcardPage(),
        ),
        GoRoute(
          path: AppRoutes.practice,
          name: AppRoutes.practiceName,
          builder: (context, state) => const PracticePage(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: AppRoutes.profileName,
          builder: (context, state) => const ProfilePage(),
          routes: [
            GoRoute(
              path: 'edit',
              name: AppRoutes.profileEditName,
              builder: (context, state) => const ProfileEditPage(),
            ),
          ],
        ),
      ],
    ),

    // Topic detail route (outside shell - no bottom nav)
    GoRoute(
      path: AppRoutes.topicDetail,
      name: AppRoutes.topicDetailName,
      builder: (context, state) {
        final topicName = state.uri.queryParameters['name'] ?? '';
        final iconCodePoint = int.tryParse(
              state.uri.queryParameters['icon'] ?? '',
            ) ??
            Icons.book_rounded.codePoint;
        return TopicDetailPage(
          topicName: topicName,
          topicIcon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
        );
      },
    ),

    // Vocabulary routes (outside shell - no bottom nav)
    GoRoute(
      path: AppRoutes.vocabList,
      name: AppRoutes.vocabListName,
      builder: (context, state) {
        final topicName = state.uri.queryParameters['topic'] ?? '';
        final iconCodePoint = int.tryParse(
              state.uri.queryParameters['icon'] ?? '',
            ) ??
            Icons.book_rounded.codePoint;
        return VocabListPage(
          topicName: topicName,
          topicIcon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.vocabFolderDetail,
      name: AppRoutes.vocabFolderDetailName,
      builder: (context, state) {
        final folderId = state.uri.queryParameters['folderId'] ?? '';
        final folderName = state.uri.queryParameters['folderName'] ?? '';
        return VocabFolderDetailPage(
          folderId: folderId,
          folderName: folderName,
        );
      },
    ),

    // Grammar routes (outside shell - no bottom nav)
    GoRoute(
      path: AppRoutes.grammarList,
      name: AppRoutes.grammarListName,
      builder: (context, state) {
        final topicName = state.uri.queryParameters['topic'] ?? '';
        final iconCodePoint = int.tryParse(
              state.uri.queryParameters['icon'] ?? '',
            ) ??
            Icons.book_rounded.codePoint;
        return GrammarListPage(
          topicName: topicName,
          topicIcon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.grammarPatternList,
      name: AppRoutes.grammarPatternListName,
      builder: (context, state) {
        final slug = state.uri.queryParameters['slug'] ?? '';
        final title = state.uri.queryParameters['title'] ?? '';
        return GrammarPatternListPage(
          slug: slug,
          title: title,
        );
      },
    ),

    // Flashcard routes (outside shell - no bottom nav)
    GoRoute(
      path: AppRoutes.folderDetail,
      name: AppRoutes.folderDetailName,
      builder: (context, state) {
        final folderId = state.uri.queryParameters['folderId'] ?? '';
        final folderName = state.uri.queryParameters['folderName'] ?? '';
        return FolderDetailPage(folderId: folderId, folderName: folderName);
      },
      routes: [
        GoRoute(
          path: ':folderId/edit',
          builder: (context, state) {
            final folderId = state.pathParameters['folderId'] ?? '';
            final folderName = state.uri.queryParameters['name'] ?? '';
            final folderDescription = state.uri.queryParameters['description'];
            return FolderEditPage(
              folderId: folderId,
              folderName: folderName,
              folderDescription: folderDescription,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.cardStudy,
      name: AppRoutes.cardStudyName,
      builder: (context, state) {
        final setId = state.uri.queryParameters['setId'] ?? '';
        final setName = state.uri.queryParameters['setName'] ?? '';
        return CardStudyPage(setId: setId, setName: setName);
      },
    ),
    GoRoute(
      path: AppRoutes.cardForm,
      name: AppRoutes.cardFormName,
      builder: (context, state) {
        final folderId = state.uri.queryParameters['folderId'] ?? '';
        final setId = state.uri.queryParameters['setId'];
        final setName = state.uri.queryParameters['setName'];
        return CardFormPage(
          folderId: folderId,
          setId: setId,
          setName: setName,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.generateFlashcard,
      name: AppRoutes.generateFlashcardName,
      builder: (context, state) {
        final folderId = state.uri.queryParameters['folderId'] ?? '';
        return GenerateFlashcardPage(folderId: folderId);
      },
    ),

    // Forgot password flow
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPasswordName,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.verifyCode,
      name: AppRoutes.verifyCodeName,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return VerifyCodePage(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      name: AppRoutes.resetPasswordName,
      builder: (context, state) => const ResetPasswordPage(),
    ),
  ];
}

/// Builds error page widget
Widget buildErrorPage(BuildContext context, GoRouterState state) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Lỗi'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Trang không tồn tại',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Đường dẫn: ${state.uri}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Về trang chủ'),
          ),
        ],
      ),
    ),
  );
}
