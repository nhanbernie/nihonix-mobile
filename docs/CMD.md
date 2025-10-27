flutter analyze lib/core/network/ --no-fatal-infos
flutter clean
flutter get
flutter analyze
flutter test
flutter build apk
flutter pub run build_runner build --delete-conflicting-outputs
=> code gen

do dùng cái này nên mình build trước cho thư viện này freezed
dart run build_runner build --delete-conflicting-outputs

copy vào setting.json để không hiện file gen khỏi bị rối
"files.exclude": {
"**/\*.g.dart": true,
"**/_.freezed.dart": true
},
"search.exclude": {
"\*\*/_.g.dart": true,
"\*_/_.freezed.dart": true,
},

<!-- cho cursor -->

    "files.exclude": {
      "**/*.g.dart": true,
      "**/*.freezed.dart": true
    },
    "search.exclude": {
      "**/*.g.dart": true,
      "**/*.freezed.dart": true
    }

dart run flutter_launcher_icons:main
flutter pub run flutter_launcher_icons
dùng lệnh này để load lại icon cho cả app


flutter pub run flutter_native_splash:create
dùng lệnh này để config vào splash