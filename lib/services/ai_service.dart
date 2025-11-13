import 'dart:convert';
import 'package:aimedia/constant.dart';
import 'package:http/http.dart' as http;

class AIService {
  static const _apiUrl = "https://router.huggingface.co/v1/chat/completions";
  var _apiKey = Constant.apiKey;

  static Future<String> analyzeImage(String imageUrl) async {
    try {
      // 1️⃣ Build request body in OpenAI-compatible Hugging Face format
      final body = jsonEncode({
        "model": "zai-org/GLM-4.5V:novita",
        "stream": false,
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text": "Describe this image in one sentence."
              },
              {
                "type": "image_url",
                "image_url": {"url": imageUrl}
              }
            ]
          }
        ]
      });

      // 2️⃣ Send POST request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer ${Constant.apiKey}",
          "Content-Type": "application/json",
        },
        body: body,
      );

      var text = "";
      // 3️⃣ Parse the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(response.body);
        // Hugging Face follows OpenAI format — text is under choices → message → content
        final choices = data["choices"];
        if (choices != null &&
            choices.isNotEmpty &&
            choices.first["message"] != null) {
          final content = choices.first["message"]["content"];
          text = content;
          if (content is List && content.isNotEmpty) {
            final textItem = content.firstWhere(
                  (item) => item["type"] == "text",
              orElse: () => null,
            );
            if (textItem != null) return textItem["text"];
          }
        }

        return text;
      } else {
        return "API Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  static const _ChatgptapiUrl = "https://api.openai.com/v1/chat/completions";
  var _ChatgptapiKey = Constant.chatgptApiKey;

  static Future<String> analyzeVideo(String videoUrl) async {
    try {
      // 1️⃣ Build request body (OpenAI-compatible format)
      final body = jsonEncode({
        "model": "gpt-4.1", // or "gpt-4o" for higher quality
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text": "Describe this video in one sentence."
              },
              {
                "type": "input_video",
                "input_video": {"url": videoUrl}
              }
            ]
          }
        ],
        "max_tokens": 200,
      });

      // 2️⃣ Send POST request
      final response = await http.post(
        Uri.parse(_ChatgptapiUrl),
        headers: {
          "Authorization": "Bearer ${Constant.chatgptApiKey}",
          "Content-Type": "application/json",
        },
        body: body,
      );

      // 3️⃣ Parse response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data["choices"][0]["message"]["content"];
        if (content is String) return content;

        // In case it returns structured content
        if (content is List) {
          final textItem = content.firstWhere(
                (item) => item["type"] == "text",
            orElse: () => null,
          );
          if (textItem != null) return textItem["text"];
        }

        return "No description found.";
      } else {
        return "API Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

}
