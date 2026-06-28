import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  TtsService() {
    _init();
  }

  Future<void> _init() async {
    // Set FRIDAY's voice settings
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  // FRIDAY speaks
  Future<void> speak(String text) async {
    await _tts.stop(); // Stop any current speech first
    await _tts.speak(text);
  }

  // Stop speaking
  Future<void> stop() async {
    await _tts.stop();
  }
}
