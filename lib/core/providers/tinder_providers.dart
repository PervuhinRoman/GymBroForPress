import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/tinder/domain/form_service.dart';

final formServiceProvider = FutureProvider<FormService>((ref) async {
  final auth = FirebaseAuth.instance;
  final prefs = await SharedPreferences.getInstance();
  return FormService(auth, prefs);
});

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
