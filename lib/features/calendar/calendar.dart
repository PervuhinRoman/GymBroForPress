import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/theme/text_styles.dart';
import 'package:gymbro/core/widgets/training_template.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'tegs.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String _dropdownMenuItem = 'Gym1';

  int _selectedTrainingIndex = 0;
  late double _calendarHeight =
      _getCalendarHeightByFormat(_calendarFormat, context);
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  final TextEditingController _newEventContriller = TextEditingController();
  final TextEditingController _newTimeEventContriller = TextEditingController();

  Map<DateTime, List<TrainingTemplate>> events = {};

  void _dropDownMenuItemChange(String? newValue) {
    if (newValue is String) {
      setState(() {
        _dropdownMenuItem = newValue;
      });
    }
  }

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
    print(events[day]);
    return events[day] ?? [];
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
    List<TrainingTemplate> myTrains = [];
    events.forEach((key, value) {
      for (var val in value) {
        if (val.trainType == tag) {
          myTrains.add(val);
        }
      }
    });
    myTrains.sort((a, b) => a.textTime.compareTo(b.textTime));
    return myTrains;
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
    // _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> currentTrainings = [];
    if (_selectedTrainingIndex == 0) {
      currentTrainings = _getTrainingsByTag(TrainingType.my);
    } else if (_selectedTrainingIndex == 1) {
      currentTrainings = _getTrainingsByTag(TrainingType.gym);
    } else {
      currentTrainings = _getTrainingsByTag(TrainingType.all);
    }
    print("curr index is $_selectedTrainingIndex");
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.violetPrimary,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Text('New training:'),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        style: AppTextStyles.robotoBold,
                        controller: _newTimeEventContriller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [timeMaskFormatter],
                        decoration: InputDecoration(
                          hintText: "ЧЧ:ММ",
                          hintStyle: TextStyle(color: AppColors.violetPale),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _newEventContriller,
                        decoration: InputDecoration(
                          hintText: "Описание",
                          hintStyle: TextStyle(color: AppColors.violetPale),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (_newEventContriller.text.isEmpty ||
                          _newTimeEventContriller.text.isEmpty) {
                      } else {
                        if (events[_selectedDay] != null) {
                          print("LETS GO");
                          events[_selectedDay]?.add(TrainingTemplate(
                            trainType: TrainingType.my,
                            borderColor: AppColors.greenPrimary,
                            mainColor: AppColors.greenSecondary,
                            text: _newEventContriller.text,
                            textTime: DateFormat("HH:mm")
                                .parse(_newTimeEventContriller.text),
                          ));
                          events[_selectedDay]?.add(TrainingTemplate(
                            trainType: TrainingType.all,
                            borderColor: AppColors.greenPrimary,
                            mainColor: AppColors.greenSecondary,
                            text: _newEventContriller.text,
                            textTime: DateFormat("HH:mm")
                                .parse(_newTimeEventContriller.text),
                          ));
                        } else {
                          print("new item");
                          events[_selectedDay] = [
                            TrainingTemplate(
                              trainType: TrainingType.my,
                              borderColor: AppColors.greenPrimary,
                              mainColor: AppColors.greenSecondary,
                              text: _newEventContriller.text,
                              textTime: DateFormat("HH:mm")
                                  .parse(_newTimeEventContriller.text),
                            )
                          ];
                          events[_selectedDay] = [
                            TrainingTemplate(
                              trainType: TrainingType.all,
                              borderColor: AppColors.greenPrimary,
                              mainColor: AppColors.greenSecondary,
                              text: _newEventContriller.text,
                              textTime: DateFormat("HH:mm")
                                  .parse(_newTimeEventContriller.text),
                            )
                          ];
                        }
                      }

                      Navigator.of(context).pop();
                    },
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          );
        },
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight / 3.5,
            backgroundColor: Colors.white,
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
                                    color: Colors.black26, width: 1)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: const Center(child: Text('Choose')),
                                value: _dropdownMenuItem,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_downward),
                                onChanged: _dropDownMenuItemChange,
                                items: const [
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
                    height: 15,
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
                          height: screenWidth / 2.5,
                          width: screenWidth / 2.5,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.greenPrimary,
                          ),
                          height: screenWidth / 2.5,
                          width: screenWidth / 2.5,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: screenHeight / 12,
            toolbarHeight: screenHeight / 12,
            elevation: 0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    icon: Icon(Icons.arrow_downward_outlined),
                    hint: const Center(child: Text('Choose')),
                    value: _calendarFormat,
                    items: [
                      DropdownMenuItem(
                        value: CalendarFormat.month,
                        child: Text('Месяц'),
                      ),
                      DropdownMenuItem(
                        value: CalendarFormat.twoWeeks,
                        child: Text('Две недели'),
                      ),
                      DropdownMenuItem(
                        value: CalendarFormat.week,
                        child: Text('Неделя'),
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
            backgroundColor: Colors.transparent,
            expandedHeight: _calendarHeight - 100,
            toolbarHeight: _calendarHeight - 60,
            elevation: 0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Container(
                  color: Colors.white, // задаём фон, чтобы скрыть артефакты

                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.greenSecondary,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black26, width: 1)),
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: TableCalendar(
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color:
                                AppColors.violetPrimary, // цвет выбранного дня
                            shape: BoxShape.circle, // форма выбранного дня
                          ),
                          selectedTextStyle: TextStyle(
                            color: AppColors
                                .violetPaleX2, // стиль текста выбранного дня
                          ),
                        ),
                        formatAnimationDuration: Duration(milliseconds: 100),
                        calendarFormat: _calendarFormat,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay,
                        rowHeight: 40,
                        availableGestures: AvailableGestures.horizontalSwipe,
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
          SliverAppBar(
            backgroundColor: Colors.white,
            // expandedHeight: _calendarHeight,
            toolbarHeight: screenHeight / 10,
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
                    child: const Text('Моё'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTrainingIndex = 1;
                      });
                    },
                    child: const Text('Зал'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTrainingIndex = 2;
                      });
                    },
                    child: const Text('Всё'),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(
                    children: _buildTrainingListWithSpacing(currentTrainings),
                  ),
                );
              },
              childCount: 1,
            ),
          ),
          SliverFillRemaining(),
        ],
      ),
    );
  }
}
