import 'package:flutter/material.dart';
import 'package:gymbro/features/calendar/domain/calendar_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GymsButtons extends StatefulWidget {
  final CalendarService service;
  const GymsButtons({super.key, required this.service});

  @override
  State<GymsButtons> createState() => _GymsButtonsState();
}

class _GymsButtonsState extends State<GymsButtons> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.service.selectedTrainingIndex = 0;
            });
          },
          child: Text(l10n.my),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.service.selectedTrainingIndex = 1;
            });
          },
          child: Text(l10n.gym),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.service.selectedTrainingIndex = 2;
            });
          },
          child: Text(l10n.all),
        ),
      ],
    );
  }
}
