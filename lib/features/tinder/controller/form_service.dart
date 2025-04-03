import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormService {
  final FirebaseAuth _auth;
  final SharedPreferences _prefs;

  FormService(this._auth, this._prefs);

  Future<void> saveFormData({
    required String name,
    required String trainType,
    required String hours,
    required String days,
    required String textInfo,
    required String contact,
    File? imageFile,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://gymbro.serveo.net/api/profiles'),
    );

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
    }

    request.fields.addAll({
      'name': name,
      'time': hours,
      'day': days,
      'textInfo': textInfo,
      'trainType': trainType,
      'firebaseUid': user.uid,
      'contact': contact,
    });

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Server error: $responseString');
    }

    await _prefs.setString('name', name);
    await _prefs.setString('trainType', trainType);
    await _prefs.setString('hours', hours);
    await _prefs.setString('days', days);
    await _prefs.setString('textInfo', textInfo);
    await _prefs.setString('contact', contact);
    if (imageFile != null) {
      await _prefs.setString('imagePath', imageFile.path);
    }
  }

  Future<Map<String, String>> loadFormData() async {
    return {
      'name': _prefs.getString('name') ?? '',
      'trainType': _prefs.getString('trainType') ?? '',
      'hours': _prefs.getString('hours') ?? '',
      'days': _prefs.getString('days') ?? '',
      'textInfo': _prefs.getString('textInfo') ?? '',
      'imagePath': _prefs.getString('imagePath') ?? '',
      'contact': _prefs.getString('contact') ?? '',
    };
  }
}

final formServiceProvider = FutureProvider<FormService>((ref) async {
  final auth = FirebaseAuth.instance;
  final prefs = await SharedPreferences.getInstance();
  return FormService(auth, prefs);
});

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
