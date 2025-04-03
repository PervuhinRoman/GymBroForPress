import 'package:flutter/material.dart';

import '../custom_text_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController personalInfoController;

  const PersonalInfoSection({
    required this.nameController,
    required this.personalInfoController,
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
              controller: nameController,
              label: l10n.name,
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FormInputField(
              controller: personalInfoController,
              label: l10n.aboutMe,
              prefixIcon: Icons.info_outline,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.tellAboutYourself;
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