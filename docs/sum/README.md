# 📚 Documentation Index

Chào mừng đến với documentation của Nihonix Mobile App!

## 🎯 Quick Start

Nếu bạn mới bắt đầu, đọc theo thứ tự:

1. **OOP_CHEAT_SHEET.md** - Hiểu interface vs implementation (5 phút)
2. **FLOW_DIAGRAM.md** - Flow TokenStore hoạt động (10 phút)
3. **TOKEN_STORE_EXPLAINED.md** - Chi tiết với examples (15 phút)
4. **HTTP_EXCEPTIONS_REFACTORING.md** - Cách tách file clean code (20 phút)
5. **IMPORT_GUIDE.md** - Cách import đúng chuẩn (10 phút)

---

## 📖 Documentation Files

### 🔰 Beginner Level

| File                       | Nội Dung                                   | Thời Gian |
| -------------------------- | ------------------------------------------ | --------- |
| **OOP_CHEAT_SHEET.md**     | Interface vs Implementation, so sánh nhanh | 5 phút    |
| **QUICK_REFERENCE.md**     | Quick reference cho HTTP Exceptions        | 3 phút    |
| **REFACTORING_SUMMARY.md** | Tóm tắt refactoring HTTP Exceptions        | 3 phút    |

### 📚 Intermediate Level

| File                         | Nội Dung                                 | Thời Gian |
| ---------------------------- | ---------------------------------------- | --------- |
| **FLOW_DIAGRAM.md**          | Flow đầy đủ: TokenStore → Implementation | 10 phút   |
| **TOKEN_STORE_EXPLAINED.md** | 3 implementations, benefits, examples    | 15 phút   |
| **IMPORT_GUIDE.md**          | 3 cách import, best practices            | 10 phút   |

### 🎓 Advanced Level

| File                               | Nội Dung                                             | Thời Gian |
| ---------------------------------- | ---------------------------------------------------- | --------- |
| **HTTP_EXCEPTIONS_REFACTORING.md** | Syntax chi tiết: abstract, extends, super parameters | 20 phút   |
| **AUTH_INTERCEPTOR_README.md**     | AuthInterceptor deep dive                            | 15 phút   |
| **QUICK_START.md**                 | Setup AuthInterceptor từ đầu                         | 10 phút   |

---

## 🎯 Documentation Theo Chủ Đề

### 🔐 Authentication & Token Management

- **TOKEN_STORE_EXPLAINED.md** - Interface TokenStore, multiple implementations
- **FLOW_DIAGRAM.md** - Flow: Interface → Implementation → Hive
- **AUTH_INTERCEPTOR_README.md** - AuthInterceptor usage guide
- **QUICK_START.md** - Setup auth system

### 🌐 HTTP & Network

- **HTTP_EXCEPTIONS_REFACTORING.md** - Tách exceptions ra file riêng
- **QUICK_REFERENCE.md** - Quick ref cho 8 exception classes
- **IMPORT_GUIDE.md** - Cách import exceptions

### 🏗️ Architecture & Clean Code

- **OOP_CHEAT_SHEET.md** - OOP fundamentals
- **HTTP_EXCEPTIONS_REFACTORING.md** - Clean code principles
- **REFACTORING_SUMMARY.md** - Refactoring summary

### 📦 Code Generation

- **IMPLEMENTATION_SUMMARY.md** - Riverpod + Freezed code generation
- **IMPLEMENTATION_COMPLETE.md** - Setup complete guide

---

## 🗂️ File Structure

```
docs/
├── 🔰 BEGINNER LEVEL
│   ├── OOP_CHEAT_SHEET.md              ← Bắt đầu ở đây!
│   ├── QUICK_REFERENCE.md
│   └── REFACTORING_SUMMARY.md
│
├── 📚 INTERMEDIATE LEVEL
│   ├── FLOW_DIAGRAM.md                 ← Hiểu flow hoàn chỉnh
│   ├── TOKEN_STORE_EXPLAINED.md
│   └── IMPORT_GUIDE.md
│
├── 🎓 ADVANCED LEVEL
│   ├── HTTP_EXCEPTIONS_REFACTORING.md
│   ├── AUTH_INTERCEPTOR_README.md
│   └── QUICK_START.md
│
└── 📋 OTHER
    ├── CMD.md
    ├── IMPLEMENTATION_SUMMARY.md
    ├── IMPLEMENTATION_COMPLETE.md
    └── USAGE_GUIDE.md
```

---

## 🎓 Learning Paths

### Path 1: Hiểu OOP & Clean Code

```
1. OOP_CHEAT_SHEET.md
   ↓ (Hiểu interface vs implementation)
2. FLOW_DIAGRAM.md
   ↓ (Xem flow thực tế)
3. TOKEN_STORE_EXPLAINED.md
   ↓ (Chi tiết với examples)
4. HTTP_EXCEPTIONS_REFACTORING.md
   ↓ (Clean code principles)
```

**Thời gian**: ~1 giờ  
**Kết quả**: Hiểu sâu OOP, interface, dependency injection

---

### Path 2: Sử Dụng HTTP Exceptions

```
1. QUICK_REFERENCE.md
   ↓ (Quick ref 8 exception classes)
2. IMPORT_GUIDE.md
   ↓ (Cách import đúng)
3. HTTP_EXCEPTIONS_REFACTORING.md
   ↓ (Syntax chi tiết)
4. REFACTORING_SUMMARY.md
   ↓ (Summary & examples)
```

**Thời gian**: ~45 phút  
**Kết quả**: Biết cách sử dụng exceptions trong code

---

### Path 3: Setup Auth System

```
1. QUICK_START.md
   ↓ (Setup AuthInterceptor)
2. AUTH_INTERCEPTOR_README.md
   ↓ (Chi tiết features)
3. TOKEN_STORE_EXPLAINED.md
   ↓ (Implementations)
4. FLOW_DIAGRAM.md
   ↓ (Flow hoạt động)
```

**Thời gian**: ~50 phút  
**Kết quả**: Setup được auth system hoàn chỉnh

---

## 🔍 Search by Topic

### Tìm hiểu về Interface

📖 Đọc:

- OOP_CHEAT_SHEET.md (Section: Interface vs Implementation)
- FLOW_DIAGRAM.md (Section: Khái Niệm OOP)
- TOKEN_STORE_EXPLAINED.md (Full file)

### Tìm hiểu về Dependency Injection

📖 Đọc:

- TOKEN_STORE_EXPLAINED.md (Section: Dependency Injection)
- FLOW_DIAGRAM.md (Section: BƯỚC 1-2)
- HTTP_EXCEPTIONS_REFACTORING.md (Section: Best Practices)

### Tìm hiểu về Clean Code

📖 Đọc:

- HTTP_EXCEPTIONS_REFACTORING.md (Section: Tại Sao Tách File)
- TOKEN_STORE_EXPLAINED.md (Section: Clean Code Benefits)
- OOP_CHEAT_SHEET.md (Section: Nguyên Tắc Clean Code)

### Tìm hiểu về Code Generation

📖 Đọc:

- IMPLEMENTATION_SUMMARY.md
- IMPLEMENTATION_COMPLETE.md
- Riverpod documentation (external)

---

## 💡 Quick Answers

### Q: Khi gọi `_tokenStore.readAccessToken()`, code nào chạy?

**A**: Code trong `HiveTokenStore.readAccessToken()` - lấy từ Hive database.

📖 Chi tiết: FLOW_DIAGRAM.md

---

### Q: Tại sao dùng interface thay vì class trực tiếp?

**A**:

- Linh hoạt đổi implementation (Hive → SecureStorage)
- Dễ test (inject Mock)
- Clean code (Dependency Inversion Principle)

📖 Chi tiết: TOKEN_STORE_EXPLAINED.md

---

### Q: Làm sao import exceptions sau khi tách file?

**A**:

```dart
// Recommended:
import 'package:nihonix/core/network/network.dart';

// Hoặc:
import 'package:nihonix/core/network/http_exceptions.dart';
```

📖 Chi tiết: IMPORT_GUIDE.md

---

### Q: Abstract class khác class thường như thế nào?

**A**:

- Abstract class: Chỉ khai báo, không có code thực
- Class thường: Có code thực, có thể tạo instance

📖 Chi tiết: OOP_CHEAT_SHEET.md

---

## 🛠️ Tools & Commands

### Analyze Code

```bash
flutter analyze
```

### Format Code

```bash
dart format .
```

### Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Clean Build

```bash
flutter clean
flutter pub get
```

---

## 📞 Need Help?

### Câu hỏi về OOP?

📖 Đọc: OOP_CHEAT_SHEET.md, FLOW_DIAGRAM.md

### Câu hỏi về Exceptions?

📖 Đọc: QUICK_REFERENCE.md, HTTP_EXCEPTIONS_REFACTORING.md

### Câu hỏi về AuthInterceptor?

📖 Đọc: AUTH_INTERCEPTOR_README.md, QUICK_START.md

### Câu hỏi về Clean Code?

📖 Đọc: HTTP_EXCEPTIONS_REFACTORING.md, TOKEN_STORE_EXPLAINED.md

---

## 🎯 Next Steps

Sau khi đọc xong documentation:

1. ✅ Hiểu OOP fundamentals
2. ✅ Hiểu interface vs implementation
3. ✅ Biết cách sử dụng HTTP exceptions
4. ✅ Biết cách setup auth system
5. ✅ Hiểu clean code principles

**Bây giờ**: Bắt đầu code! 💪

---

**Last Updated**: October 6, 2025  
**Total Files**: 13 documentation files  
**Total Content**: ~3000+ lines
