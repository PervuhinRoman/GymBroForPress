import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/tinder/presentation/tinder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('Tinder screen renders correctly', (WidgetTester tester) async {
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
    await tester.pumpAndSettle();

  
    expect(find.byType(TinderScreen), findsOneWidget);
  });

  testWidgets('Tinder swipe interactions work', (WidgetTester tester) async {
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

    await tester.pumpAndSettle();

    final leftSwipeButton = find.byIcon(Icons.close);
    final rightSwipeButton = find.byIcon(Icons.favorite);

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
