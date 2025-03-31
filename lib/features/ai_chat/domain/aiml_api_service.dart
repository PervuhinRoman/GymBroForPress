import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AimlApiService {
  final String baseUrl = 'https://api.aimlapi.com/v1';
  late final String apiKey;
  final List<Map<String, dynamic>> _conversationHistory = [];
  
  AimlApiService() {
    apiKey = dotenv.env['AIML_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('AIML API key not found in environment variables');
    }
  }

  Future<String> sendMessage(String message, {String? systemPrompt}) async {
    // Добавляем сообщение пользователя в историю
    _conversationHistory.add({
      'role': 'user',
      'content': message
    });
    
    try {
      final response = await _callApi(systemPrompt: systemPrompt);
      
      // Добавляем ответ ИИ в историю
      _conversationHistory.add({
        'role': 'assistant',
        'content': response
      });
      
      return response;
    } catch (e) {
      return 'Ошибка: $e';
    }
  }
  
  Future<String> _callApi({String? systemPrompt}) async {
    final List<Map<String, dynamic>> messages = [];
    
    // Добавляем системное сообщение, если оно есть
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      messages.add({
        'role': 'system',
        'content': systemPrompt
      });
    }
    
    // Добавляем историю диалога
    messages.addAll(_conversationHistory);
    
    final url = Uri.parse('$baseUrl/chat/completions');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'mistralai/Mistral-7B-Instruct-v0.2', // Можно менять на нужную модель
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('API error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  void clearHistory() {
    _conversationHistory.clear();
  }
}