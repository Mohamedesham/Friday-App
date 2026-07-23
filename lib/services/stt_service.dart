import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  static final SpeechToText _sharedStt = SpeechToText();
  static bool _isInitialized = false;
  static final List<Function(String)> _statusListeners = [];

  SpeechToText get stt => _sharedStt;

  // Must call this before using
  Future<bool> initialize({Function(String)? onStatus}) async {
    if (onStatus != null && !_statusListeners.contains(onStatus)) {
      _statusListeners.add(onStatus);
    }
    
    if (_isInitialized) return true;
    
    _isInitialized = await _sharedStt.initialize(
      onError: (error) => print('STT error: $error'),
      onStatus: (status) {
        print('STT status: $status');
        for (var listener in List.from(_statusListeners)) {
          listener(status);
        }
      },
    );
    return _isInitialized;
  }

  bool get isListening => _sharedStt.isListening;

  bool get isAvailable => _isInitialized;

  // Start listening and call onResult with the recognized text
  Future<void> startListening({required Function(String) onResult}) async {
    if (!_isInitialized) return;
    await _sharedStt.listen(
      onResult: (result) {
        print('STT Result: ${result.recognizedWords}, final: ${result.finalResult}');
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 15),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  // Stop listening
  Future<void> stopListening() async {
    await _sharedStt.stop();
  }
}
