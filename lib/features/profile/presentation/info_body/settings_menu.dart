import 'package:flutter/material.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/theme/app_theme.dart';
import 'package:gymbro/core/utils/routes.dart';
import 'package:gymbro/features/auth/domain/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  static const double sepPadding = 7.0; 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.settings),
      tooltip: AppLocalizations.of(context)!.showAppSettings,
      onPressed: () {
        _showSettings(context, ref);
      }
    );
  }

  Future<dynamic> _showSettings(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          final contextTheme = Theme.of(context);
          return SafeArea(
            child: Wrap(
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
                                l10n.changeLanguage, 
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
                                l10n.changeAppTheme,
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
                        TextButton(
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Theme.of(context).colorScheme.error,),
                              SizedBox(width: sepPadding,),
                              Text(
                                l10n.signOut,
                                style: contextTheme.textTheme.bodyMedium?.copyWith(
                                  color: contextTheme.colorScheme.onTertiary,
                                ), 
                              ),
                            ]
                          ),
                          onPressed: () async { 
                            await AuthService().signOut();
                            Navigator.popUntil(context, ModalRoute.withName(RouteNames.auth));
                            Navigator.pushNamed(context, RouteNames.auth);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      );
  }

  // Диалоговое окно для выбора темы
  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.selectAppTheme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.systemAppTheme),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(l10n.lightAppTheme),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(l10n.darkAppTheme),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.selectLanguage),
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