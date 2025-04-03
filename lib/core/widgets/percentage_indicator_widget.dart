import 'package:flutter/material.dart';

class PercentageIndicatorWidget extends StatelessWidget {
  final int percentage;
  final String title;
  final String subtitle;
  final double height;
  final double width;
  final double borderRadius;

  const PercentageIndicatorWidget({
    Key? key,
    required this.percentage,
    required this.title,
    required this.subtitle,
    this.height = 280,
    this.width = 300,
    this.borderRadius = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHigh = percentage >= 50;
    final fillColor = isHigh ? const Color(0xFFE95C5C) : Colors.green;
    final fillHeight = height * (percentage / 100);
    final bgColor = const Color(0xFFEAECFF); // Light lavender background

    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          // Fill container from bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fillHeight,
            child: Container(
              decoration: BoxDecoration(
                color: fillColor,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Percentage text
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B3B3B),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 24),
                // Title text
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B3B3B),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle text
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF3B3B3B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 