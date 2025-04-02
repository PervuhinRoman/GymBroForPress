import 'package:flutter/material.dart';
import 'package:gymbro/core/_dev/debug_tools.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<ThemeData>((ref) => ThemeData.light());

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
            return Consumer(
              builder: (context, ref, child) {
                final theme = ref.watch(appSettingsNotifierProvider.notifier);
                return Wrap(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            child: Row(
                              children: [
                                Icon(Icons.language),
                                SizedBox(width: sepPadding,),
                                Text('Change language'),
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
                                Text('Change app theme'),
                              ]
                            ),
                            onPressed: () { 
                              _showThemeSelector(context, ref);

                              ref.read(appSettingsNotifierProvider.notifier);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              
            );
          },
        );
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Consumer(
              builder: (context, ref, child) {
                final theme = ref.watch(themeProvider);
                return Container(
                  color: theme.colorScheme.surface,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Themed Bottom Sheet", style: theme.textTheme.bodyLarge),
                      Switch(
                        value: theme.brightness == Brightness.dark,
                        onChanged: (value) {
                          ref.read(themeProvider.notifier).state = 
                            value ? ThemeData.dark() : ThemeData.light();
                        },
                      ),
                    ],
                  ),
                );
              },
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