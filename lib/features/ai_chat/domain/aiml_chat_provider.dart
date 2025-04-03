import 'package:gymbro/features/ai_chat/data/aiml_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

part 'aiml_chat_provider.g.dart';

@Riverpod(keepAlive: true)
AimlApiRepository aimlApiService(ref) {
  return AimlApiRepository();
}

@Riverpod(keepAlive: true)
class ChatTyping extends _$ChatTyping {
  @override
  bool build() {
    return false;
  }

  void setTyping(bool isTyping) {
    state = isTyping;
  }
}

@Riverpod(keepAlive: true)
class AimlChatMessages extends _$AimlChatMessages {
  final _user = const types.User(id: 'user-id', firstName: 'Пользователь');
  final _aiUser = const types.User(id: 'ai-id', firstName: 'GymBro AI');
  final _systemPrompt =
      'Ты персональный тренер по фитнесу, эксперт по питанию и тренировкам. Отвечай коротко и давай полезные советы.';

  @override
  List<types.Message> build() {
    return [
      types.TextMessage(
        author: _aiUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'Привет! Я твой персональный тренер. Чем могу помочь?',
      )
    ];
  }

  Future<void> sendMessage(String text) async {
    final AimlApiRepository chatService = ref.read(aimlApiServiceProvider);
    final chatTypingNotifier = ref.read(chatTypingProvider.notifier);

    // Добавляем сообщение пользователя
    final userMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: text,
    );

    state = [userMessage, ...state];

    // Устанавливаем состояние печати
    chatTypingNotifier.setTyping(true);

    try {
      // Отправляем запрос к ИИ
      final response =
          await chatService.sendMessage(text, systemPrompt: _systemPrompt);

      // Добавляем ответ ИИ
      final aiMessage = types.TextMessage(
        author: _aiUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: response,
      );

      state = [aiMessage, ...state];
    } catch (e) {
      // Обрабатываем ошибку
      final errorMessage = types.TextMessage(
        author: _aiUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'Произошла ошибка: $e',
      );

      state = [errorMessage, ...state];
    } finally {
      // Убираем индикатор печати
      chatTypingNotifier.setTyping(false);
    }
  }

  void clearChat() {
    final chatService = ref.read(aimlApiServiceProvider);
    chatService.clearHistory();

    ref.invalidateSelf();
  }
}
