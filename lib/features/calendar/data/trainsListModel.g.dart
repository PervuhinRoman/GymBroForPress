// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainsListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingList _$TrainingListFromJson(Map<String, dynamic> json) => TrainingList(
      date: DateTime.parse(json['date'] as String),
      trainings: (json['trainings'] as List<dynamic>)
          .map((e) => TrainingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingListToJson(TrainingList instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'trainings': instance.trainings.map((e) => e.toJson()).toList(),
    };
