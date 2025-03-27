import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String _dropdownMenuItem = 'Gym1';

  void _dropDownMenuItemChange(String? newValue) {
    if (newValue is String) {
      setState(() {
        _dropdownMenuItem = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black26, width: 1)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: const Center(child: Text('Choose')),
                    value: _dropdownMenuItem,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_downward),
                    onChanged: _dropDownMenuItemChange,
                    items: const [
                      DropdownMenuItem(
                          value: 'Gym1', child: Center(child: Text('Gym1'))),
                      DropdownMenuItem(
                          value: 'Gym2', child: Center(child: Text('Gym2'))),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   width: 1000,
            // ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.people),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 15,
      ),
      TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
      ),
    ]);
  }
}
