import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gymbro/core/theme/app_theme.dart';
import 'package:gymbro/core/utils/preference_service.dart';
import 'package:gymbro/core/utils/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymbro/features/auth/presentation/screens/welcome_screen.dart';
import 'package:gymbro/features/home/presentation/screens/home_screen.dart';
import 'package:gymbro/firebase_options.dart';
import 'core/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.hasData) {
      //       return HomeScreen(setLocale: setLocale, setThemeMode: setThemeMode);
      //     }
      //     return WelcomeScreen();
      //   },
      // ),
      initialRoute: RouteNames.auth,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
      routes: RoutesBuilder.routes,
    );
  }
}
