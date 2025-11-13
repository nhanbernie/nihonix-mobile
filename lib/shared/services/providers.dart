import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tts_service.dart';

/// Provider for TTS service
/// 
/// This provider creates and initializes a singleton TTS service
/// that can be used throughout the app for Japanese pronunciation.
final ttsServiceProvider = Provider<TtsService>((ref) {
  final tts = TtsService();
  tts.initialize();
  return tts;
});

