import 'dart:convert';

import 'package:flox/core/openai/openai_env.dart';
import 'package:http/http.dart' as http;

/// Minimal Chat Completions client for hackathon / local use.
class OpenAiChatService {
  OpenAiChatService({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;
  static final Uri _chatUrl = Uri.parse('https://api.openai.com/v1/chat/completions');

  /// Each message: `{'role': 'user'|'assistant'|'system', 'content': '...'}`.
  Future<String> completeChat({
    required List<Map<String, String>> messages,
    String model = 'gpt-4o-mini',
  }) async {
    final key = OpenAiEnv.apiKey;
    if (key.isEmpty) {
      throw StateError(
        'OPENAI_API_KEY is missing. For web use: '
        'flutter run -d chrome --dart-define=OPENAI_API_KEY=sk-... '
        'For desktop, set OPENAI_API_KEY in the environment or use the same --dart-define.',
      );
    }

    final response = await _http.post(
      _chatUrl,
      headers: {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI HTTP ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>?;
    final first = choices?.first as Map<String, dynamic>?;
    final message = first?['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;
    if (content == null || content.isEmpty) {
      throw Exception('OpenAI response missing content');
    }
    return content;
  }
}
