import 'package:flutter/material.dart';
import 'package:friday/presentation/widget/chat_app_bar.dart';
import 'package:friday/presentation/widget/chat_input_bar.dart';
import 'package:friday/presentation/widget/chat_message_list.dart';
import 'package:friday/presentation/widget/chat_status_bar.dart';
import '../data/claude_service.dart';
import '../data/ui_message.dart';
import '../services/tts_service.dart';
import '../services/stt_service.dart';
import '../services/wake_word_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ClaudeService _claudeService = ClaudeService();
  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<UIMessage> _messages = [];
  final WakeWordService _wakeWordService = WakeWordService();
  bool _isWaiting = true; // waiting for wake word

  bool _isLoading = false;
  bool _isListening = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _sttService.initialize(onStatus: _handleStatus);
    _initWakeWord();
  }

  void _handleStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      if (mounted) setState(() => _isListening = false);
    } else if (status == 'listening') {
      if (mounted) setState(() => _isListening = true);
    }
  }

  Future<void> _initWakeWord() async {
    await _wakeWordService.initialize(
      onWakeWord: _onWakeWordDetected,
      onStatus: _handleStatus,
    );
    await _wakeWordService.start();
  }

  // Called when "Hey FRIDAY" is detected
  Future<void> _onWakeWordDetected() async {
    if (_isLoading || _isListening) return;

    setState(() => _isWaiting = false);

    // Stop wake word completely
    await _wakeWordService.stop();

    // Wait for STT to fully release
    await Future.delayed(const Duration(milliseconds: 500));

    // Speak acknowledgment
    await _ttsService.speak("Yes boss?");

    // Wait for TTS to finish speaking
    await Future.delayed(const Duration(milliseconds: 1200));

    // Now start listening for command
    await _toggleListening();

    // IMPORTANT: Wait for user to finish speaking
    // We poll _isListening which is updated by _handleStatus
    while (_isListening) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Restart wake word after done
    await _wakeWordService.start();

    setState(() => _isWaiting = true);
  }
  @override
  void dispose() {
    _wakeWordService.dispose();
    super.dispose();
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    _controller.clear();
    setState(() {
      _messages.add(UIMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    await _getReply(text);
  }

  Future<void> _getReply(String userMessage) async {
    final reply = await _claudeService.sendMessage(userMessage);

    setState(() {
      _messages.add(UIMessage(text: reply, isUser: false));
      _isLoading = false;
      _isSpeaking = true;
    });
    _scrollToBottom();

    await _ttsService.speak(reply);
    setState(() => _isSpeaking = false);
  }

  Future<void> _toggleListening() async {
    if (!_sttService.isAvailable) return;

    if (_isListening) {
      await _sttService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _sttService.startListening(
        onResult: (text) async {
          if (text.isNotEmpty) {
            setState(() {
              _isListening = false;
              _controller.text = text;
            });
            await _sendMessage();
          }
        },
      );
    }
  }

  void _clearConversation() {
    _claudeService.clearHistory();
    _ttsService.stop();
    setState(() => _messages.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: ChatAppBar(isSpeaking: _isSpeaking, onClear: _clearConversation,isWaiting: _isWaiting,),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              messages: _messages,
              scrollController: _scrollController,
            ),
          ),
          ChatStatusBar(isListening: _isListening, isLoading: _isLoading),
          ChatInputBar(
            controller: _controller,
            isListening: _isListening,
            onMicTap: _toggleListening,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
