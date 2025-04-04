import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// A helper class to wrap widgets in the necessary providers and MaterialApp for testing
class TestWrapper {
  /// Wraps a widget with ProviderScope and MaterialApp for testing
  static Widget wrapWithMaterialApp(Widget child) {
    return ProviderScope(
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
        home: Scaffold(body: child),
      ),
    );
  }
}
