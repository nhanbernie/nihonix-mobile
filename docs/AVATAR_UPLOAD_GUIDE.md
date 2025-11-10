# Avatar Upload Feature - Hướng dẫn sử dụng

## 📦 Packages đã thêm

```yaml
dependencies:
  image_picker: ^1.1.2  # Pick ảnh từ camera/gallery
  # image_cropper đã BỎ do bug "Reply already submitted" trên Android
```

**Note:** Đã bỏ `image_cropper` vì gặp crash bug khi chọn ảnh. Thay vào đó dùng `image_picker` với `maxWidth/maxHeight` để resize tự động.

## 🔧 Cấu hình Platform

### Android
Đã thêm permissions vào `android/app/src/main/AndroidManifest.xml`:
- `CAMERA` - Truy cập camera
- `READ_EXTERNAL_STORAGE` - Đọc ảnh từ gallery
- `WRITE_EXTERNAL_STORAGE` - Lưu ảnh (Android ≤12)
- `READ_MEDIA_IMAGES` - Đọc ảnh (Android 13+)

### iOS
Đã thêm usage descriptions vào `ios/Runner/Info.plist`:
- `NSCameraUsageDescription` - Lý do cần camera
- `NSPhotoLibraryUsageDescription` - Lý do cần thư viện ảnh

## 🎨 Sử dụng Widget

### 1. Import widget

```dart
import 'package:nihonix/features/profile/presentation/widgets/avatar_picker_button.dart';
```

### 2. Thêm vào UI

```dart
class ProfileEditPage extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);
    final user = authState.user;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Avatar picker button
            AvatarPickerButton(
              currentAvatarUrl: user?.avatar,
              size: 120.0,
              onImageSelected: (imageFile) async {
                // Upload avatar khi user chọn ảnh
                await ref.read(profileProvider.notifier).uploadAvatar(
                  imageFile: imageFile,
                );

                // Hiện thông báo
                if (profileState.isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cập nhật avatar thành công!')),
                  );
                } else if (profileState.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi: ${profileState.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),

            // Loading indicator
            if (profileState.isLoading)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

## 🔄 Flow hoạt động

1. **User nhấn vào avatar** → Bottom sheet hiện ra với 2 options:
   - 📷 Chụp ảnh (Camera)
   - 🖼️ Chọn từ thư viện (Gallery)

2. **User chọn source** → ImagePicker pick ảnh với auto resize:
   - `maxWidth: 512`
   - `maxHeight: 512`
   - `imageQuality: 85`

3. **Upload lên server** → API `POST /api/users/me/avatar`:
   - Format: `multipart/form-data`
   - Field name: `avatar`

4. **Cập nhật state** → AuthProvider update user với avatar URL mới

**Lưu ý:** Đã bỏ bước crop vì image_cropper gây crash. Ảnh tự động resize về 512x512.

## 🎯 API Endpoint

**POST** `/api/users/me/avatar`

**Headers:**
```
Authorization: Bearer {accessToken}
Content-Type: multipart/form-data
```

**Body:**
```
avatar: [File Binary]
```

**Response:**
```json
{
  "success": true,
  "message": "Upload avatar thành công",
  "data": {
    "avatar_url": "https://cloudinary.com/.../avatar.jpg"
  }
}
```

## 🛠️ Customization

### Thay đổi kích thước avatar
```dart
AvatarPickerButton(
  size: 150.0, // Mặc định: 120.0
  ...
)
```

### Thay đổi chất lượng ảnh
Sửa trong file `avatar_picker_button.dart`:

```dart
// Line ~188: Pick image quality
maxWidth: 512,     // Giảm để file nhỏ hơn
maxHeight: 512,
imageQuality: 90,  // Tăng để chất lượng tốt hơn
```

## 🐛 Troubleshooting

### Lỗi: "No implementation found for method pickImage"
→ Chạy: `flutter clean && flutter pub get`

### Lỗi: "Camera/Gallery permission denied"
→ Check AndroidManifest.xml và Info.plist đã có permissions

### Lỗi: "Reply already submitted" (FIXED)
→ Đã fix bằng cách BỎ image_cropper package

### Upload thất bại với 401
→ Check accessToken còn hợp lệ, AuthInterceptor đã hoạt động

## 📝 Notes

- Avatar được resize tự động về 512x512 để tối ưu dung lượng
- Không có crop UI, ảnh sẽ resize theo tỷ lệ gốc
- Nếu cần ảnh vuông, user nên chọn/chụp ảnh vuông từ đầu
- Loading state tự động được handle trong ProfileNotifier
- Error messages được log ra console để debug

## ✅ Đã implement

- ✅ Pick ảnh từ camera/gallery
- ✅ Auto resize ảnh về 512x512
- ✅ Upload lên server với multipart/form-data
- ✅ Cập nhật avatar trong auth state
- ✅ Loading & error handling
- ✅ UI responsive với bottom sheet
- ✅ Android & iOS permissions
- ✅ Fix crash bug "Reply already submitted"
