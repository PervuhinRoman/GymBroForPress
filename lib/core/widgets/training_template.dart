import 'package:flutter/material.dart';
import 'package:gymbro/features/calendar/presentation/tags.dart';
import 'package:intl/intl.dart';

class TrainingTemplate extends StatefulWidget {
  final String text;
  final DateTime textTime;
  final Color mainColor;
  final Color borderColor;
  final TrainingType trainType;
  const TrainingTemplate(
      {super.key,
      required this.text,
      required this.textTime,
      required this.borderColor,
      required this.mainColor,
      required this.trainType});

  @override
  State<TrainingTemplate> createState() => _TrainingTemplateState();
}

class _TrainingTemplateState extends State<TrainingTemplate> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      width: screenWidth * 0.9,
      // height: screenHeight / 5,
      decoration: BoxDecoration(
        color: widget.mainColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('HH:mm').format(widget.textTime),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(widget.text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
