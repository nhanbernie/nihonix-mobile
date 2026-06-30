# 🌍 Hướng dẫn sử dụng đa ngôn ngữ (Localization)

## 📦 Thư viện sử dụng

- **easy_localization** - Thư viện đa ngôn ngữ đơn giản và mạnh mẽ

## 🗂️ Cấu trúc thư mục

```
assets/
└── translations/
    ├── en/              # Tiếng Anh
    │   ├── app.json
    │   ├── auth.json
    │   ├── common.json
    │   ├── errors.json
    │   ├── home.json
    │   ├── lessons.json
    │   ├── profile.json
    │   └── validation.json
    ├── vi/              # Tiếng Việt
    │   └── ... (same structure)
    └── ja/              # Tiếng Nhật
        └── ... (same structure)

lib/
└── core/
    └── l10n/
        ├── locale_keys.dart        # Các key dịch (type-safe)
        └── language_helper.dart    # Helper quản lý ngôn ngữ
```

> **📝 Note:** Dự án sử dụng **multi-files structure** - mỗi feature có file riêng để dễ quản lý và scale.

## 🚀 Cách sử dụng

### 1. Sử dụng cơ bản

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:nihonix/core/l10n/locale_keys.dart';

// Cách 1: Sử dụng extension .tr()
Text('common.ok'.tr())

// Cách 2: Sử dụng LocaleKeys (type-safe, recommended)
Text(LocaleKeys.common_ok.tr())

// Cách 3: Với tham số
Text('hello_name'.tr(namedArgs: {'name': 'John'}))
```

### 2. Thay đổi ngôn ngữ

```dart
import 'package:nihonix/core/l10n/language_helper.dart';

// Thay đổi sang tiếng Việt
await LanguageHelper.changeLanguage(context, 'vi');

// Thay đổi sang tiếng Anh
await LanguageHelper.changeLanguage(context, 'en');

// Thay đổi sang tiếng Nhật
await LanguageHelper.changeLanguage(context, 'ja');
```

### 3. Lấy ngôn ngữ hiện tại

```dart
// Lấy ngôn ngữ hiện tại
final currentLang = LanguageHelper.getCurrentLanguage(context);
print(currentLang.nativeName); // "Tiếng Việt"
print(currentLang.code);       // "vi"
print(currentLang.flag);       // "🇻🇳"
```

### 4. Sử dụng trong Widget

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tiêu đề
        Text(LocaleKeys.home_title.tr()),

        // Button
        ElevatedButton(
          onPressed: () {},
          child: Text(LocaleKeys.common_save.tr()),
        ),

        // Với tham số
        Text('welcome_user'.tr(namedArgs: {'user': 'John'})),
      ],
    );
  }
}
```

## 📝 Thêm bản dịch mới

### 1. Chọn file JSON phù hợp

Tùy vào feature, thêm vào file tương ứng. Ví dụ thêm greeting vào `common.json`:

**en/common.json:**

```json
{
  "ok": "OK",
  "cancel": "Cancel",
  "greeting": "Hello",
  "welcome_user": "Welcome, {user}!"
}
```

**vi/common.json:**

```json
{
  "ok": "Đồng ý",
  "cancel": "Hủy",
  "greeting": "Xin chào",
  "welcome_user": "Chào mừng, {user}!"
}
```

**ja/common.json:**

```json
{
  "ok": "OK",
  "cancel": "キャンセル",
  "greeting": "こんにちは",
  "welcome_user": "ようこそ、{user}！"
}
```

### 2. Thêm key vào LocaleKeys

```dart
// lib/core/l10n/locale_keys.dart
class LocaleKeys {
  static const greeting = 'greeting';
  static const welcome_user = 'welcome_user';
  static const items_count = 'items_count';
}
```

### 3. Sử dụng

```dart
// Đơn giản
Text(LocaleKeys.greeting.tr())

// Với tham số
Text(LocaleKeys.welcome_user.tr(namedArgs: {'user': 'John'}))

// Số nhiều (plural)
Text(LocaleKeys.items_count.plural(5))
```

## 🎯 Các tính năng nâng cao

### 1. Số nhiều (Pluralization)

```dart
// JSON
{
  "items": {
    "zero": "No items",
    "one": "1 item",
    "other": "{count} items"
  }
}

// Dart
Text('items'.plural(0))  // "No items"
Text('items'.plural(1))  // "1 item"
Text('items'.plural(5))  // "5 items"
```

### 2. Giới tính (Gender)

```dart
// JSON
{
  "welcome": {
    "male": "Welcome Mr. {name}",
    "female": "Welcome Ms. {name}",
    "other": "Welcome {name}"
  }
}

// Dart
Text('welcome'.tr(gender: 'male', namedArgs: {'name': 'John'}))
```

### 3. Định dạng ngày tháng

```dart
final date = DateTime.now();
Text(DateFormat.yMMMd(context.locale.toString()).format(date))
```

### 4. Định dạng số

```dart
final number = 1234567.89;
Text(NumberFormat.currency(
  locale: context.locale.toString(),
  symbol: '₫',
).format(number))
```

## 🌐 Ngôn ngữ được hỗ trợ

| Mã  | Ngôn ngữ   | Tên gốc    | Flag |
| --- | ---------- | ---------- | ---- |
| en  | English    | English    | 🇬🇧   |
| vi  | Vietnamese | Tiếng Việt | 🇻🇳   |
| ja  | Japanese   | 日本語     | 🇯🇵   |

## 🔧 Thêm ngôn ngữ mới

### 1. Tạo file JSON mới

```bash
# Tạo file cho tiếng Hàn
touch assets/translations/ko.json
```

### 2. Thêm vào main.dart

```dart
EasyLocalization(
  supportedLocales: const [
    Locale('en'),
    Locale('vi'),
    Locale('ja'),
    Locale('ko'), // Thêm tiếng Hàn
  ],
  // ...
)
```

### 3. Thêm vào LanguageHelper

```dart
static const List<LanguageModel> supportedLanguages = [
  // ...
  LanguageModel(
    code: 'ko',
    name: 'Korean',
    nativeName: '한국어',
    flag: '🇰🇷',
  ),
];
```

## 📱 Demo Page

Đã tạo sẵn trang cài đặt ngôn ngữ:

```dart
// lib/features/settings/presentation/pages/language_settings_page.dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const LanguageSettingsPage(),
  ),
);
```

## 🎨 Best Practices

1. **Luôn dùng LocaleKeys** thay vì string trực tiếp
2. **Tổ chức JSON theo module** (auth, home, profile, etc.)
3. **Đặt tên key rõ ràng** và có ý nghĩa
4. **Kiểm tra đầy đủ** tất cả ngôn ngữ trước khi release
5. **Sử dụng plural/gender** khi cần thiết
6. **Tránh hardcode text** trong code

## 🐛 Troubleshooting

### Lỗi: Translation not found

```dart
// Đảm bảo key tồn tại trong tất cả file JSON
// Hoặc dùng fallback:
Text('key'.tr(fallback: 'Default text'))
```

### Lỗi: Assets not found

```dart
// Kiểm tra pubspec.yaml
flutter:
  assets:
    - assets/translations/en/
    - assets/translations/vi/
    - assets/translations/ja/

// Chạy lại
flutter pub get
```

### Ngôn ngữ không thay đổi

```dart
// Đảm bảo wrap MaterialApp với localizationsDelegates
MaterialApp(
  localizationsDelegates: context.localizationDelegates,
  supportedLocales: context.supportedLocales,
  locale: context.locale,
)
```

## 📚 Tài liệu tham khảo

- [easy_localization Documentation](https://pub.dev/packages/easy_localization)
- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
