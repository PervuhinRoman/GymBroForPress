import 'package:json_annotation/json_annotation.dart';

import './trainingModel.dart';

part 'trainsListModel.g.dart';

@JsonSerializable(explicitToJson: true)
class TrainingList {
  final DateTime date;
  final List<TrainingModel> trainings;

  TrainingList({
    required this.date,
    required this.trainings,
  });

  factory TrainingList.fromJson(Map<String, dynamic> json) =>
      _$TrainingListFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingListToJson(this);
}
