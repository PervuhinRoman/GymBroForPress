import 'package:intl/intl.dart';

final tableTrainings = 'trainings';

class TrainingFields {
  static final List<String> values = [description, date, time, tag];
  static final String description = 'description';
  static final String time = 'time';
  static final String date = 'date';
  static final String tag = 'tag';
}

class Training {
  final String description;
  final DateTime date;
  final DateTime time;
  final String tag;

  Training({
    required this.description,
    required this.date,
    required this.time,
    required this.tag,
  });

  Training copy({
    String? description,
    DateTime? date,
    DateTime? time,
    String? tag,
  }) =>
      Training(
          description: description ?? this.description,
          date: date ?? this.date,
          time: time ?? this.time,
          tag: tag ?? this.tag);

  Map<String, dynamic> toJson() {
    return {
      TrainingFields.description: description,
      TrainingFields.date: DateFormat('yyyy-MM-dd').format(date),
      TrainingFields.time: DateFormat('HH:mm').format(time),
      TrainingFields.tag: tag
    };
  }

  static Training fromJson(Map<String, dynamic> json) {
    return Training(
      description: json[TrainingFields.description] as String,
      date: DateFormat('yyyy-MM-dd').parse(json[TrainingFields.date] as String),
      time: DateFormat('HH:mm').parse(json[TrainingFields.time] as String),
      tag: json[TrainingFields.tag] as String,
    );
  }
}
