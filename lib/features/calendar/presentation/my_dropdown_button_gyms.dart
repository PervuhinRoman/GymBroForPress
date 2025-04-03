import 'package:flutter/material.dart';
import 'package:gymbro/features/calendar/domain/calendar_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyDropdownButtonGyms extends StatefulWidget {
  final CalendarService service;
  const MyDropdownButtonGyms({super.key, required this.service});

  @override
  State<MyDropdownButtonGyms> createState() => _MyDropdownButtonGymsState();
}

class _MyDropdownButtonGymsState extends State<MyDropdownButtonGyms> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Expanded(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface, width: 1)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: Center(child: Text(l10n.choose)),
                value: widget.service.selectedGym,
                isExpanded: true,
                icon: Transform.translate(
                  offset: Offset(-20, 0),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
                onChanged: (value) {
                  setState(() {
                    widget.service.selectedGym = value;
                  });
                },
                //оставил специально из за l10n
                items: widget.service.gyms.isEmpty
                    ? [
                        DropdownMenuItem(
                          value: null,
                          child: Center(child: Text(l10n.choose)),
                        )
                      ]
                    : widget.service.gyms.map((String value) {
                        return DropdownMenuItem<String?>(
                          value: value,
                          child: Center(child: Text(value)),
                        );
                      }).toList(),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
