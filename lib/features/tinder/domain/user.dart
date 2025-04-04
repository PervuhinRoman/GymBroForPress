import 'dart:convert';
import 'dart:async';

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

class UsersState {
  final List<User> users;
  final bool isLoading;
  final String? error;
  final DateTime lastUpdated;

  UsersState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  UsersState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class UsersController extends StateNotifier<UsersState> {
  UsersController() : super(UsersState()) {
    fetchUsers();
    _setupTimer();
  }

  Timer? _timer;

  void _setupTimer() {
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      fetchUsers();
    });
  }

  Future<void> refresh() async {
    await fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await http.get(Uri.parse('https://gymbro.serveo.net/api/users'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final users = data.map((json) => User.fromJson(json)).toList();
        
        state = state.copyWith(
          users: users,
          isLoading: false,
          lastUpdated: DateTime.now(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Server returned ${response.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final usersControllerProvider = StateNotifierProvider<UsersController, UsersState>((ref) {
  return UsersController();
});

final usersProvider = FutureProvider<List<User>>((ref) async {
  final state = ref.watch(usersControllerProvider);
  
  if (state.error != null) {
    throw Exception(state.error);
  }
  
  if (state.users.isNotEmpty) {
    return state.users;
  }
  
  await ref.read(usersControllerProvider.notifier).fetchUsers();
  return ref.read(usersControllerProvider).users;
});
