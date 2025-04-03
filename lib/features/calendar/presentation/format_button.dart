import 'package:flutter/material.dart';
import 'package:gymbro/features/calendar/domain/calendar_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormatButton extends StatefulWidget {
  final CalendarService service;
  const FormatButton({super.key, required this.service});

  @override
  State<FormatButton> createState() => _FormatButtonState();
}

class _FormatButtonState extends State<FormatButton> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButton(
      icon: Icon(
        Icons.keyboard_arrow_down,
      ),
      hint: Center(child: Text(l10n.choose)),
      value: widget.service.calendarFormat,
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
            widget.service.changeCalendarFormat(format);
          });
        }
      },
    );
  }
}
