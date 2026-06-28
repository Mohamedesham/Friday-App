import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:friday/presentation/chat_screen.dart';

Future<void> main() async {
  // Load the .env file before the app starts
  await dotenv.load(fileName: '.env');
  runApp(const FridayApp());
}

class FridayApp extends StatelessWidget {
  const FridayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FRIDAY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ChatScreen(),
    );
  }
}
