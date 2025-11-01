# Neumorphism Design Guide

## 📖 Giới thiệu

Neumorphism (hay Soft UI) là một phong cách thiết kế UI hiện đại, tạo cảm giác các phần tử "nổi" hoặc "chìm" trên bề mặt thông qua việc sử dụng shadow và highlight tinh tế.

## 🎨 Nguyên tắc cơ bản

### 1. **Màu nền (Background)**
- Sử dụng màu trung tính, không quá sáng hoặc tối
- Light mode: `#E0E0E0` (xám nhạt)
- Dark mode: `#2A2A2A` (xám đậm)

### 2. **Shadow kép (Dual Shadow)**
Neumorphism sử dụng **2 shadow** để tạo hiệu ứng 3D:

#### **Dark Shadow** (Bóng tối)
- Vị trí: Góc dưới-phải `offset: (4, 4)`
- Màu: Tối hơn background
  - Light: `#BCBCBC`
  - Dark: `#1A1A1A`
- Blur: `10px`

#### **Light Shadow** (Highlight)
- Vị trí: Góc trên-trái `offset: (-4, -4)`
- Màu: Sáng hơn background
  - Light: `#FFFFFF`
  - Dark: `#3A3A3A`
- Blur: `10px`

### 3. **Border**
- Độ dày: `2px`
- Màu:
  - Light: `#CECECE`
  - Dark: `#353535`

### 4. **Border Radius**
- Sử dụng border radius lớn: `30px - 50px`
- Tạo cảm giác mềm mại, bo tròn

## 💻 Implementation trong Flutter

### Cấu trúc cơ bản

```dart
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: neuBgColor,
    borderRadius: BorderRadius.circular(30),
    border: Border.all(
      color: neuBorderColor,
      width: 2,
    ),
    boxShadow: [
      // Dark shadow (bottom-right)
      BoxShadow(
        color: neuDarkShadow,
        blurRadius: 10,
        offset: const Offset(4, 4),
        spreadRadius: 0,
      ),
      // Light shadow (top-left)
      BoxShadow(
        color: neuLightShadow,
        blurRadius: 10,
        offset: const Offset(-4, -4),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Icon(Icons.home, size: 24),
)
```

### Khai báo màu sắc

```dart
// Light mode colors
const neuBgColorLight = Color(0xFFE0E0E0);
const neuLightShadowLight = Color(0xFFFFFFFF);
const neuDarkShadowLight = Color(0xFFBCBCBC);
const neuBorderColorLight = Color(0xFFCECECE);
const neuIconColorLight = Color(0xFF4D4D4D);

// Dark mode colors
const neuBgColorDark = Color(0xFF2A2A2A);
const neuLightShadowDark = Color(0xFF3A3A3A);
const neuDarkShadowDark = Color(0xFF1A1A1A);
const neuBorderColorDark = Color(0xFF353535);
const neuIconColorDark = Color(0xFF9E9E9E);

// Responsive colors
final isDark = Theme.of(context).brightness == Brightness.dark;
final neuBgColor = isDark ? neuBgColorDark : neuBgColorLight;
final neuLightShadow = isDark ? neuLightShadowDark : neuLightShadowLight;
final neuDarkShadow = isDark ? neuDarkShadowDark : neuDarkShadowLight;
final neuBorderColor = isDark ? neuBorderColorDark : neuBorderColorLight;
final neuIconColor = isDark ? neuIconColorDark : neuIconColorLight;
```

## 🔥 Kết hợp với Backdrop Blur

Để tạo hiệu ứng glassmorphism + neumorphism:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(30),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: neuBgColor.withValues(alpha: 0.3), // Trong suốt
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: neuBorderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: neuDarkShadow,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: neuLightShadow,
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Icon(Icons.home, color: neuIconColor, size: 24),
    ),
  ),
)
```

**Lưu ý:**
- Background color phải có `alpha: 0.3` để blur hoạt động
- Phải wrap trong `ClipRRect` để blur không bị tràn ra ngoài

## ✨ Best Practices

### 1. **Contrast**
- Đảm bảo icon/text có đủ contrast với background
- Light mode: Icon màu `#4D4D4D`
- Dark mode: Icon màu `#9E9E9E`

### 2. **Spacing**
- Padding bên trong: `12px - 16px`
- Khoảng cách giữa các elements: `8px - 16px`

### 3. **Animation**
- Duration: `300ms - 350ms`
- Curve: `Curves.easeInOutCubic` (mượt mà)
- Tránh animate shadow (tốn performance)

### 4. **Accessibility**
- Neumorphism có contrast thấp → không dùng cho text quan trọng
- Chỉ dùng cho decorative elements (buttons, cards)
- Luôn có fallback cho người khiếm thị

## 🚫 Những điều cần tránh

1. **Không dùng trên background có pattern/gradient**
   - Neumorphism cần background đơn sắc để hoạt động tốt

2. **Không stack nhiều layers**
   - Tối đa 2-3 layers để tránh rối mắt

3. **Không dùng cho toàn bộ UI**
   - Chỉ dùng cho một số elements nổi bật
   - Kết hợp với flat design để cân bằng

4. **Không dùng màu quá sáng/tối**
   - Background quá trắng: Shadow không rõ
   - Background quá đen: Highlight không rõ

## 📱 Ví dụ thực tế

### Bottom Navigation Bar (Nihonix App)

```dart
// Unactive button với neumorphism + blur
ClipRRect(
  borderRadius: BorderRadius.circular(30),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
    child: Container(
      decoration: BoxDecoration(
        color: neuBgColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: neuBorderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: neuDarkShadow,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: neuLightShadow,
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(Icons.home_rounded, color: neuIconColor, size: 24),
      ),
    ),
  ),
)
```

## 🔗 Tài liệu tham khảo

- [Neumorphism.io](https://neumorphism.io/) - Generator tool
- [CSS Neumorphism](https://css.glass/neumorphism) - CSS examples
- [Material Design 3](https://m3.material.io/) - Modern design principles

## 📝 Changelog

- **2025-11-01**: Tạo document ban đầu với implementation cho Bottom Nav Bar

