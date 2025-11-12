/// Route paths constants for the entire app
class AppRoutes {
  // Public paths
  static const String splash = '/';
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String languageSelection = '/language-selection';
  static const String levelSelection = '/level-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String lesson = '/lesson';
  static const String topicDetail = '/lesson/topic';
  static const String flashcard = '/flashcard';
  static const String folderDetail = '/flashcard/folder';
  static const String cardStudy = '/flashcard/study';
  static const String cardForm = '/flashcard/card-form';
  static const String practice = '/practice';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyCode = '/verifyCode';
  static const String resetPassword = '/resetPassword';

  // Route names
  static const String splashName = 'splash';
  static const String homeName = 'home';
  static const String welcomeName = 'welcome';
  static const String languageSelectionName = 'languageSelection';
  static const String levelSelectionName = 'levelSelection';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String profileName = 'profile';
  static const String profileEditName = 'profileEdit';
  static const String lessonName = 'lesson';
  static const String topicDetailName = 'topicDetail';
  static const String flashcardName = 'flashcard';
  static const String folderDetailName = 'folderDetail';
  static const String cardStudyName = 'cardStudy';
  static const String cardFormName = 'cardForm';
  static const String practiceName = 'practice';
  static const String forgotPasswordName = 'forgotPassword';
  static const String verifyCodeName = 'verifyCode';
  static const String resetPasswordName = 'resetPassword';

  // Route groups
  static final List<String> protectedRoutes = [home, lesson, flashcard, practice, profile];
  static final List<String> authRoutes = [login, register];
  static final List<String> onboardingRoutes = [languageSelection, levelSelection];
  static final List<String> forgotPasswordRoutes = [
    forgotPassword,
    verifyCode,
    resetPassword,
  ];
}
