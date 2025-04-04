import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';

// AI generated, human checked

class PercentageIndicator extends StatelessWidget {
  final int percentage;
  final String title;
  final String subtitle;
  final double height;
  final double width;
  final double borderRadius;
  final Color? fillColor;
  final Color? backgroundColor;
  final double? fontSize;

  const PercentageIndicator({
    Key? key,
    required this.percentage,
    this.title = 'Загруженность',
    this.subtitle = 'Рекомендация',
    this.height = 160,
    this.width = 160,
    this.borderRadius = 32,
    this.fillColor,
    this.backgroundColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHigh = percentage >= 50;
    final actualFillColor = fillColor ??
        (isHigh ? AppColors.constantError : AppColors.greenPrimary);
    final actualBgColor = backgroundColor ?? AppColors.violetPaleX2;

    final fillHeight = height * (percentage / 100);

    // Адаптивные размеры шрифта
    final percentageFontSize = fontSize ?? (height / 4);

    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: actualBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          // Заполненная часть индикатора
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fillHeight,
            child: Container(
              decoration: BoxDecoration(
                color: actualFillColor,
              ),
            ),
          ),

          // Колонка с текстом
          FittedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: height * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Процент
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: percentageFontSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3B3B3B),
                        height: 1.0,
                      ),
                    ),
                  ),

                  // Заголовок (жирный)
                  if (title.isNotEmpty) ...[
                    Text(title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],

                  // Подзаголовок (обычный)
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: height * 0.01),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}