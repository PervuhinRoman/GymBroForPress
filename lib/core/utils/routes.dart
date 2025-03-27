import 'package:flutter/material.dart';
import 'package:gymbro/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/login_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/registration_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/welcome_screen.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/tinder/tinder.dart';

abstract class RouteNames {
  const RouteNames._();

  static const home = 'home';
  static const tinder = 'tinder';
  static const auth = 'auth';
  static const login = 'login';
  static const registration = 'registration';
  static const forgotPassword = 'forgotPassword';
}

abstract class RoutesBuilder {
  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.home: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as HomeScreenArgs?;
      return HomeScreen(
        setLocale: args?.setLocale ?? (locale) {},
        setThemeMode: args?.setThemeMode ?? (themeMode) {},
      );
    },
    RouteNames.tinder: (_) => const TinderScreen(),
  };

  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as HomeScreenArgs?;
            return HomeScreen(
              setLocale: args?.setLocale ?? (locale) {},
              setThemeMode: args?.setThemeMode ?? (themeMode) {},
            );
          },
          settings: settings,
        );

      case RouteNames.tinder:
        return MaterialPageRoute(
          builder: (_) => const TinderScreen(),
          settings: settings,
        );
      case RouteNames.auth:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case RouteNames.registration:
        return MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
          settings: settings,
        );
      case RouteNames.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );
    }

    return null;
  }
}
