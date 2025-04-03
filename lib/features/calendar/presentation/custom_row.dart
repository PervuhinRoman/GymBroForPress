import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';

class CustomRowOfElements extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const CustomRowOfElements(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  State<CustomRowOfElements> createState() => _CustomRowOfElementsState();
}

class _CustomRowOfElementsState extends State<CustomRowOfElements> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.amber,
            ),
            height: widget.screenWidth / 2.7,
            width: widget.screenWidth / 2.7,
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.greenPrimary,
            ),
            height: widget.screenWidth / 2.7,
            width: widget.screenWidth / 2.7,
          ),
        )
      ],
    );
  }
}
