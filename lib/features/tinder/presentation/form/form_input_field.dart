import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? prefixIcon;
  final String? helperText;
  final int maxLines;
  final String? Function(String?)? validator;

  const FormInputField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.helperText,
    this.maxLines = 1,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        helperText: helperText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50.withValues(alpha: 0.44),
      ),
      validator: validator,
    );
  }
}
