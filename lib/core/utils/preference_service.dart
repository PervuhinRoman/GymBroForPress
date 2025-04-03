import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymbro/core/utils/logger.dart';
import 'package:table_calendar/src/shared/utils.dart';

class PreferencesService {
  static late SharedPreferences _preferences;

  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';
  static const String _selectedDayKey = 'selected';
  static const String _focusedDayKey = 'focused';
  static const String _format = 'format';

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
    return _preferences.getInt(_themeModeKey) ??
        0; // 0 - система, 1 - светлая, 2 - темная
  }

  static Future<bool> setThemeMode(int themeMode) async {
    Logger.log.i('Setting day to: $themeMode');
    return await _preferences.setInt(_themeModeKey, themeMode);
  }

  static String getSelectedDay() {
    return _preferences.getString(_selectedDayKey) ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static Future<bool> setSelectedDay(String day) async {
    Logger.log.i('Setting selected day to: $day');
    return await _preferences.setString(_selectedDayKey, day);
  }

  static String getFocusedDay() {
    return _preferences.getString(_focusedDayKey) ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static Future<bool> setFocusedDay(String day) async {
    Logger.log.i('Setting focused day to: $day');
    return await _preferences.setString(_focusedDayKey, day);
  }

  static CalendarFormat getFormat() {
    final stringFormat = _preferences.getString(_format) ?? 'month';
    CalendarFormat ans;

    if (stringFormat == 'month') {
      ans = CalendarFormat.month;
    } else if (stringFormat == 'week') {
      ans = CalendarFormat.week;
    } else {
      ans = CalendarFormat.twoWeeks;
    }
    return ans;
  }

  static Future<bool> setFormat(String format) async {
    Logger.log.i('Setting format to: $format');
    return await _preferences.setString(_format, format);
  }
}
