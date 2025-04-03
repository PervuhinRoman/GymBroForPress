import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/ai_chat/domain/aiml_chat_provider.dart';
import 'package:gymbro/core/theme/app_colors.dart';

class AimlChatScreen extends ConsumerStatefulWidget {
  const AimlChatScreen({super.key});

  @override
  ConsumerState<AimlChatScreen> createState() => _AimlChatScreenState();
}

class _AimlChatScreenState extends ConsumerState<AimlChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      ref
          .read(aimlChatMessagesProvider.notifier)
          .sendMessage(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aimlChatMessagesProvider);
    final isTyping = ref.watch(chatTypingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-тренер'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(aimlChatMessagesProvider.notifier).clearChat(),
            tooltip: 'Сбросить историю чата',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              messages: messages,
              onSendPressed: (text) => ref
                  .read(aimlChatMessagesProvider.notifier)
                  .sendMessage(text.text),
              user: const types.User(id: 'user-id'),
              typingIndicatorOptions: TypingIndicatorOptions(
                typingUsers: isTyping ? [const types.User(id: 'ai-id')] : [],
              ),
              theme: DefaultChatTheme(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                primaryColor: Theme.of(context).colorScheme.primary,
                secondaryColor: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.2),
                sentMessageBodyTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                ),
                receivedMessageBodyTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                ),
                inputBackgroundColor: Theme.of(context).colorScheme.surface,
                inputTextColor: Theme.of(context).colorScheme.onSurface,
              ),
              emptyState: Center(
                child: Text(
                  'Спроси меня о тренировках и питании',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              // Отключаем встроенное поле ввода, так как мы создаем свое
              showUserAvatars: false,
              showUserNames: false,
              customBottomWidget: Container(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Напишите сообщение...',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: AppColors.violetPrimary,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
