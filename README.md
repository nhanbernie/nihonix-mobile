# Flutter App 2025 - Modern Architecture

Đây là project Flutter demo với cấu trúc hiện đại năm 2025, áp dụng Clean Architecture và best practices.

## 🏗️ Cấu trúc Project

```
lib/
├── core/                     # Core functionality
│   ├── constants/           # App constants
│   │   ├── app_colors.dart  # Màu sắc app
│   │   ├── app_strings.dart # Chuỗi text app
│   │   └── app_sizes.dart   # Kích thước app
│   ├── router/             # Navigation
│   │   └── app_router.dart # GoRouter configuration
│   └── theme/              # App theme
│       └── app_theme.dart  # Material 3 theme
├── features/               # Feature-based modules
│   ├── auth/              # Authentication
│   │   └── presentation/
│   │       └── pages/
│   │           └── login_page.dart
│   ├── home/              # Home feature
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_page.dart
│   └── profile/           # Profile feature
│       └── presentation/
│           └── pages/
│               └── profile_page.dart
├── shared/                # Shared components
│   └── widgets/          # Reusable widgets
│       ├── custom_button.dart
│       ├── loading_widget.dart
│       └── error_widget.dart
└── main.dart             # Entry point
```

## 🚀 Technologies Used

- **Flutter 3.5.2+** - Latest stable version
- **Dart 3.2.0+** - Modern Dart features
- **flutter_riverpod** - State management
- **go_router** - Declarative routing
- **dio** - HTTP client (for future API calls)
- **hive** - Local storage (for future offline support)

## 📱 Features Implemented

### 1. **Modern UI/UX**

- Material 3 design system
- Dark/Light theme support
- Responsive design patterns
- Custom reusable widgets

### 2. **Navigation**

- GoRouter for type-safe navigation
- Named routes with parameters
- Error handling for unknown routes

### 3. **Architecture**

- Clean Architecture principles
- Feature-based folder structure
- Separation of concerns
- Scalable codebase

### 4. **Reusable Components**

- Custom buttons with loading states
- Loading widgets with shimmer effects
- Error widgets for different scenarios
- Consistent sizing and spacing

## 🏃‍♂️ Getting Started

### 1. Cài đặt dependencies

```bash
flutter pub get
```

### 2. Chạy app

```bash
flutter run
```

### 3. Build cho production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📖 Code Examples

### 1. Sử dụng Custom Button

```dart
CustomButton(
  onPressed: () => print('Button pressed'),
  isLoading: false,
  child: Text('Đăng nhập'),
)
```

### 2. Navigation với GoRouter

```dart
// Đi tới page khác
context.push('/profile');

// Đi tới page với parameters
context.push('/profile?userId=123');

// Quay lại
context.pop();
```

### 3. Sử dụng Theme Colors

```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Hello World',
    style: TextStyle(color: AppColors.white),
  ),
)
```

## 🎯 Best Practices Implemented

### 1. **Code Organization**

- Feature-based architecture
- Consistent naming conventions
- Proper file structure

### 2. **Performance**

- Lazy loading of widgets
- Efficient state management
- Optimized navigation

### 3. **Maintainability**

- Centralized constants
- Reusable components
- Clean separation of concerns

### 4. **User Experience**

- Loading states
- Error handling
- Responsive design

## 🔧 Configuration Files

### pubspec.yaml

- Updated dependencies
- Modern package versions
- Development tools

### analysis_options.yaml

- Flutter lints enabled
- Code quality rules

## 📚 Learning Path

### 1. **Beginners**

- Hiểu cấu trúc folder
- Tìm hiểu Material 3
- Học navigation cơ bản

### 2. **Intermediate**

- State management với Riverpod
- Custom widgets
- API integration

### 3. **Advanced**

- Clean Architecture patterns
- Testing strategies
- Performance optimization

## 🤝 Contributing

1. Fork the project
2. Create feature branch
3. Commit changes
4. Push to branch
5. Open pull request

## 📝 License

This project is licensed under the MIT License.

---

**Happy Coding! 🚀**
