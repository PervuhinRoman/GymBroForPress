import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymbro/core/utils/logger.dart';

class PreferencesService {
  static late SharedPreferences _preferences;
  
  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';
  
  static Future<void> init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      Logger.log.i('Preferences initialized');
    } catch (e) {
      Logger.log.e('Failed to initialize preferences: $e');
      rethrow;
    }
  }
  
  // Получение и сохранение языка
  static String? getLocale() {
    return _preferences.getString(_localeKey);
  }
  
  static Future<bool> setLocale(String locale) async {
    Logger.log.i('Setting locale to: $locale');
    return await _preferences.setString(_localeKey, locale);
  }
  
  // Получение и сохранение темы
  static int getThemeMode() {
    return _preferences.getInt(_themeModeKey) ?? 0; // 0 - система, 1 - светлая, 2 - темная
  }
  
  static Future<bool> setThemeMode(int themeMode) async {
    Logger.log.i('Setting theme mode to: $themeMode');
    return await _preferences.setInt(_themeModeKey, themeMode);
  }
}