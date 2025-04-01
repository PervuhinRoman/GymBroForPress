import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/theme/text_styles.dart';
import '../../../core/widgets/training_template.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'tags.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int _selectedTrainingIndex = 0;
  late double _calendarHeight =
      _getCalendarHeightByFormat(_calendarFormat, context);
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  final TextEditingController _newEventContriller = TextEditingController();
  final TextEditingController _newTimeEventContriller = TextEditingController();

  Map<DateTime, List<TrainingTemplate>> events = {};

  String? _selectedGym;
  List<String> _gyms = [];

  double _getCalendarHeightByFormat(CalendarFormat format, context) {
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

  List<TrainingTemplate> _getTrainsForConcreteDay(DateTime day) {
    final normalizedDay = normalizeDate(day);
    return events[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  final timeMaskFormatter = MaskTextInputFormatter(
    mask: '##:##',
    filter: {'#': RegExp(r'\d')},
  );

  List<TrainingTemplate> _getTrainingsByTag(TrainingType tag) {
    final dayEvents = events.keys.firstWhere(
      (d) => _isSameDay(d, _selectedDay),
      orElse: () => _selectedDay,
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

  List<Widget> _buildTrainingListWithSpacing(List<Widget> widgets,
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

  @override
  void dispose() {
    _newEventContriller.dispose();
    _newTimeEventContriller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadGyms();
    // _selectedValue = _gyms.first;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  void loadGyms() {
    setState(() {
      _gyms = ["Gym2", "Gym2", "Gym3"];
      _selectedGym = _gyms.isNotEmpty ? _gyms.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _selectedValue = _gyms.first;
    final l10n = AppLocalizations.of(context)!;
    List<Widget> currentTrainings = [];
    if (_selectedTrainingIndex == 0) {
      currentTrainings = _getTrainingsByTag(TrainingType.my);
    } else if (_selectedTrainingIndex == 1) {
      currentTrainings = _getTrainingsByTag(TrainingType.gym);
    } else {
      currentTrainings = _getTrainingsByTag(TrainingType.all);
    }
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Text(l10n.newTraining),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        controller: _newTimeEventContriller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [timeMaskFormatter],
                        decoration: InputDecoration(
                          hintText: l10n.hhmm,
                          hintStyle: TextStyle(color: AppColors.violetPale),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _newEventContriller,
                        decoration: InputDecoration(
                          hintText: l10n.description,
                          hintStyle: TextStyle(color: AppColors.violetPale),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (_newEventContriller.text.isNotEmpty &&
                          _newTimeEventContriller.text.isNotEmpty) {
                        final newEvent = TrainingTemplate(
                          trainType: TrainingType.my,
                          borderColor: AppColors.bluePale,
                          mainColor: AppColors.violetPrimary,
                          text: _newEventContriller.text,
                          textTime: DateFormat('HH:mm')
                              .parse(_newTimeEventContriller.text),
                        );

                        setState(() {
                          final normalizedDay = normalizeDate(_selectedDay);
                          events[normalizedDay] = [
                            ...(events[normalizedDay] ?? []),
                            newEvent
                          ];
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(l10n.submit),
                  ),
                ],
              );
            },
          );
        },
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: screenHeight / 3.5,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      width: 1)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: Center(child: Text(l10n.choose)),
                                  value: _selectedGym,
                                  isExpanded: true,
                                  icon: Transform.translate(
                                    offset: Offset(-20, 0),
                                    child:
                                        const Icon(Icons.keyboard_arrow_down),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGym = value;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem(
                                        value: 'Gym1',
                                        child: Center(child: Text('Gym1'))),
                                    DropdownMenuItem(
                                        value: 'Gym2',
                                        child: Center(child: Text('Gym2'))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth / 200),
                            child: IconButton(
                              icon: Icon(Icons.people),
                              onPressed: () {
                                setState(() {
                                  _calendarFormat = CalendarFormat.twoWeeks;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.amber,
                            ),
                            height: screenWidth / 2.7,
                            width: screenWidth / 2.7,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.greenPrimary,
                            ),
                            height: screenWidth / 2.7,
                            width: screenWidth / 2.7,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: screenHeight / 16,
              toolbarHeight: screenHeight / 16,
              elevation: 0,
              pinned: true,
              shadowColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      hint: Center(child: Text(l10n.choose)),
                      value: _calendarFormat,
                      items: [
                        DropdownMenuItem(
                          value: CalendarFormat.week,
                          child: Text(l10n.week),
                        ),
                        DropdownMenuItem(
                          value: CalendarFormat.twoWeeks,
                          child: Text(l10n.fortnight),
                        ),
                        DropdownMenuItem(
                          value: CalendarFormat.month,
                          child: Text(l10n.month),
                        ),
                      ],
                      onChanged: (format) {
                        if (format != null) {
                          setState(() {
                            _calendarFormat = format;
                            _calendarHeight =
                                _getCalendarHeightByFormat(format, context);
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: _calendarHeight - 100,
              toolbarHeight: _calendarHeight - 100,
              elevation: 0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Container(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor, // задаём фон, чтобы скрыть артефакты

                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20)),
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: ClipRect(
                          child: TableCalendar(
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            calendarStyle: CalendarStyle(
                              outsideDecoration: BoxDecoration(
                                color: AppColors
                                    .disabledText, // цвет выбранного дня
                                shape: BoxShape.circle,
                              ),
                              outsideTextStyle:
                                  TextStyle(color: AppColors.textSecondary),
                              selectedDecoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, // цвет выбранного дня
                                shape: BoxShape.circle, // форма выбранного дня
                              ),
                              selectedTextStyle: TextStyle(
                                  color: AppColors
                                      .primaryText // стиль текста выбранного дня
                                  ),
                            ),
                            formatAnimationDuration:
                                Duration(milliseconds: 100),
                            calendarFormat: _calendarFormat,
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: _focusedDay,
                            rowHeight: 35,
                            availableGestures:
                                AvailableGestures.horizontalSwipe,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            onDaySelected: _onDaySelected,
                            eventLoader: _getTrainsForConcreteDay,
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              // expandedHeight: _calendarHeight,
              toolbarHeight: screenHeight / 13,
              elevation: 0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTrainingIndex = 0;
                        });
                      },
                      child: Text(l10n.my),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTrainingIndex = 1;
                        });
                      },
                      child: Text(l10n.gym),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTrainingIndex = 2;
                        });
                      },
                      child: Text(l10n.all),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: screenHeight / 300),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Column(
                        children:
                            _buildTrainingListWithSpacing(currentTrainings),
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ),
            SliverFillRemaining(),
          ],
        ),
      ),
    );
  }
}
