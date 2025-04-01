import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: ProfileScreen(),
    ),
  );
}
