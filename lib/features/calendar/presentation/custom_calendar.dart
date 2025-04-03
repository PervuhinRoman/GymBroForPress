import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/features/calendar/domain/calendar_service.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCustomCalendar extends StatefulWidget {
  final CalendarService service;
  const MyCustomCalendar({super.key, required this.service});

  @override
  State<MyCustomCalendar> createState() => _MyCustomCalendarState();
}

class _MyCustomCalendarState extends State<MyCustomCalendar> {
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      widget.service.changeSelectedDay(selectedDay);
      widget.service.changeFocusedDay(focusedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      selectedDayPredicate: (day) => isSameDay(widget.service.selectedDay, day),
      calendarStyle: CalendarStyle(
        outsideDecoration: BoxDecoration(
          color: AppColors.disabledText, // цвет выбранного дня
          shape: BoxShape.circle,
        ),
        outsideTextStyle: TextStyle(color: AppColors.textSecondary),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary, // цвет выбранного дня
          shape: BoxShape.circle, // форма выбранного дня
        ),
        selectedTextStyle: TextStyle(
            color: AppColors.primaryText // стиль текста выбранного дня
            ),
      ),
      formatAnimationDuration: Duration(milliseconds: 100),
      calendarFormat: widget.service.calendarFormat,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: widget.service.focusedDay,
      rowHeight: 35,
      availableGestures: AvailableGestures.horizontalSwipe,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: _onDaySelected,
      eventLoader: widget.service.getTrainsForConcreteDay,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      onPageChanged: (focusedDay) {
        widget.service.focusedDay = focusedDay;
      },
    );
  }
}
