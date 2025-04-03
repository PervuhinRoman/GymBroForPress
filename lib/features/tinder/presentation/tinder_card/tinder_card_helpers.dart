import 'package:flutter/material.dart';

Color getContrastColor(Color background) {
  return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

IconData getTrainingIcon(String trainType) {
  final type = trainType.toLowerCase();
  if (type.contains('кардио') || type.contains('бег')) {
    return Icons.directions_run;
  } else if (type.contains('сила') || type.contains('силовая')) {
    return Icons.fitness_center;
  } else if (type.contains('йога') || type.contains('растяжка')) {
    return Icons.self_improvement;
  } else if (type.contains('функционал')) {
    return Icons.sports_gymnastics;
  } else if (type.contains('круговая')) {
    return Icons.loop;
  } else {
    return Icons.sports;
  }
}