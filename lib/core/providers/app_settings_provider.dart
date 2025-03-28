import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gymbro/core/utils/preference_service.dart';

part 'app_settings_provider.g.dart';

// Класс для хранения настроек приложения
class AppSettings {
  final ThemeMode themeMode;
  final Locale? locale;

  const AppSettings({
    required this.themeMode,
    this.locale,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

@riverpod
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  AppSettings build() {
    // Загружаем настройки из хранилища при инициализации
    final themeModeIndex = PreferencesService.getThemeMode();
    final themeMode = ThemeMode.values[themeModeIndex];
    
    final savedLocale = PreferencesService.getLocale();
    final locale = savedLocale != null ? Locale(savedLocale) : null;
    
    return AppSettings(
      themeMode: themeMode,
      locale: locale,
    );
  }

  // Метод для изменения темы
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await PreferencesService.setThemeMode(themeMode.index);
  }

  // Метод для изменения языка
  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await PreferencesService.setLocale(locale.languageCode);
  }
}