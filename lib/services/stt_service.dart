import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _stt = SpeechToText();
  bool _isInitialized = false;

  // Must call this before using
  Future<bool> initialize({Function(String)? onStatus}) async {
    _isInitialized = await _stt.initialize(
      onError: (error) => print('STT error: $error'),
      onStatus: (status) {
        print('STT status: $status');
        if (onStatus != null) onStatus(status);
      },
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
        print('STT Result: ${result.recognizedWords}, final: ${result.finalResult}');
        if (result.finalResult) {
          // Only trigger when user finishes speaking
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30), // Increased max listening time
      pauseFor: const Duration(seconds: 4), // Increased pause time
      localeId: 'en_US',
    );
  }

  // Stop listening
  Future<void> stopListening() async {
    await _stt.stop();
  }
}
