import 'package:speech_to_text/speech_to_text.dart';

class WakeWordService {
  final SpeechToText _stt = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  Function()? _onWakeWord;

  bool get isListening => _isListening;

  Future<void> initialize({required Function() onWakeWord}) async {
    _onWakeWord = onWakeWord;
    _isInitialized = await _stt.initialize(
      onError: (_) => _restartListening(), // auto restart on error
      onStatus: (status) {
        // Auto restart when STT stops
        if (status == 'done' || status == 'notListening') {
          _restartListening();
        }
      },
    );
  }

  Future<void> start() async {
    if (!_isInitialized) return;
    await _listen();
    _isListening = true;
  }


  Future<void> _listen() async {
    await _stt.listen(
      onResult: (result) {
        final text = result.recognizedWords.toLowerCase();
        if (text.trim() == 'friday' || text.contains('hey friday')) {
          _onWakeWord?.call();
          return; //  don't send to Claude
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
    );
  }
  // Auto restart to make it always-on
  Future<void> _restartListening() async {
    if (!_isListening) return;
    await Future.delayed(const Duration(milliseconds: 500));
    await _listen();
  }

  Future<void> stop() async {
    _isListening = false;
    await _stt.stop();
  }

  Future<void> dispose() async {
    _isListening = false;
    await _stt.stop();
  }
}