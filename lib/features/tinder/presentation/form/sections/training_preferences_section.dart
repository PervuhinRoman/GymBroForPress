import 'package:flutter/material.dart';
import '../form_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TrainingPreferencesSection extends StatelessWidget {
  final TextEditingController trainTypeController;
  final TextEditingController hoursController;
  final TextEditingController daysController;

  const TrainingPreferencesSection({super.key,
    required this.trainTypeController,
    required this.hoursController,
    required this.daysController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FormInputField(
              controller: trainTypeController,
              label: l10n.trainingType,
              prefixIcon: Icons.fitness_center,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.specifyTrainingType;
                }
                return null;
              },
            ),
            const SizedBox(height: 16), // spacer analogue
            FormInputField(
              controller: hoursController,
              label: l10n.trainingTime,
              prefixIcon: Icons.access_time,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.specifyConvenientTime;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FormInputField(
              controller: daysController,
              label: l10n.trainingDays,
              prefixIcon: Icons.calendar_today,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.specifyPreferredDays;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}