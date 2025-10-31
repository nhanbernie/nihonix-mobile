ThemeData(
  useMaterial3: true,          // Dòng 171
  colorScheme: darkColorScheme, // Dòng 172
)
  ↓
Material 3 tự động:
  - Scaffold background = colorScheme.surface
  - AppBar background = appBarTheme.backgroundColor (nếu có)
  - Card background = cardTheme.color (nếu có)


Tự động