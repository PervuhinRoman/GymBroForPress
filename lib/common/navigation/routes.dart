import 'package:flutter/material.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/tinder/tinder.dart';

abstract class RouteNames {
  const RouteNames._();

  static const home = '/';
  static const tinder = 'tinder';
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
    }

    return null;
  }
}
