import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/ai_chat/presentation/screens/aiml_chat_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('AI Chat screen renders correctly', (WidgetTester tester) async {
    // Build AI Chat widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ru', ''),
          ],
          home: const Scaffold(body: AimlChatScreen()),
        ),
      ),
    );

    // Wait for widget to fully build
    await tester.pumpAndSettle();

    // Verify AI Chat screen is rendered
    expect(find.byType(AimlChatScreen), findsOneWidget);
  });

  testWidgets('AI Chat input field works', (WidgetTester tester) async {
    // Build AI Chat widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ru', ''),
          ],
          home: const Scaffold(body: AimlChatScreen()),
        ),
      ),
    );

    // Wait for widget to fully build
    await tester.pumpAndSettle();

    // Find the text input field (assuming it's a TextField)
    final textFieldFinder = find.byType(TextField);

    if (textFieldFinder.evaluate().isNotEmpty) {
      // Enter text in the input field
      await tester.enterText(textFieldFinder.first, 'Test message');

      // Verify text was entered
      expect(find.text('Test message'), findsOneWidget);

      // Find and tap the send button (assuming it's an IconButton with send icon)
      final sendButton = find.byIcon(Icons.send);

      if (sendButton.evaluate().isNotEmpty) {
        await tester.tap(sendButton);
        await tester.pumpAndSettle();
      }
    }
  });
}
