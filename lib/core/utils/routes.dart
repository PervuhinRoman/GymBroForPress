import 'package:flutter/material.dart';
import 'package:gymbro/features/ai_chat/presentation/screens/aiml_chat_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/login_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/questionnare_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/registration_screen.dart';
import 'package:gymbro/features/auth/presentation/screens/welcome_screen.dart';
import 'package:gymbro/features/profile/presentation/profile_page.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/tinder/presentation/tinder.dart';

abstract class RouteNames {
  const RouteNames._();

  static const home = '/home';
  static const tinder = '/tinder';
  static const auth = '/auth';
  static const login = '/login';
  static const questionnare = '/questionnare';
  static const registration = '/registration';
  static const forgotPassword = '/forgotPassword';
  static const String aiChat = '/aiChat';
  static const profile = '/profile';
}

abstract class RoutesBuilder {
  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.home: (context) {
      return HomeScreen();
    },
    RouteNames.tinder: (_) => const TinderScreen(),
    RouteNames.profile: (_) => const ProfilePage(),
  };

  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) {
            return HomeScreen();
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
      case RouteNames.questionnare:
        return MaterialPageRoute(
          builder: (_) => const QuestionnaireScreen(),
          settings: settings,
        );
      case RouteNames.aiChat:
        return MaterialPageRoute(
          builder: (_) => const AimlChatScreen(),
          settings: settings,
        );
      case RouteNames.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
    }

    return null;
  }
}
