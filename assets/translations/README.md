# 🌍 Multi-Files Localization Structure

Dự án sử dụng **Multi-Files Approach** cho localization - chuẩn best practice 2025!

## 📁 Cấu trúc thư mục

```
assets/translations/
├── en/                    # English translations
│   ├── app.json          # App metadata
│   ├── auth.json         # Authentication
│   ├── common.json       # Common/shared words
│   ├── errors.json       # Error messages
│   ├── home.json         # Home feature
│   ├── lessons.json      # Lessons feature
│   ├── profile.json      # Profile feature
│   └── validation.json   # Form validation
│
├── vi/                    # Tiếng Việt
│   └── ... (same structure)
│
└── ja/                    # 日本語 (Japanese)
    └── ... (same structure)
```

## 🎯 Cách sử dụng

### Option 1: Direct String (Đơn giản)

```dart
import 'package:easy_localization/easy_localization.dart';

Text('auth.login'.tr())
Text('common.ok'.tr())
Text('home.welcome'.tr())
```

### Option 2: LocaleKeys (Type-safe)

```dart
import 'package:nihonix/core/l10n/locale_keys.dart';

Text(LocaleKeys.auth_login.tr())
Text(LocaleKeys.common_ok.tr())
Text(LocaleKeys.home_welcome.tr())
```

## 📝 Thêm translation mới

### 1. Thêm vào file JSON tương ứng

```json
// assets/translations/en/auth.json
{
  "login": "Login",
  "logout": "Logout",
  "new_key": "New Translation" // ← Thêm ở đây
}
```

### 2. Thêm vào CÙNG KEY ở các ngôn ngữ khác

```json
// assets/translations/vi/auth.json
{
  "login": "Đăng nhập",
  "logout": "Đăng xuất",
  "new_key": "Bản dịch mới"  // ← Cùng key
}

// assets/translations/ja/auth.json
{
  "login": "ログイン",
  "logout": "ログアウト",
  "new_key": "新しい翻訳"  // ← Cùng key
}
```

### 3. (Optional) Thêm vào LocaleKeys

```dart
// lib/core/l10n/locale_keys.dart
class LocaleKeys {
  static const auth_new_key = 'auth.new_key';
}
```

### 4. Sử dụng

```dart
// Direct
Text('auth.new_key'.tr())

// Hoặc LocaleKeys
Text(LocaleKeys.auth_new_key.tr())
```

## 🔧 Thêm feature mới

Khi tạo feature mới (ví dụ: `chat`):

```bash
# Tạo 3 files:
assets/translations/en/chat.json
assets/translations/vi/chat.json
assets/translations/ja/chat.json
```

## ✅ Ưu điểm

1. **Scalable** - File nhỏ (~10-15 dòng/file)
2. **No conflicts** - Ít git conflicts khi nhiều dev
3. **Easy to find** - Dễ tìm theo feature
4. **Organized** - Tổ chức rõ ràng
5. **Best practice** - Chuẩn 2025

## 📚 Chi tiết

Xem thêm: `README_LOCALIZATION.md` ở root project
