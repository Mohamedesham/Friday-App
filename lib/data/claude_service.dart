import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:friday/core/constants.dart';
import 'package:http/http.dart' as http;
import '../services/search_service.dart';
import '../services/command_parser_service.dart'; //

class ChatMessage {
  final String role;
  final String content;
  ChatMessage({required this.role, required this.content});
  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}

class ClaudeService {
  final List<ChatMessage> _conversationHistory = [];
  final SearchService _searchService = SearchService();
  final CommandParserService _commandParser = CommandParserService();

  Future<String> sendMessage(String userMessage) async {
    // 🎛️ Check if it's a device command FIRST
    final commandResult = await _commandParser.tryHandleCommand(userMessage);
    if (commandResult != null) {
      // Save to history for context, then return the result directly
      _conversationHistory.add(ChatMessage(role: 'user', content: userMessage));
      _conversationHistory.add(ChatMessage(role: 'assistant', content: commandResult));
      return commandResult;
    }

    // Otherwise continue normally with Claude + web search
    String finalMessage = userMessage;

    if (_searchService.needsWebSearch(userMessage)) {
      final searchResults = await _searchService.search(userMessage);
      if (searchResults != null) {
        finalMessage = '''
$searchResults

User question: $userMessage

Please answer the user's question using the search results above.
''';
      }
    }

    _conversationHistory.add(ChatMessage(role: 'user', content: finalMessage));

    try {
      final response = await http.post(
        Uri.parse(AppConstants.claudeApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': dotenv.env['CLAUDE_API_KEY'] ?? '',
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': AppConstants.claudeModel,
          'max_tokens': AppConstants.maxTokens,
          'system': AppConstants.systemPrompt,
          'messages': _conversationHistory.map((msg) => msg.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['content'][0]['text'] as String;

        _conversationHistory.removeLast();
        _conversationHistory.add(ChatMessage(role: 'user', content: userMessage));
        _conversationHistory.add(ChatMessage(role: 'assistant', content: reply));

        return reply;
      } else {
        return 'Error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  void clearHistory() => _conversationHistory.clear();
}