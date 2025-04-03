import 'package:intl/intl.dart';

final tableDots = 'dots';

class DotFields {
  static final List<String> values = [longitude, latitude, id, isFavourite];
  static final String longitude = 'longitude';
  static final String latitude = 'latitude';
  static final String id = 'id';
  static final String isFavourite = 'isFavourite';
}

class DotOnMapModel {
  final String latitude;
  final String longitude;
  final String id;
  bool isFavourite;

  DotOnMapModel({
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.isFavourite,
  });

  DotOnMapModel copy(
          {String? longitude,
          String? latitude,
          String? id,
          bool? isFavourite}) =>
      DotOnMapModel(
          latitude: latitude ?? this.latitude,
          longitude: longitude ?? this.longitude,
          id: id ?? this.id,
          isFavourite: isFavourite ?? this.isFavourite);

  Map<String, dynamic> toJson() {
    return {
      DotFields.latitude: latitude,
      DotFields.longitude: longitude,
      DotFields.id: id,
      DotFields.isFavourite: isFavourite ? 1 : 0
    };
  }

  static DotOnMapModel fromJson(Map<String, dynamic> json) {
    return DotOnMapModel(
      longitude: json[DotFields.longitude] as String,
      latitude: json[DotFields.latitude] as String,
      id: json[DotFields.id] as String,
      isFavourite: json[DotFields.isFavourite] == 1,
    );
  }
}
