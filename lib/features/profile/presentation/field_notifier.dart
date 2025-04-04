// file: field_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple state notifier to hold and update a text field value.
class FieldNotifier extends StateNotifier<String> {
  FieldNotifier(String state) : super(state);

  void update(String newValue) {
    state = newValue;
  }
}

/// Example providers for different fields:
final bioProvider = StateNotifierProvider<FieldNotifier, String>((ref) {
  return FieldNotifier('Мой личный статус.');
});

final phoneProvider = StateNotifierProvider<FieldNotifier, String>((ref) {
  return FieldNotifier('+7 800 555-35-35');
});

final tagProvider = StateNotifierProvider<FieldNotifier, String>((ref) {
  return FieldNotifier('@user');
});

// Notifier to control the global edit mode state
class EditModeNotifier extends StateNotifier<bool> {
  EditModeNotifier() : super(false);

  void toggleEditMode() {
    state = !state; // Toggle global edit mode state
  }

  void setEditMode(bool value) {
    state = value; // Explicitly set edit mode state
  }
}

// Riverpod provider
final editModeProvider = StateNotifierProvider<EditModeNotifier, bool>(
  (ref) => EditModeNotifier(),
);
