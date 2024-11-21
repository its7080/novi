import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    final key = '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';
    try {
      final res = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $key',
        },
        body: jsonEncode({
          "model": "llama3-70b-8192",
          "messages": [
            {
              'role': 'user',
              'content':
                  '$prompt. Answer like you are having a normal conversation.',
            }
          ],
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
