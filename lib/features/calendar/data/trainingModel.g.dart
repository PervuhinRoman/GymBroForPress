// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingModel _$TrainingModelFromJson(Map<String, dynamic> json) =>
    TrainingModel(
      time: DateTime.parse(json['time'] as String),
      description: json['description'] as String,
    );

Map<String, dynamic> _$TrainingModelToJson(TrainingModel instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'description': instance.description,
    };
