import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/theme/app_theme.dart';
import 'package:gymbro/core/utils/preference_service.dart';
import 'package:gymbro/core/utils/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'common/navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.init();
  Logger.log.i('App starting...');

  await PreferencesService.init();

  runApp(
    ProviderScope(child: const MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final themeModeIndex = PreferencesService.getThemeMode();
    setState(() {
      _themeMode = ThemeMode.values[themeModeIndex];
    });

    final savedLocale = PreferencesService.getLocale();
    if (savedLocale != null) {
      setState(() {
        _locale = Locale(savedLocale);
      });
    }

    Logger.log.i('Settings loaded. ThemeMode: $_themeMode, Locale: $_locale');
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    PreferencesService.setLocale(locale.languageCode);
  }

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    PreferencesService.setThemeMode(themeMode.index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymBro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      locale: _locale,
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
      initialRoute: RouteNames.home,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
      routes: RoutesBuilder.routes,
    );
  }
}
