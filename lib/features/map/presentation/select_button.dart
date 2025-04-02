import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/map/domain/select_button_provider.dart';

class SelectButton extends ConsumerWidget {
  SelectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLeftSelected = ref.watch(selectButtonStateProvider);
    return Container(
      margin: EdgeInsets.only(right: 16, left: 16, bottom: 24),
      height: 72,
      decoration: BoxDecoration(
        color: Color(0xFF353a48), // TODO: использовать ресурсы цветов
        borderRadius: BorderRadius.circular(36),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment:
                 isLeftSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              // Позволяет взять значение ширины родителя
              widthFactor: 0.5,
              child: Container(
                margin: EdgeInsets.only(left: 4, right: 4),
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white, // TODO: использовать ресурсы цветов
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          // Сами кнопки
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectButtonStateProvider.notifier).selectLeft();
                  },
                  child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 300),
                        style: TextStyle(
                            color: isLeftSelected ? Color(0xFF353a48) : Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                        child: Text('Все'),
                  )
                      // child: Text(
                      //   'Все',
                      //   style: TextStyle(
                      //     // TODO: использовать ресурсы цветов
                      //     // TODO: использовать ресурсы текста
                      //     color: isLeftSelected ? Color(0xFF353a48) : Colors.white,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 24,
                      //   ),
                      // ),
                      ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectButtonStateProvider.notifier).selectRight();
                  },
                  child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 300),
                        style: TextStyle(
                          color: !isLeftSelected ? Color(0xFF353a48) : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                        child: Text('Избранные'),
                  )
                      // child: Text(
                      //   'Избранные',
                      //   style: TextStyle(
                      //     // TODO: использовать ресурсы цветов
                      //     // TODO: использовать ресурсы текста
                      //     color: !isLeftSelected ? Color(0xFF353a48) : Colors.white,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 24,
                      //   ),
                      // ),
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
