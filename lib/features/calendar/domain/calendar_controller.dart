import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/utils/preference_service.dart';
import 'package:gymbro/core/widgets/training_template.dart';
import 'package:gymbro/features/calendar/bd.dart';
import 'package:gymbro/features/calendar/models/training_model.dart';
import 'package:gymbro/features/calendar/presentation/tags.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CalendarController {
  CalendarController() {
    PreferencesService.init();
  }

  int selectedTrainingIndex = 0;

  DateTime focusedDay = DateTime.parse(PreferencesService.getFocusedDay());
  DateTime selectedDay = DateTime.parse(PreferencesService.getFocusedDay());
  CalendarFormat calendarFormat = PreferencesService.getFormat();

  final newEventController = TextEditingController();
  final newTimeEventController = TextEditingController();

  Map<DateTime, List<TrainingTemplate>> events = {};

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void changeSelectedDay(DateTime day) {
    PreferencesService.setSelectedDay(DateFormat('yyyy-MM-dd').format(day));
    selectedDay = day;
  }

  void changeCalendarFormat(CalendarFormat format) {
    String formatString;
    if (format == CalendarFormat.month) {
      formatString = 'month';
    } else if (format == CalendarFormat.week) {
      formatString = 'week';
    } else {
      formatString = 'twoWeeks';
    }
    PreferencesService.setFormat(formatString);
    calendarFormat = format;
  }

  void changeFocusedDay(DateTime day) {
    PreferencesService.setFocusedDay(DateFormat('yyyy-MM-dd').format(day));
    focusedDay = day;
  }

  Future<void> loadAllEventsFromDB() async {
    // Получаем все события (без фильтра по дате)
    List<Training> trainings = await DatabaseHelper.instance.getAllTrainings();

    // Очищаем текущую карту событий
    events.clear();

    // Группируем события по дате
    for (var training in trainings) {
      final eventDay = normalizeDate(training.date);
      final template = TrainingTemplate(
        trainType: training.tag == 'my'
            ? TrainingType.my
            : training.tag == 'gym'
                ? TrainingType.gym
                : TrainingType.all,
        borderColor: AppColors.bluePale,
        mainColor: AppColors.violetPrimary,
        text: training.description,
        textTime: training.time,
      );

      if (events[eventDay] == null) {
        events[eventDay] = [template];
      } else {
        events[eventDay]!.add(template);
      }
    }
  }

  List<TrainingTemplate> getTrainingsByTag(TrainingType tag) {
    final dayEvents = events.keys.firstWhere(
      (d) => isSameDay(d, selectedDay),
      orElse: () => selectedDay,
    );

    if (tag == TrainingType.all) {
      return (events[dayEvents] ?? [])
        ..sort((a, b) => a.textTime.compareTo(b.textTime));
    }

    return (events[dayEvents] ?? [])
        .where((val) => val.trainType == tag)
        .toList()
      ..sort((a, b) => a.textTime.compareTo(b.textTime));
  }

  DateTime normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<Widget> buildTrainingListWithSpacing(List<Widget> widgets,
      {double spacing = 10}) {
    List<Widget> spacedWidgets = [];
    spacedWidgets.add(SizedBox(height: spacing));
    for (int i = 0; i < widgets.length; i++) {
      spacedWidgets.add(widgets[i]);
      if (i < widgets.length - 1) {
        spacedWidgets.add(SizedBox(height: spacing));
      }
    }
    return spacedWidgets;
  }

  final timeMaskFormatter = MaskTextInputFormatter(
    mask: '##:##',
    filter: {'#': RegExp(r'\d')},
  );

  double getCalendarHeightByFormat(CalendarFormat format, context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    switch (format) {
      case CalendarFormat.week:
        return screenHeight / 2.2;
      case CalendarFormat.twoWeeks:
        return screenHeight / 2.2;
      case CalendarFormat.month:
        return screenHeight / 2.2;
    }
  }

  List<TrainingTemplate> getTrainsForConcreteDay(DateTime day) {
    final normalizedDay = normalizeDate(day);
    return events[normalizedDay] ?? [];
  }

  List<String> gyms = [];

  void addGym(String gym) {
    gyms.add(gym);
  }

  String? selectedGym;

  Future<void> saveEvent() async {
    final modelMy = Training(
      date: normalizeDate(selectedDay),
      time: DateFormat('HH:mm').parse(newTimeEventController.text),
      description: newEventController.text,
      tag: 'my',
    );

    await DatabaseHelper.instance.create(modelMy);

    final newEvent = TrainingTemplate(
      trainType: TrainingType.my,
      borderColor: AppColors.bluePale,
      mainColor: AppColors.violetPrimary,
      text: modelMy.description,
      textTime: modelMy.time,
    );
    final normalizedDay = normalizeDate(selectedDay);
    events[normalizedDay] = [...(events[normalizedDay] ?? []), newEvent];
  }

  void dispose() {
    newEventController.dispose();
    newTimeEventController.dispose();
  }
}
