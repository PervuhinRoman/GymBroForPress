import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/widgets/training_template.dart';
import 'package:gymbro/features/calendar/data/trainingModel.dart';
import 'package:gymbro/features/calendar/presentation/tags.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CalendarController {
  final prefs = SharedPreferences.getInstance();
  int selectedTrainingIndex = 0;

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

  final newEventController = TextEditingController();
  final newTimeEventController = TextEditingController();

  Map<DateTime, List<TrainingTemplate>> events = {};

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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

  void saveEvent() {
    final model = TrainingModel(
        time: DateFormat('HH:mm').parse(newTimeEventController.text),
        description: newEventController.text);
    final newEvent = TrainingTemplate(
      trainType: TrainingType.my,
      borderColor: AppColors.bluePale,
      mainColor: AppColors.violetPrimary,
      text: model.description,
      textTime: model.time,
    );
    final normalizedDay = normalizeDate(selectedDay);
    events[normalizedDay] = [...(events[normalizedDay] ?? []), newEvent];
  }

  void dispose() {
    newEventController.dispose();
    newTimeEventController.dispose();
  }
}
