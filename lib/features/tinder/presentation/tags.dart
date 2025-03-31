import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/theme/app_colors.dart';

import '../../../core/utils/constants.dart';

enum TagCategory { trainType, hours, days, textInfo }

class Tag extends ConsumerWidget {
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
        return AppColors.violetPale;
      case TagCategory.days:
        return AppColors.greenSecondary;
      case TagCategory.textInfo:
        return AppColors.redPale;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var constants = ref.read(constantsProvider);
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(constants.paddingUnit),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
