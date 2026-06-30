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
      'auth',
      'common',
      'app',
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

        // Handle different JSON structures:
        // 1. If JSON has a single key that matches fileName, use that content
        // 2. Otherwise, merge directly
        if (jsonData.length == 1 && jsonData.containsKey(fileName)) {
          // Case 1: {"auth": {...}} -> keep the nested structure
          mergedData[fileName] = jsonData[fileName];
        } else {
          // Case 2: Direct flat structure -> merge directly
          mergedData.addAll(jsonData);
        }
      } catch (e) {
        // If file doesn't exist, skip it
      }
    }

    return mergedData;
  }
}
