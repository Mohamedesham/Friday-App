import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isListening;
  final VoidCallback onMicTap;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isListening,
    required this.onMicTap,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF12122A),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Mic button
          CircleAvatar(
            backgroundColor: isListening
                ? Colors.redAccent
                : const Color(0xFF1E1E2E),
            child: IconButton(
              icon: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 18,
              ),
              onPressed: onMicTap,
            ),
          ),
          const SizedBox(width: 8),
          // Text input
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Ask FRIDAY anything...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1E1E2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
