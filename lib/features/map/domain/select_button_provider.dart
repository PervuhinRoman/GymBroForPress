import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_button_provider.g.dart';

@riverpod
class SelectButtonState extends _$SelectButtonState {
  @override
  bool build() {
    return true;
  }

  void toggle() {
    state = !state;
  }

  void selectLeft() {
    state = true;
  }

  void selectRight() {
    state = false;
  }
}