import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/constants.dart';

class SearchService {
  // Search the web using Tavily
  Future<String?> search(String query) async {
    final apiKey = dotenv.env['TAVILY_API_KEY'] ?? '';
    if (apiKey.isEmpty) return "Error: TAVILY_API_KEY not found.";

    try {
      final response = await http.post(
        Uri.parse(AppConstants.tavilyApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'api_key': apiKey,
          'query': query,
          'search_depth': 'basic',
          'max_results': 3,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        if (results.isEmpty) return "No results found.";

        final buffer = StringBuffer();
        for (var result in results) {
          buffer.writeln('Title: ${result['title']}');
          buffer.writeln('Content: ${result['content']}');
          buffer.writeln('---');
        }

        return buffer.toString();
      } else {
        return "Search failed with status: ${response.statusCode}";
      }
    } catch (e) {
      return "Search error: $e";
    }
  }
}
