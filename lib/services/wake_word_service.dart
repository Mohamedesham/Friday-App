import 'package:speech_to_text/speech_to_text.dart';
import 'stt_service.dart';

class WakeWordService {
  final SttService _sttService = SttService();
  bool _isListening = false;
  Function()? _onWakeWord;

  bool get isListening => _isListening;

  Future<void> initialize({required Function() onWakeWord, Function(String)? onStatus}) async {
    _onWakeWord = onWakeWord;
    await _sttService.initialize(onStatus: (status) {
      if (onStatus != null) onStatus(status);
      if (status == 'done' || status == 'notListening') {
        _restartListening();
      }
    });
  }

  Future<void> start() async {
    _isListening = true;
    await _listen();
  }

  Future<void> _listen() async {
    if (!_isListening) return;
    await _sttService.stt.listen(
      onResult: (result) {
        final text = result.recognizedWords.toLowerCase();
        print("WakeWord hearing: $text");
        if (text.contains('friday')) {
          _onWakeWord?.call();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 10),
      localeId: 'en_US',
      cancelOnError: false,
      listenMode: ListenMode.confirmation,
    );
  }

  Future<void> _restartListening() async {
    if (!_isListening) return;
    await Future.delayed(const Duration(milliseconds: 500));
    await _listen();
  }

  Future<void> stop() async {
    _isListening = false;
    await _sttService.stt.stop();
  }

  Future<void> dispose() async {
    _isListening = false;
    await _sttService.stt.stop();
  }
}
