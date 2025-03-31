import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/providers/aiml_chat_provider.dart';
import 'package:gymbro/core/theme/app_colors.dart';

class AimlChatScreen extends ConsumerWidget {
  const AimlChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(aimlChatMessagesProvider);
    final isTyping = ref.watch(chatTypingProvider);
    
    return Scaffold(
      body: Chat(
        messages: messages,
        onSendPressed: (text) => ref.read(aimlChatMessagesProvider.notifier).sendMessage(text.text),
        user: const types.User(id: 'user-id'),
        typingIndicatorOptions: TypingIndicatorOptions(
          typingUsers: isTyping ? [const types.User(id: 'ai-id')] : [],
        ),
        theme: DefaultChatTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          primaryColor: AppColors.violetPrimary,
          secondaryColor: AppColors.violetSecondary.withOpacity(0.2),
          sentMessageBodyTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 16,
          ),
          receivedMessageBodyTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
        emptyState: Center(
          child: Text(
            'Спроси меня о тренировках и питании',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(aimlChatMessagesProvider.notifier).clearChat(),
        backgroundColor: AppColors.violetPrimary,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}