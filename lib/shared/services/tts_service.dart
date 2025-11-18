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
  bool _isInitializing = false;

  /// Initialize TTS with Japanese language settings
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (_isInitializing) {
      // Wait for ongoing initialization
      await Future.delayed(const Duration(milliseconds: 100));
      return initialize();
    }

    _isInitializing = true;

    try {
      print('🔧 Starting TTS initialization...');

      // Check available engines
      final engines = await _flutterTts.getEngines;
      print('🔧 Available TTS engines: $engines');

      // Set up completion handlers
      _flutterTts.setStartHandler(() {
        print('🔊 TTS started speaking');
      });

      _flutterTts.setCompletionHandler(() {
        print('✅ TTS completed speaking');
      });

      _flutterTts.setErrorHandler((msg) {
        print('❌ TTS error: $msg');
      });

      _flutterTts.setCancelHandler(() {
        print('🚫 TTS cancelled');
      });

      // Important: Set this BEFORE other settings for Android
      await _flutterTts.awaitSpeakCompletion(true);
      print('✅ awaitSpeakCompletion set');

      // Set Japanese language
      final langResult = await _flutterTts.setLanguage("ja-JP");
      print('🌐 Language set result: $langResult');

      // Check if language is available
      final isAvailable = await _flutterTts.isLanguageAvailable("ja-JP");
      print('🌐 Japanese available: $isAvailable');

      if (isAvailable == false) {
        print('⚠️ Japanese language not available on this device!');
        print('⚠️ User needs to install Japanese TTS from Google Play Store');
      }

      // Set speech rate (0.0 to 1.0, default 0.5)
      await _flutterTts.setSpeechRate(0.4);
      print('✅ Speech rate set');

      // Set volume (0.0 to 1.0)
      await _flutterTts.setVolume(1.0);
      print('✅ Volume set');

      // Set pitch (0.5 to 2.0, default 1.0)
      await _flutterTts.setPitch(1.0);
      print('✅ Pitch set');

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

      // Longer delay to ensure engine is fully ready on Android
      print('⏳ Waiting for TTS engine to be ready...');
      await Future.delayed(const Duration(seconds: 1));

      _isInitialized = true;
      print('✅✅✅ TTS initialized successfully! ✅✅✅');
    } catch (e) {
      print('❌ TTS initialization error: $e');
      _isInitialized = false;
    } finally {
      _isInitializing = false;
    }
  }

  /// Speak the given Japanese text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      print('🔄 Initializing TTS...');
      await initialize();
    }

    if (!_isInitialized) {
      print('❌ TTS not ready, skipping speak');
      return;
    }

    try {
      print('🔊 Speaking: $text');

      // Speak the text (awaitSpeakCompletion is already set to true)
      final result = await _flutterTts.speak(text);
      print('📢 Speak result: $result');

      if (result == 0) {
        print('❌ TTS speak returned error code 0');
        // Reset and try to reinitialize on next call
        _isInitialized = false;
      } else {
        print('✅ TTS speak initiated successfully');
      }
    } catch (e) {
      print('❌ TTS speak error: $e');
      // If error, try to reinitialize
      _isInitialized = false;
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.stop();
    } catch (e) {
      print('❌ TTS stop error: $e');
    }
  }

  /// Pause current speech
  Future<void> pause() async {
    if (!_isInitialized) return;

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
    if (_isInitialized) {
      try {
        _flutterTts.stop();
      } catch (e) {
        print('❌ TTS dispose error: $e');
      }
    }
  }
}
