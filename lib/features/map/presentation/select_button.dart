import 'package:flutter/material.dart';

class SelectButton extends StatefulWidget {
  const SelectButton({super.key});

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  bool isLeftSelected = true;

  @override
  Widget build(BuildContext context) {
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
                    setState(() {
                      isLeftSelected = true;
                    });
                  },
                  child: Center(
                    child: Text(
                      'Все',
                      style: TextStyle(
                        // TODO: использовать ресурсы цветов
                        // TODO: использовать ресурсы текста
                        color: isLeftSelected ? Color(0xFF353a48) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLeftSelected = false;
                    });
                  },
                  child: Center(
                    child: Text(
                      'Избранные',
                      style: TextStyle(
                        // TODO: использовать ресурсы цветов
                        // TODO: использовать ресурсы текста
                        color: !isLeftSelected ? Color(0xFF353a48) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
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
