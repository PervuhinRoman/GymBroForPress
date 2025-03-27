import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gymbro/core/theme/app_theme.dart';
import 'package:gymbro/core/utils/preference_service.dart';
import 'package:gymbro/core/utils/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'features/navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  Logger.init();
  Logger.log.i('App starting...');

  // Инициализация настроек пользователя
  await PreferencesService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // Загрузка темы
    final themeModeIndex = PreferencesService.getThemeMode();
    setState(() {
      _themeMode = ThemeMode.values[themeModeIndex];
    });

    // Загрузка языка
    final savedLocale = PreferencesService.getLocale();
    if (savedLocale != null) {
      setState(() {
        _locale = Locale(savedLocale);
      });
    }

    Logger.log.i('Settings loaded. ThemeMode: $_themeMode, Locale: $_locale');
  }

  // Метод для смены языка приложения
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    PreferencesService.setLocale(locale.languageCode);
  }

  // Метод для смены темы приложения
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