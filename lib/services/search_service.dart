import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/constants.dart';

class SearchService {
  // Search the web using Tavily
  Future<String?> search(String query) async {
    final apiKey = dotenv.env['TAVILY_API_KEY'] ?? '';

    try {
      final response = await http.post(
        Uri.parse(AppConstants.tavilyApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'api_key': apiKey,
          'query': query,
          'search_depth': 'basic',
          'max_results': 3, // top 3 results is enough
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        if (results.isEmpty) return null;

        // Format results into readable text for Claude
        final buffer = StringBuffer();
        buffer.writeln('Web search results for "$query":');
        buffer.writeln();

        for (int i = 0; i < results.length; i++) {
          final result = results[i];
          buffer.writeln('Source ${i + 1}: ${result['title']}');
          buffer.writeln('${result['content']}');
          buffer.writeln();
        }

        return buffer.toString();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Decide if a query needs web search
  bool needsWebSearch(String query) {
    final q = query.toLowerCase();

    // Keywords that suggest real-time info is needed
    final triggers = [
      'today',
      'now',
      'current',
      'latest',
      'recent',
      'news',
      'price',
      'weather',
      'score',
      'winner',
      'who won',
      'what happened',
      '2025',
      '2026',
      'yesterday',
      'this week',
      'this month',
      'dollar',
      'pound',
      'exchange rate',
    ];

    return triggers.any((trigger) => q.contains(trigger));
  }
}
