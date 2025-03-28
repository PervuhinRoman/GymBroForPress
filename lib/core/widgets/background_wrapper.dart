import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final double? topBranchWidth;
  final double? bottomBranchWidth;
  final EdgeInsets? topBranchPadding;
  final EdgeInsets? bottomBranchPadding;

  const BackgroundWrapper({
    super.key,
    required this.child,
    this.topBranchWidth,
    this.bottomBranchWidth,
    this.topBranchPadding,
    this.bottomBranchPadding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Верхняя ветка
        Positioned(
          top: topBranchPadding?.top ?? 0,
          left: topBranchPadding?.left ?? 0,
          child: Image.asset(
            'assets/images/top_branch.png',
            width: topBranchWidth ?? screenWidth * 0.5,
          ),
        ),
        // Нижняя ветка
        Positioned(
          bottom: bottomBranchPadding?.bottom ?? 0,
          right: bottomBranchPadding?.right ?? 0,
          child: Image.asset(
            'assets/images/bottom_branch.png',
            width: bottomBranchWidth ?? screenWidth * 0.5,
          ),
        ),
        // Основной контент с прозрачным фоном
        child,
      ],
    );
  }
}
