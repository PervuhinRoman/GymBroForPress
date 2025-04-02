import 'package:flutter/material.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.settings),
      tooltip: 'Show settings',
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.primary,
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("data"),
                    IconButton(
                      icon: const Icon(Icons.language),
                      onPressed: () => _showLanguageSelector(context, ref),
                    ),
                    IconButton(
                      icon: const Icon(Icons.brightness_6),
                      onPressed: () => _showThemeSelector(context, ref),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
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
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Русский'),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setLocale(const Locale('ru'));
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
  void _showThemeSelector(BuildContext context, WidgetRef ref) {
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
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Light'),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
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