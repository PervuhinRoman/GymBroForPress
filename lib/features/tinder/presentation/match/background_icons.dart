import 'package:flutter/material.dart';

class BackgroundIcons extends StatelessWidget {
  const BackgroundIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.fitness_center, size: 50, color: Colors.white),
                Icon(Icons.sports_gymnastics, size: 50, color: Colors.white),
                Icon(Icons.directions_run, size: 50, color: Colors.white),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.sports, size: 50, color: Colors.white),
                Icon(Icons.timer, size: 50, color: Colors.white),
                Icon(Icons.self_improvement, size: 50, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}