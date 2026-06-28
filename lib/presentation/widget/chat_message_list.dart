import 'package:flutter/material.dart';
import 'package:friday/presentation/widget/message_bubble.dart';

import '../../data/ui_message.dart';

class ChatMessageList extends StatelessWidget {
  final List<UIMessage> messages;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'Good day Boss. I\'m FRIDAY.\nHow can I assist you?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return MessageBubble(message: msg.text, isUser: msg.isUser);
      },
    );
  }
}
