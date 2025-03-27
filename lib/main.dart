import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gymbro/core/theme/app_theme.dart';
import 'package:gymbro/core/utils/preference_service.dart';
import 'package:gymbro/core/utils/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymbro/firebase_options.dart';
import 'package:gymbro/features/auth/presentation/screens/welcome_screen.dart';
import 'package:gymbro/features/home/presentation/screens/home_screen.dart';
import 'core/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Инициализация настроек пользователя

  Logger.init();
  Logger.log.i('App starting...');

  await PreferencesService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Логирование текущего пользователя при запуске
  final user = FirebaseAuth.instance.currentUser;
  Logger.log
      .i('Current user on app startup: ${user?.email ?? 'Not authenticated'}');

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
    Logger.log.i('Loading theme mode: $themeModeIndex');

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
    Logger.log.i('Locale changed to: ${locale.languageCode}');
    PreferencesService.setLocale(locale.languageCode);
  }

  // Метод для смены темы приложения
  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    Logger.log
        .i('Theme mode changed to: $themeMode (index: ${themeMode.index})');
    PreferencesService.setThemeMode(themeMode.index);
  }

  @override
  Widget build(BuildContext context) {
    Logger.log.i('Building app with ThemeMode: $_themeMode');

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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            Logger.log.i('User authenticated: ${snapshot.data?.email}');
            return HomeScreen(
              setLocale: setLocale,
              setThemeMode: setThemeMode,
            );
          }

          Logger.log.i('User not authenticated, showing WelcomeScreen');
          return const WelcomeScreen();
        },
      ),
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
      routes: RoutesBuilder.routes,
    );
  }
}
