import 'package:logger/logger.dart' as logger_package;
import 'package:logger/web.dart';

class Logger {
  static late logger_package.Logger log;
  
  static void init() {
    log = logger_package.Logger(
      printer: logger_package.PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 60,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.none
      ),
      filter: _ProductionFilter(),
    );
  }
}

// Фильтр для логов в продакшне 
class _ProductionFilter extends logger_package.LogFilter {
  @override
  bool shouldLog(logger_package.LogEvent event) {
    // В режиме релиза будем логировать только ошибки и предупреждения
    bool shouldLog = true;
    return shouldLog;
  }
}