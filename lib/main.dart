import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'core/providers/app_settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Инициализация настроек пользователя
  await dotenv.load(fileName: '.env');

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

  runApp(
    ProviderScope(child: const MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем настройки из провайдера
    final appSettings = ref.watch(appSettingsNotifierProvider);

    Logger.log.i('Building app with ThemeMode: ${appSettings.themeMode}');

    return MaterialApp(
      title: 'GymBro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appSettings.themeMode,
      locale: appSettings.locale,
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
      home: const AppContent(),
      initialRoute: RouteNames.home,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
      routes: RoutesBuilder.routes,
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen(key: ValueKey('home_screen'));
        }
        return const WelcomeScreen();
      },
    );
  }
}
