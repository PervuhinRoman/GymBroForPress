import 'package:flutter/material.dart';

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
        return Colors.blue.shade100;
      case TagCategory.hours:
        return Colors.grey.shade300;
      case TagCategory.days:
        return Colors.green.shade100;
      case TagCategory.textInfo:
        return Colors.red.shade100;
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
