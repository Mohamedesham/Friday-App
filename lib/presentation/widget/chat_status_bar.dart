import 'package:flutter/material.dart';

class ChatStatusBar extends StatelessWidget {
  final bool isListening;
  final bool isLoading;

  const ChatStatusBar({
    super.key,
    required this.isListening,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Show nothing if no active state
    if (!isListening && !isLoading) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: isListening ? _listeningIndicator() : _thinkingIndicator(),
    );
  }

  Widget _listeningIndicator() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.mic, color: Colors.redAccent, size: 16),
        SizedBox(width: 6),
        Text(
          'Listening...',
          style: TextStyle(color: Colors.redAccent, fontSize: 13),
        ),
      ],
    );
  }

  Widget _thinkingIndicator() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 16),
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(width: 8),
        Text(
          'FRIDAY is thinking...',
          style: TextStyle(color: Colors.white38, fontSize: 13),
        ),
      ],
    );
  }
}
