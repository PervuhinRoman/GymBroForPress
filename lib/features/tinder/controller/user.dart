import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String name;
  final String imageUrl;
  final String time;
  final String day;
  final String textInfo;
  final String trainType;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.time,
    required this.day,
    required this.textInfo,
    required this.trainType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['firebaseUid'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      time: json['time'],
      day: json['day'],
      textInfo: json['textInfo'],
      trainType: json['trainType'],
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
