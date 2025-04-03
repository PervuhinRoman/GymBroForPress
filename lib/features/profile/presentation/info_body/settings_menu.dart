import 'package:flutter/material.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/theme/app_theme.dart';

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  static const double sepPadding = 7.0; 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.settings),
      tooltip: 'Show settings',
      onPressed: () {
        _showSettings(context, ref);
      }
    );
  }

  Future<dynamic> _showSettings(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          final contextTheme = Theme.of(context);
          return Wrap(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        child: Row(
                          children: [
                            Icon(Icons.language),
                            SizedBox(width: sepPadding,),
                            Text(
                              'Change language', 
                              style: contextTheme.textTheme.bodyMedium?.copyWith(
                                color: contextTheme.colorScheme.onTertiary,
                              ),
                            ),
                          ]
                        ),
                        onPressed: () {
                          _showLanguageSelector(context, ref);
                        }
                      ),
                      TextButton(
                        child: Row(
                          children: [
                            Icon(Icons.brightness_6),
                            SizedBox(width: sepPadding,),
                            Text(
                              'Change app theme',
                              style: contextTheme.textTheme.bodyMedium?.copyWith(
                                color: contextTheme.colorScheme.onTertiary,
                              ), 
                            ),
                          ]
                        ),
                        onPressed: () { 
                          _showThemeSelector(context, ref);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
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
}