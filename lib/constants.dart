import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final constantsProvider = Provider<Constants>((ref) {
  final mediaQuery = WidgetsBinding.instance.platformDispatcher.views.first;
  final screenHeight =
      mediaQuery.physicalSize.height / mediaQuery.devicePixelRatio;
  final screenWidth =
      mediaQuery.physicalSize.width / mediaQuery.devicePixelRatio;

  final paddingUnit = screenHeight / 49;

  return Constants(
      paddingUnit: paddingUnit,
      screenHeight: screenHeight,
      screenWidth: screenWidth);
});

class Constants {
  final double paddingUnit;
  final double screenHeight;
  final double screenWidth;

  const Constants(
      {required this.paddingUnit,
      required this.screenHeight,
      required this.screenWidth});

  static const double headerHeight = 9;
  static const double topNavigationBarHeight = 6;
  static const double bottomNavigationBarHeight = 7;
  static const Duration dAnimationDuration = Duration(milliseconds: 250);
  static const String serverAddress = 'http://85.192.32.240:8080';
  static const Duration networkTimeout = Duration(seconds: 5);
}
