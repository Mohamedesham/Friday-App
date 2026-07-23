import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:friday/core/constants.dart';
import 'package:http/http.dart' as http;
import '../services/search_service.dart';
import '../services/command_parser_service.dart';

class ChatMessage {
  final String role;
  final dynamic content; // Can be String or List<Map<String, dynamic>>
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
      _conversationHistory.add(ChatMessage(role: 'user', content: userMessage));
      _conversationHistory.add(ChatMessage(role: 'assistant', content: commandResult));
      return commandResult;
    }

    _conversationHistory.add(ChatMessage(role: 'user', content: userMessage));

    try {
      return await _processWithTools();
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> _processWithTools() async {
    final tools = [
      {
        "name": "web_search",
        "description": "Searches the web for real-time information, current events, or details beyond the model's training data.",
        "input_schema": {
          "type": "object",
          "properties": {
            "query": {
              "type": "string",
              "description": "The search query to look up on the web."
            }
          },
          "required": ["query"]
        }
      }
    ];

    while (true) {
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
          'tools': tools,
          'messages': _conversationHistory.map((msg) => msg.toJson()).toList(),
        }),
      );

      if (response.statusCode != 200) {
        return 'Error ${response.statusCode}: ${response.body}';
      }

      final data = jsonDecode(response.body);
      final List content = data['content'];
      final String stopReason = data['stop_reason'];

      // Add Claude's response (which might be a tool use request) to history
      _conversationHistory.add(ChatMessage(role: 'assistant', content: content));

      if (stopReason == 'tool_use') {
        // Handle tool calls
        for (var item in content) {
          if (item['type'] == 'tool_use' && item['name'] == 'web_search') {
            final toolUseId = item['id'];
            final query = item['input']['query'];

            // Execute the search
            final searchResult = await _searchService.search(query) ?? "No results found.";

            // Add tool result to history
            _conversationHistory.add(ChatMessage(
              role: 'user',
              content: [
                {
                  "type": "tool_result",
                  "tool_use_id": toolUseId,
                  "content": searchResult,
                }
              ],
            ));
          }
        }
        // Loop again to give Claude the results
        continue;
      } else {
        // Final response received (text)
        String reply = "";
        for (var item in content) {
          if (item['type'] == 'text') {
            reply += item['text'];
          }
        }
        return reply;
      }
    }
  }

  void clearHistory() => _conversationHistory.clear();
}
