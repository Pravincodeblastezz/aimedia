import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constant {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get chatgptApiKey => dotenv.env['CHATGPT_API_KEY'] ?? '';
}
