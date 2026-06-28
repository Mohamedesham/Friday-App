class AppConstants {
  static const String claudeModel = 'claude-haiku-4-5-20251001';
  static const String claudeApiUrl = 'https://api.anthropic.com/v1/messages';
  static const String tavilyApiUrl = 'https://api.tavily.com/search';

  static const int maxTokens = 1024;

  // FRIDAY's personality
  static const String systemPrompt = '''
You are FRIDAY, a highly intelligent personal AI assistant, similar to Iron Man's AI.
You are helpful, witty, and efficient.
You address the user professionally but with a slight personality.
Keep responses concise unless the user asks for details.
Your knowledge has a cutoff of early 2025. For anything after that,
tell the user you are not aware of it and suggest they search online.
''';
}
