import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';

enum TagCategory { trainType, hours, days, textInfo }

class Tag extends StatelessWidget {
  final String text;
  final TagCategory category;

  const Tag({
    super.key,
    required this.text,
    this.category = TagCategory.textInfo,
  });

  Color _getBackgroundColor() {
    switch (category) {
      case TagCategory.trainType:
        return AppColors.bluePale;
      case TagCategory.hours:
        return  AppColors.violetPale;
      case TagCategory.days:
        return AppColors.greenSecondary;
      case TagCategory.textInfo:
        return  AppColors.redPale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
