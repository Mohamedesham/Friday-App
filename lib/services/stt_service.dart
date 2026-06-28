import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _stt = SpeechToText();
  bool _isInitialized = false;

  // Must call this before using
  Future<bool> initialize() async {
    _isInitialized = await _stt.initialize(
      onError: (error) => print('STT error: $error'),
    );
    return _isInitialized;
  }

  bool get isListening => _stt.isListening;

  bool get isAvailable => _isInitialized;

  // Start listening and call onResult with the recognized text
  Future<void> startListening({required Function(String) onResult}) async {
    if (!_isInitialized) return;
    await _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          // Only trigger when user finishes speaking
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 10), // Max listening time
      pauseFor: const Duration(seconds: 2), // Stop after 2s of silence
      localeId: 'en_US',
    );
  }

  // Stop listening
  Future<void> stopListening() async {
    await _stt.stop();
  }
}
