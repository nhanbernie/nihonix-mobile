# Flutter Command Reference

## Analyze & Test
- `flutter analyze` → tương tự `npm run build` để bắt lỗi chung
- `flutter analyze --no-fatal-infos` → bỏ qua warning thông tin
- `flutter analyze lib/core/network/ --no-fatal-infos` → giới hạn thư mục network
- `flutter analyze lib/shared/layouts/auth_layout.dart` → kiểm tra file cụ thể
- `flutter test`

## Dependency & Cleanup
- `flutter clean`
- `flutter get`
- `cd android; .\gradlew --stop; cd -`

## Build & Release
- `flutter build apk`
- `flutter build apk --debug`
- `flutter build apk --release --split-per-abi`

## Code Generation
- `dart run build_runner build --delete-conflicting-outputs`
- `flutter pub run build_runner build --delete-conflicting-outputs`
- Ghi chú: cần chạy trước khi dùng thư viện `freezed`.

## Runtime Env Overrides
```sh
flutter run \
  --dart-define=API_URL=https://api.dev.com \
  --dart-define=SENTRY_DSN=abcd1234
```

## IDE Noise Reduction
Thêm vào `settings.json` để ẩn file sinh tự động:
```jsonc
"files.exclude": {
  "**/*.g.dart": true,
  "**/*.freezed.dart": true
},
"search.exclude": {
  "**/*.g.dart": true,
  "**/*.freezed.dart": true
}
```

## Assets & Icons
- `dart run flutter_launcher_icons:main`
- `flutter pub run flutter_launcher_icons` → reload icon cho toàn app
- `flutter pub run flutter_native_splash:create` → cấu hình splash

## Logging & Engine Check
- `flutter run -d emulator-5554 --verbose *>&1 | Tee-Object -FilePath .\run.log`
  - Dùng để log chi tiết và kiểm tra engine (hiện emulator thay vì Skia ~2024)

## Run with env 
API_BASE_URL=https://nihonix-server.onrender.com/api \
API_TIMEOUT=60000 \
APP_ENV=development \
ENABLE_DEBUG=true 

`prod`
flutter run --dart-define=API_BASE_URL=https://nihonix-server.onrender.com/api --dart-define=API_TIMEOUT=60000 --dart-define=APP_ENV=development --dart-define=ENABLE_DEBUG=true

`dev`
flutter run --dart-define=API_BASE_URL=https://nonornamentally-oppressible-kindra.ngrok-free.dev/api --dart-define=API_TIMEOUT=60000 --dart-define=APP_ENV=development --dart-define=ENABLE_DEBUG=true

`apk (prod)`
flutter build apk --release `
  --no-tree-shake-icons `
  --dart-define=API_BASE_URL=https://nihonix-server.onrender.com/api `
  --dart-define=API_TIMEOUT=60000 `
  --dart-define=APP_ENV=development `
  --dart-define=ENABLE_DEBUG=true

`apk (dev)`
flutter build apk --release `
  --no-tree-shake-icons `
  --dart-define=API_BASE_URL=https://nonornamentally-oppressible-kindra.ngrok-free.dev/api `
  --dart-define=API_TIMEOUT=60000 `
  --dart-define=APP_ENV=development `
  --dart-define=ENABLE_DEBUG=true

flutter build apk --release `
  --no-tree-shake-icons `
  --dart-define=API_BASE_URL=https://nihonix-server.onrender.com/api `
  --dart-define=API_TIMEOUT=60000 `
  --dart-define=APP_ENV=development `
  --dart-define=ENABLE_DEBUG=true

**Lưu ý:** `--no-tree-shake-icons` cần thiết vì app dùng IconData động từ API (codePoint runtime). 
Nếu muốn tối ưu APK size, cần refactor sang const IconData.
