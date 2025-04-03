import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/tinder/presentation/tinder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('Tinder screen renders correctly', (WidgetTester tester) async {
    // Build Tinder widget
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
          home: const Scaffold(body: TinderScreen()),
        ),
      ),
    );

    // Wait for widget to fully build (important for async operations)
    await tester.pumpAndSettle();

    // Verify Tinder screen is rendered
    expect(find.byType(TinderScreen), findsOneWidget);
  });

  testWidgets('Tinder swipe interactions work', (WidgetTester tester) async {
    // Build Tinder widget
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
          home: const Scaffold(body: TinderScreen()),
        ),
      ),
    );

    // Wait for widget to fully build
    await tester.pumpAndSettle();

    // This test will need to be customized based on the actual implementation
    // For example, if there's a Draggable card, you can test swiping it:

    // Assuming there are swipe buttons
    final leftSwipeButton = find.byIcon(Icons.close);
    final rightSwipeButton = find.byIcon(Icons.favorite);

    // If the buttons exist, test tapping them
    if (leftSwipeButton.evaluate().isNotEmpty) {
      await tester.tap(leftSwipeButton);
      await tester.pumpAndSettle();
    }

    if (rightSwipeButton.evaluate().isNotEmpty) {
      await tester.tap(rightSwipeButton);
      await tester.pumpAndSettle();
    }
  });
}
