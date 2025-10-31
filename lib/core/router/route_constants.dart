/// Route paths constants for the entire app
class AppRoutes {
  // Public paths
  static const String splash = '/';
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String lesson = '/lesson';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyCode = '/verifyCode';
  static const String resetPassword = '/resetPassword';

  // Route names
  static const String splashName = 'splash';
  static const String homeName = 'home';
  static const String welcomeName = 'welcome';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String profileName = 'profile';
  static const String profileEditName = 'profileEdit';
  static const String lessonName = 'lesson';
  static const String forgotPasswordName = 'forgotPassword';
  static const String verifyCodeName = 'verifyCode';
  static const String resetPasswordName = 'resetPassword';

  // Route groups
  static final List<String> protectedRoutes = [home, lesson, profile];
  static final List<String> authRoutes = [login, register];
  static final List<String> forgotPasswordRoutes = [
    forgotPassword,
    verifyCode,
    resetPassword,
  ];
}
