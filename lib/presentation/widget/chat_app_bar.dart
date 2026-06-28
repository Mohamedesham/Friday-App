import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSpeaking;
  final VoidCallback onClear;
  final bool isWaiting;

  const ChatAppBar({
    super.key,
    required this.isSpeaking,
    required this.onClear,
    required this.isWaiting,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0D0D1A),
      title: const Row(
        children: [
          Icon(Icons.bolt, color: Colors.blueAccent),
          SizedBox(width: 8),
          Text(
            'FRIDAY',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
      actions: [
        if (isSpeaking)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.volume_up, color: Colors.blueAccent),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Row(
            children: [
              Icon(
                Icons.hearing,
                color: isWaiting ? Colors.greenAccent : Colors.white54,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                isWaiting ? 'Listening...' : 'Active',
                style: TextStyle(
                  color: isWaiting ? Colors.greenAccent : Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white54),
          tooltip: 'Clear conversation',
          onPressed: onClear,
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
