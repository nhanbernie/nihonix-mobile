import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// Custom asset loader that loads multiple JSON files and merges them
/// 
/// Structure:
/// assets/translations/
/// ├── en/
/// │   ├── app.json
/// │   ├── common.json
/// │   └── auth.json
/// ├── vi/
/// │   ├── app.json
/// │   ├── common.json
/// │   └── auth.json
/// └── ja/
///     ├── app.json
///     ├── common.json
///     └── auth.json
class MultipleJsonAssetLoader extends AssetLoader {
  /// List of JSON file names to load (without extension)
  final List<String> fileNames;

  const MultipleJsonAssetLoader({
    this.fileNames = const [
      'app',
      'common',
      'auth',
      'home',
      'lessons',
      'profile',
      'errors',
      'validation',
    ],
  });

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final Map<String, dynamic> mergedData = {};

    // Load each JSON file and merge
    for (final fileName in fileNames) {
      try {
        final filePath = '$path/${locale.languageCode}/$fileName.json';
        final jsonString = await rootBundle.loadString(filePath);
        final Map<String, dynamic> jsonData = json.decode(jsonString);

        // Merge data with key prefix (file name)
        mergedData[fileName] = jsonData;
      } catch (e) {
        // If file doesn't exist, skip it
        print('Warning: Could not load $path/${locale.languageCode}/$fileName.json');
      }
    }

    return mergedData;
  }
}

