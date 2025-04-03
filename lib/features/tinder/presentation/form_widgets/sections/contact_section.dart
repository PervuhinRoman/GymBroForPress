import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../custom_text_input_field.dart';

class ContactSection extends StatelessWidget {
  final TextEditingController contactController;

  const ContactSection({super.key, required this.contactController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormInputField(
          controller: contactController,
          label: l10n.contactInfo,
          prefixIcon: Icons.contact_mail,
          helperText: l10n.contactForMatchHint,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.contactInfoRequired;
            }
            return null;
          },
        ),
      ),
    );
  }
}
