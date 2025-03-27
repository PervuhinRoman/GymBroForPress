import 'package:flutter/material.dart';
import 'package:gymbro/core/widgets/custom_app_bar.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Регистрация'),
    );
  }
}