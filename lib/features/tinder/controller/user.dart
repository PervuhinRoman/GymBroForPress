import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String name;
  final String imageUrl;
  final String trainingTime;
  final String trainingDays;
  final String textInfo;
  final String trainType;
  final String contact;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.trainingTime,
    required this.trainingDays,
    required this.textInfo,
    required this.trainType,
    required this.contact,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['firebaseUid'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      trainingTime: json['time'],
      trainingDays: json['day'],
      textInfo: json['textInfo'],
      trainType: json['trainType'],
      contact: json['contact'],
    );
  }
}

final usersProvider = FutureProvider<List<User>>(
  (ref) async {
    final response =
        await http.get(Uri.parse('https://gymbro.serveo.net/api/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  },
);
