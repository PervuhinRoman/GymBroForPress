import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../tinder/tinder.dart';
import 'home_content_screen.dart';

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

class HomeScreenArgs {
  final Function(Locale) setLocale;
  final Function(ThemeMode) setThemeMode;

  HomeScreenArgs({
    required this.setLocale,
    required this.setThemeMode,
  });
}

class HomeScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  final Function(ThemeMode) setThemeMode;

  const HomeScreen({
    super.key,
    required this.setLocale,
    required this.setThemeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContentScreen(),
    const TinderScreen(),
    // const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Получение локализованных строк
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _showLanguageSelector(context);
            },
          ),
          // Переключатель темы
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              _showThemeSelector(context);
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.homePageTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center),
            label: l10n.workoutPageTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profilePageTitle,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  // Диалоговое окно для выбора языка
  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  widget.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Русский'),
                onTap: () {
                  widget.setLocale(const Locale('ru'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Диалоговое окно для выбора темы
  void _showThemeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('System'),
                onTap: () {
                  widget.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Light'),
                onTap: () {
                  widget.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                onTap: () {
                  widget.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
