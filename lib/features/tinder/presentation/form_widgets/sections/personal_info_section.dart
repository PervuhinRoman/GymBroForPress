import 'package:flutter/material.dart';
import '../form_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController personalInfoController;

  const PersonalInfoSection({
    super.key,
    required this.nameController,
    required this.personalInfoController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NameInputField(controller: nameController),
            const SizedBox(height: 16),
            AboutMeInputField(controller: personalInfoController),
          ],
        ),
      ),
    );
  }
}

class NameInputField extends StatelessWidget {
  final TextEditingController controller;

  const NameInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FormInputField(
      controller: controller,
      label: l10n.name,
      prefixIcon: Icons.person,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterName;
        }
        return null;
      },
    );
  }
}

class AboutMeInputField extends StatelessWidget {
  final TextEditingController controller;

  const AboutMeInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FormInputField(
      controller: controller,
      label: l10n.aboutMe,
      prefixIcon: Icons.info_outline,
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.tellAboutYourself;
        }
        return null;
      },
    );
  }
}
