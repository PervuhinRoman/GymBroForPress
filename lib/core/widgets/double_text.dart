import 'package:flutter/material.dart';

class DoubleTextDisplay extends StatelessWidget {
  const DoubleTextDisplay({
    super.key,
    required this.topText,
    this.topStyle,
    this.topColor,

    required this.bottomText,
    this.bottomStyle,
    this.bottomColor,

    this.alignment = CrossAxisAlignment.start,
  });

  final String topText;
  final TextStyle? topStyle;
  final Color? topColor;

  final String bottomText;
  final TextStyle? bottomStyle;
  final Color? bottomColor;

  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 350, // KISS
            child: Text(
              topText,
              maxLines: null,
              style: topStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: topColor ?? Colors.black,
              ),
            ),
          ),
          Text(
            bottomText,
            style: bottomStyle ?? Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bottomColor ?? Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
