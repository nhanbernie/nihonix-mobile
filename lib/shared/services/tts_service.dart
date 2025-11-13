import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech service for Japanese pronunciation
/// 
/// This service handles Japanese text pronunciation using flutter_tts.
/// It's a singleton to maintain a single TTS instance across the app.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  /// Initialize TTS with Japanese language settings
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set Japanese language
      await _flutterTts.setLanguage("ja-JP");
      
      // Set speech rate (0.0 to 1.0, default 0.5)
      await _flutterTts.setSpeechRate(0.4);
      
      // Set volume (0.0 to 1.0)
      await _flutterTts.setVolume(1.0);
      
      // Set pitch (0.5 to 2.0, default 1.0)
      await _flutterTts.setPitch(1.0);

      // iOS specific settings
      await _flutterTts.setSharedInstance(true);
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      _isInitialized = true;
    } catch (e) {
      print('❌ TTS initialization error: $e');
    }
  }

  /// Speak the given Japanese text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Stop any ongoing speech
      await _flutterTts.stop();
      
      // Speak the text
      await _flutterTts.speak(text);
    } catch (e) {
      print('❌ TTS speak error: $e');
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('❌ TTS stop error: $e');
    }
  }

  /// Pause current speech
  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      print('❌ TTS pause error: $e');
    }
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      print('❌ TTS setSpeechRate error: $e');
    }
  }

  /// Set pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      print('❌ TTS setPitch error: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _flutterTts.setVolume(volume);
    } catch (e) {
      print('❌ TTS setVolume error: $e');
    }
  }

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    try {
      return await _flutterTts.getLanguages;
    } catch (e) {
      print('❌ TTS getLanguages error: $e');
      return [];
    }
  }

  /// Get available voices
  Future<List<dynamic>> getVoices() async {
    try {
      return await _flutterTts.getVoices;
    } catch (e) {
      print('❌ TTS getVoices error: $e');
      return [];
    }
  }

  /// Dispose TTS resources
  void dispose() {
    _flutterTts.stop();
  }
}

