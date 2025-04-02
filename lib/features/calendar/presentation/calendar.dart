import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/features/calendar/data/trainingModel.dart';
import 'package:gymbro/features/calendar/domain/calendar_controller.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'tags.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final controller = CalendarController();

  late double _calendarHeight =
      controller.getCalendarHeightByFormat(controller.calendarFormat, context);

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      controller.selectedDay = selectedDay;
      controller.focusedDay = focusedDay;
    });
  }

  @override
  void dispose() {
    controller.dispose(); // важно для освобождения ресурсов
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // controller.addGym("gym");
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    List<Widget> currentTrainings = [];
    if (controller.selectedTrainingIndex == 0) {
      currentTrainings = controller.getTrainingsByTag(TrainingType.my);
    } else if (controller.selectedTrainingIndex == 1) {
      currentTrainings = controller.getTrainingsByTag(TrainingType.gym);
    } else {
      currentTrainings = controller.getTrainingsByTag(TrainingType.all);
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
                        controller: controller.newTimeEventController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [controller.timeMaskFormatter],
                        decoration: InputDecoration(
                          hintText: l10n.hhmm,
                          hintStyle: TextStyle(color: AppColors.violetPale),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: controller.newEventController,
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
                      if (controller.newEventController.text.isNotEmpty &&
                          controller.newTimeEventController.text.isNotEmpty) {
                        setState(() {
                          controller.saveEvent();
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
              automaticallyImplyLeading: false,
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
                                  value: controller.selectedGym,
                                  isExpanded: true,
                                  icon: Transform.translate(
                                    offset: Offset(-20, 0),
                                    child:
                                        const Icon(Icons.keyboard_arrow_down),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      controller.selectedGym = value;
                                    });
                                  },
                                  //оставил специально из за l10n
                                  items: controller.gyms.isEmpty
                                      ? [
                                          DropdownMenuItem(
                                            value: null,
                                            child: Center(
                                                child: Text(l10n.choose)),
                                          )
                                        ]
                                      : controller.gyms.map((String value) {
                                          return DropdownMenuItem<String?>(
                                            value: value,
                                            child: Center(child: Text(value)),
                                          );
                                        }).toList(),
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
                                  controller.calendarFormat =
                                      CalendarFormat.twoWeeks;
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
              automaticallyImplyLeading: false,
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
                      value: controller.calendarFormat,
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
                            controller.calendarFormat = format;
                            _calendarHeight = controller
                                .getCalendarHeightByFormat(format, context);
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
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
                                isSameDay(controller.selectedDay, day),
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
                            calendarFormat: controller.calendarFormat,
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: controller.focusedDay,
                            rowHeight: 35,
                            availableGestures:
                                AvailableGestures.horizontalSwipe,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            onDaySelected: _onDaySelected,
                            eventLoader: controller.getTrainsForConcreteDay,
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                            onPageChanged: (focusedDay) {
                              controller.focusedDay = focusedDay;
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
              automaticallyImplyLeading: false,
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
                          controller.selectedTrainingIndex = 0;
                        });
                      },
                      child: Text(l10n.my),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.selectedTrainingIndex = 1;
                        });
                      },
                      child: Text(l10n.gym),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.selectedTrainingIndex = 2;
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
                        children: controller
                            .buildTrainingListWithSpacing(currentTrainings),
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
