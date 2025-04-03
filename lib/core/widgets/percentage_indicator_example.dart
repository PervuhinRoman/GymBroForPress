import 'package:flutter/material.dart';
import 'percentage_indicator_widget.dart';

class PercentageIndicatorExample extends StatelessWidget {
  const PercentageIndicatorExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Загруженность'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // Example with high percentage (red)
              PercentageIndicatorWidget(
                percentage: 83,
                title: 'Высокая загруженность',
                subtitle: 'Есть более свободные',
              ),
              SizedBox(height: 32),
              
              // Example with low percentage (green)
              PercentageIndicatorWidget(
                percentage: 32,
                title: 'Низкая загруженность',
                subtitle: 'Идеальное время',
              ),
              
              SizedBox(height: 32),
              
              // Example with exact 50% (red)
              PercentageIndicatorWidget(
                percentage: 50,
                title: 'Средняя загруженность',
                subtitle: 'Можно посетить',
              ),
              
              SizedBox(height: 32),
              
              // Example with 100% (fully filled)
              PercentageIndicatorWidget(
                percentage: 100,
                title: 'Максимальная загруженность',
                subtitle: 'Лучше не посещать',
              ),
            ],
          ),
        ),
      ),
    );
  }
} 