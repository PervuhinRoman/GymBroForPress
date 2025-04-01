import 'package:flutter/material.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  static const double sepPadding = 7.0; 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextTheme = Theme.of(context);

    return IconButton(
      icon: Icon(Icons.settings),
      tooltip: 'Show settings',
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) {
            return Wrap(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconTheme(
                    data: IconThemeData(
                      size: 50,
                      color: contextTheme.colorScheme.onSecondary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: contextTheme.colorScheme.onSecondary,
                            textStyle: contextTheme.textTheme.bodyLarge,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.language),
                              SizedBox(width: sepPadding,),
                              Text('Change language'),
                            ]
                          ),
                          onPressed: () => _showLanguageSelector(context, ref),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            iconColor: contextTheme.colorScheme.onSecondary,
                            foregroundColor: contextTheme.colorScheme.onSecondary,
                            textStyle: contextTheme.textTheme.bodyLarge,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.brightness_6),
                              SizedBox(width: sepPadding,),
                              Text('Change app theme'),
                            ]
                          ),
                          onPressed: () => _showThemeSelector(context, ref),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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