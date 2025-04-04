import 'package:flutter/material.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymbro/core/utils/routes.dart';

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  static const double sepPadding = 7.0; 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.settings),
      tooltip: 'Show settings',
      onPressed: () {
        showModalBottomSheet(
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) {
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
                            Text('Change language', ),
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
                            Text('Change app theme', ),
                          ]
                        ),
                        onPressed: () { 
                          _showThemeSelector(context, ref);
                        },
                      ),
                      Divider(),
                      TextButton(
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: sepPadding,),
                            Text('Выйти из аккаунта', style: TextStyle(color: Colors.red)),
                          ]
                        ),
                        onPressed: () {
                          _showLogoutConfirmation(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выход из аккаунта'),
          content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Закрываем диалог
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  
                  if (context.mounted) {
                    // Закрываем все диалоги
                    Navigator.popUntil(context, (route) => route.isFirst);
                    
                    // Перенаправляем на экран авторизации
                    Navigator.of(context).pushReplacementNamed(RouteNames.auth);
                    
                    // Показываем сообщение об успешном выходе
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Вы успешно вышли из аккаунта')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Показываем сообщение об ошибке
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка при выходе из аккаунта: $e')),
                    );
                    Navigator.pop(context); // Закрываем диалог подтверждения
                  }
                }
              },
              child: const Text('Выйти', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}