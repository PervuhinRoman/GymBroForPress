import 'package:json_annotation/json_annotation.dart';

part 'trainingModel.g.dart';

@JsonSerializable()
class TrainingModel {
  final DateTime time;
  final String description;

  TrainingModel({
    required this.time,
    required this.description,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingModelToJson(this);
}
