import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gymbro/features/tinder/presentation/form_widgets/sections/personal_info_section.dart';
import 'package:gymbro/features/tinder/presentation/form_widgets/save_button.dart';
import 'package:gymbro/features/tinder/presentation/form_widgets/sections/section_title.dart';
import 'package:gymbro/features/tinder/presentation/form_widgets/sections/training_preferences_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'sections/contact_section.dart';
import 'image_picker.dart';

class FormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final File? imageFile;
  final ValueChanged<File?> onImageChanged;
  final TextEditingController nameController;
  final TextEditingController trainTypeController;
  final TextEditingController hoursController;
  final TextEditingController daysController;
  final TextEditingController personalInfoController;
  final TextEditingController contactController;
  final VoidCallback onSave;
  final bool isLoading;

  const FormContent({super.key,
    required this.formKey,
    required this.imageFile,
    required this.onImageChanged,
    required this.nameController,
    required this.trainTypeController,
    required this.hoursController,
    required this.daysController,
    required this.personalInfoController,
    required this.contactController,
    required this.onSave,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileImagePicker(
              imageFile: imageFile,
              onImageChanged: onImageChanged,
            ),
            const SizedBox(height: 24),
            SectionTitle(title: l10n.personalInfo),
            PersonalInfoSection(
              nameController: nameController,
              personalInfoController: personalInfoController,
            ),
            const SizedBox(height: 20),
            SectionTitle(title: l10n.trainingPreferences),
            TrainingPreferencesSection(
              trainTypeController: trainTypeController,
              hoursController: hoursController,
              daysController: daysController,
            ),
            const SizedBox(height: 20),
            SectionTitle(title: l10n.contactInfo),
            ContactSection(contactController: contactController),
            const SizedBox(height: 32),
            SaveButton(
              onPressed: onSave,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
