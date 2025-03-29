import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'tab_provider.g.dart';

class TabNotifier extends StateNotifier<int> {
  TabNotifier() : super(0); // Начальное значение - 0 (первая вкладка)

  // Метод для изменения активной вкладки
  void setTab(int index) {
    state = index;
  }
}

@riverpod
class Tab extends _$Tab {
  @override
  int build() {
    return 0; // Начальное значение
  }

  void setTab(int index) {
    state = index;
  }
}