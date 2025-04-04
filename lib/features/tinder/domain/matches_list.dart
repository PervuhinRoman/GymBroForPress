import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'user.dart';

class Match {
  final String user1Id;
  final String user2Id;

  Match({
    required this.user1Id,
    required this.user2Id,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      user1Id: json['user1Id'] as String,
      user2Id: json['user2Id'] as String,
    );
  }
}

class UserMatches {
  final String id;
  final User user;
  final DateTime dateTime;
  final bool isRead;
  final String message;

  UserMatches({
    required this.id,
    required this.user,
    required this.dateTime,
    this.isRead = false,
    required this.message,
  });

  UserMatches copyWith({
    String? id,
    User? user,
    DateTime? dateTime,
    bool? isRead,
    String? message,
  }) {
    return UserMatches(
      id: id ?? this.id,
      user: user ?? this.user,
      dateTime: dateTime ?? this.dateTime,
      isRead: isRead ?? this.isRead,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': user.id,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'isRead': isRead,
      'message': message,
    };
  }

  static UserMatches fromJson(Map<String, dynamic> json, Map<String, User> usersMap) {
    final userId = json['userId'] as String;
    final user = usersMap[userId];
    
    if (user == null) {
      throw Exception('User not found for match');
    }
    
    return UserMatches(
      id: json['id'] as String,
      user: user,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime'] as int),
      isRead: json['isRead'] as bool,
      message: json['message'] as String,
    );
  }
}

class UserMatchesState {
  final List<UserMatches> matches;
  final bool isLoading;
  final String? error;
  final String? lastServerResponse;

  UserMatchesState({
    this.matches = const [],
    this.isLoading = false,
    this.error,
    this.lastServerResponse,
  });

  UserMatchesState copyWith({
    List<UserMatches>? matches,
    bool? isLoading,
    String? error,
    String? lastServerResponse,
  }) {
    return UserMatchesState(
      matches: matches ?? this.matches,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastServerResponse: lastServerResponse ?? this.lastServerResponse,
    );
  }

  int get unreadCount => matches.where((n) => !n.isRead).length;
}

class MatchesController extends StateNotifier<UserMatchesState> {
  MatchesController(this.ref) : super(UserMatchesState()) {
    _loadMatches();
    loadMatchesFromServer();
  }

  final Ref ref;
  static const String _savedMatchesKey = 'saved_user_matches';
  static const String _serverUrl = 'https://gymbro.serveo.net/api';

  Future<void> _loadMatches() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final users = await ref.read(usersProvider.future);
      final usersMap = {for (var user in users) user.id: user};
      
      final prefs = await SharedPreferences.getInstance();
      final matchesJson = prefs.getStringList(_savedMatchesKey) ?? [];
      
      if (matchesJson.isEmpty) {
        state = state.copyWith(matches: [], isLoading: false);
        return;
      }
      
      final matches = matchesJson
          .map((json) => UserMatches.fromJson(jsonDecode(json), usersMap))
          .toList();
      
      matches.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      
      state = state.copyWith(matches: matches, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Error loading matches: $e',
        isLoading: false,
      );
    }
  }

  Future<void> _saveMatchesList() async {
      final prefs = await SharedPreferences.getInstance();
      final matchesJson = state.matches
          .map((match) => jsonEncode(match.toJson()))
          .toList();

      await prefs.setStringList(_savedMatchesKey, matchesJson);

  }

  Future<void> loadMatchesFromServer() async {
    state = state.copyWith(isLoading: true);

    try {
      final currentUser = firebase.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        state = state.copyWith(
          error: 'User not authenticated',
          isLoading: false,
        );
        return;
      }

      final currentUserId = currentUser.uid;

      final List<Uri> endpointsToTry = [
        Uri.parse('$_serverUrl/matches/$currentUserId'),  // путь с userId как часть пути
        Uri.parse('$_serverUrl/matches/user/$currentUserId'),  // альтернативный путь
        Uri.parse('$_serverUrl/matches?userId=$currentUserId'),  // с параметром userId
        Uri.parse('$_serverUrl/matches'),  // без параметров
      ];

      // Переменные для хранения ответа
      String? responseBody;
      int statusCode = 400;

      // Пробуем GET запросы
      for (var endpoint in endpointsToTry) {
        try {
          print('Trying endpoint: $endpoint');
          final response = await http.get(
            endpoint,
            headers: {'Content-Type': 'application/json'},
          );

          responseBody = response.body;
          statusCode = response.statusCode;

          if (statusCode == 200) {
            print('Success with endpoint: $endpoint');
            break;
          }
        } catch (e) {
          print('Error with endpoint $endpoint: $e');
        }
      }

      // Если GET запросы не сработали, пробуем POST запрос
      if (statusCode != 200 || responseBody == null) {
        try {
          print('Trying POST request to /matches');
          final response = await http.post(
            Uri.parse('$_serverUrl/matches'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'userId': currentUserId}),
          );

          responseBody = response.body;
          statusCode = response.statusCode;

          if (statusCode == 200) {
            print('Success with POST request');
          }
        } catch (e) {
          print('Error with POST request: $e');
        }
      }

      // Проверяем результат всех попыток
      if (statusCode != 200 || responseBody == null) {
        state = state.copyWith(
          error: 'Failed to load matches: $statusCode',
          isLoading: false,
          lastServerResponse: 'Error: $statusCode - $responseBody',
        );
        return;
      }

      // Сохраняем ответ для отладки
      state = state.copyWith(lastServerResponse: responseBody);
      print('Matches response: $responseBody');

      // Парсим JSON
      dynamic matchesData;
      try {
        matchesData = jsonDecode(responseBody);
      } catch (e) {
        state = state.copyWith(
          error: 'Invalid JSON response: $e',
          isLoading: false,
        );
        return;
      }

      // Извлекаем данные матчей из разных форматов ответа
      List<Map<String, dynamic>> matchMaps = [];

      if (matchesData is List) {
        // Если ответ - массив
        for (var item in matchesData) {
          if (item is Map<String, dynamic>) {
            matchMaps.add(item);
          }
        }
      } else if (matchesData is Map) {
        // Если ответ - объект с ключом 'matches'
        if (matchesData.containsKey('matches') && matchesData['matches'] is List) {
          for (var item in matchesData['matches']) {
            if (item is Map<String, dynamic>) {
              matchMaps.add(item);
            }
          }
        // Если ответ - объект, представляющий один матч
        } else if (matchesData.containsKey('user1Id') && matchesData.containsKey('user2Id')) {
          matchMaps.add(matchesData as Map<String, dynamic>);
        // Если ответ - объект с различными ключами
        } else {
          matchesData.forEach((key, value) {
            // Если значение - объект матча
            if (value is Map<String, dynamic> &&
                value.containsKey('user1Id') &&
                value.containsKey('user2Id')) {
              matchMaps.add(value);
            // Если значение - массив объектов
            } else if (value is List) {
              for (var item in value) {
                if (item is Map<String, dynamic> &&
                    item.containsKey('user1Id') &&
                    item.containsKey('user2Id')) {
                  matchMaps.add(item);
                }
              }
            }
          });
        }
      }

      print('Extracted ${matchMaps.length} match objects');

      if (matchMaps.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      // Создаем объекты матчей
      List<Match> matches = [];
      for (var matchMap in matchMaps) {
        try {
          if (matchMap.containsKey('user1Id') && matchMap.containsKey('user2Id')) {
            final user1Id = matchMap['user1Id'].toString();
            final user2Id = matchMap['user2Id'].toString();
            matches.add(Match(user1Id: user1Id, user2Id: user2Id));
          }
        } catch (e) {
          print('Error creating Match from $matchMap: $e');
        }
      }

      // Фильтруем матчи текущего пользователя
      final userMatches = matches.where((match) =>
          match.user1Id == currentUserId || match.user2Id == currentUserId).toList();

      print('Found ${userMatches.length} matches for user $currentUserId');

      if (userMatches.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      // Получаем информацию о пользователях
      final users = await ref.read(usersProvider.future);
      print('Loaded ${users.length} users');

      final usersMap = {for (var user in users) user.id: user};
      print('Available user IDs: ${usersMap.keys.join(', ')}');

      // Обрабатываем каждый матч
      for (var match in userMatches) {
        final partnerId = match.user1Id == currentUserId ? match.user2Id : match.user1Id;

        if (partnerId == currentUserId) {
          print('Skipping self-match for user $currentUserId');
          continue;
        }

        print('Processing match with partner ID: $partnerId');

        final matchedUser = usersMap[partnerId];
        if (matchedUser != null) {
          final existingMatchIndex = state.matches
              .indexWhere((match) => match.user.id == partnerId);

          if (existingMatchIndex == -1) {
            print('Creating match notification for user $partnerId (${matchedUser.name})');
            final match = UserMatches(
              id: 'match_${partnerId}_${DateTime.now().millisecondsSinceEpoch}',
              user: matchedUser,
              dateTime: DateTime.now(),
              message: 'Вы нашли тренировочного партнера! ${matchedUser.name} также хочет тренироваться с вами.',
            );

            final updatedMatches = [...state.matches, match];
            state = state.copyWith(
              matches: updatedMatches,
              error: null,
            );
          } else {
            print('Match for user $partnerId already exists');
          }
        } else {
          print('WARNING: User $partnerId not found in users list');
        }
      }

      // Сортируем матчи по времени
      final sortedMatches = [...state.matches]
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

      state = state.copyWith(
        matches: sortedMatches,
        isLoading: false,
      );

      await _saveMatchesList();
    } catch (e) {
      print('Error loading matches: $e');
      state = state.copyWith(
        error: 'Error loading matches: $e',
        isLoading: false,
      );
    }
  }

  Future<void> addMatch(UserMatches match) async {
    final updatedmatches = [...state.matches, match];
    state = state.copyWith(matches: updatedmatches);
    await _saveMatchesList();
  }

  Future<void> markAsRead(String matchId) async {
    final updatedmatches = state.matches.map((match) {
      if (match.id == matchId) {
        return match.copyWith(isRead: true);
      }
      return match;
    }).toList();

    state = state.copyWith(matches: updatedmatches);
    await _saveMatchesList();
  }

  Future<void> markAllAsRead() async {
    final updatedmatches = state.matches.map((match) {
      return match.copyWith(isRead: true);
    }).toList();

    state = state.copyWith(matches: updatedmatches);
    await _saveMatchesList();
  }

  // Новый метод для обработки совпадений, полученных от swipeProvider
  Future<void> processNewMatch(Map<String, dynamic> matchData) async {
    try {
      final currentUser = firebase.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return;
      }

      final currentUserId = currentUser.uid;

      // Проверка валидности данных матча
      if (!matchData.containsKey('user1Id') || !matchData.containsKey('user2Id')) {
        print('Некорректные данные матча: $matchData');
        return;
      }

      // Получаем ID партнера
      final user1Id = matchData['user1Id'].toString();
      final user2Id = matchData['user2Id'].toString();

      // Убеждаемся, что один из ID - это ID текущего пользователя
      if (user1Id != currentUserId && user2Id != currentUserId) {
        print('Матч не содержит текущего пользователя: $currentUserId');
        return;
      }

      // Определяем ID партнера
      final partnerId = user1Id == currentUserId ? user2Id : user1Id;

      // Получаем список пользователей и находим партнера
      final users = await ref.read(usersProvider.future);
      final usersMap = {for (var user in users) user.id: user};

      final matchedUser = usersMap[partnerId];
      if (matchedUser == null) {
        print('Партнер не найден: $partnerId');
        return;
      }

      // Проверяем, есть ли уже такой матч
      final existingMatchIndex = state.matches
          .indexWhere((match) => match.user.id == partnerId);

      if (existingMatchIndex == -1) {
        // Создаем новый матч
        final match = UserMatches(
          id: 'match_${partnerId}_${DateTime.now().millisecondsSinceEpoch}',
          user: matchedUser,
          dateTime: DateTime.now(),
          isRead: false,
          message: 'Вы нашли тренировочного партнера! ${matchedUser.name} также хочет тренироваться с вами.',
        );

        // Добавляем матч и сохраняем
        final updatedMatches = [...state.matches, match];
        state = state.copyWith(
          matches: updatedMatches,
          error: null,
        );

        // Сортируем
        final sortedMatches = [...state.matches]
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

        state = state.copyWith(matches: sortedMatches);
        await _saveMatchesList();
      } else {
        print('Матч с пользователем $partnerId уже существует');
      }
    } catch (e) {
      print('Ошибка при обработке нового матча: $e');
    }
  }

  Future<void> ensureMatchesStateConsistency() async {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getStringList(_savedMatchesKey) ?? [];

      if (savedJson.isEmpty) {
        await _saveMatchesList();
        return;
      }

      bool needsUpdate = false;
      final users = await ref.read(usersProvider.future);
      final usersMap = {for (var user in users) user.id: user};

      List<UserMatches> savedmatches = [];
      for (var json in savedJson) {
          final decoded = jsonDecode(json);
          if (usersMap.containsKey(decoded['userId'])) {
            savedmatches.add(UserMatches.fromJson(decoded, usersMap));
          }

      }

      if (savedmatches.length != state.matches.length) {
        needsUpdate = true;
      } else {
        final Map<String, bool> stateReadStatus = {
          for (var n in state.matches) n.id: n.isRead
        };
        final Map<String, bool> savedReadStatus = {
          for (var n in savedmatches) n.id: n.isRead
        };

        for (var id in stateReadStatus.keys) {
          if (savedReadStatus.containsKey(id) &&
              stateReadStatus[id] != savedReadStatus[id]) {
            needsUpdate = true;
            break;
          }
        }
      }

      if (needsUpdate) {
        final Map<String, bool> savedReadStatus = {
          for (var n in savedmatches) n.id: n.isRead
        };

        final updatedmatches = state.matches.map((match) {
          if (savedReadStatus.containsKey(match.id)) {
            return match.copyWith(isRead: savedReadStatus[match.id]);
          }
          return match;
        }).toList();

        state = state.copyWith(matches: updatedmatches);
      }

      await _saveMatchesList();

  }

  Future<void> removematch(String matchId) async {
    final updatedmatches = state.matches
        .where((match) => match.id != matchId)
        .toList();

    state = state.copyWith(matches: updatedmatches);
    await _saveMatchesList();
  }

  Future<void> clearAll() async {
    state = state.copyWith(matches: []);
    await _saveMatchesList();
  }

  Future<void> refresh() async {
    await _loadMatches();
    await loadMatchesFromServer();
  }

  Future<void> createTestMatch(User user) async {
    final match = UserMatches(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      user: user,
      dateTime: DateTime.now(),
      isRead: false,
      message: 'Новое совпадение с ${user.name}!',
    );
    
    await addMatch(match);
  }
}

final matchesControllerProvider = StateNotifierProvider<MatchesController, UserMatchesState>((ref) {
  return MatchesController(ref);
});

final unreadMatchesCountProvider = Provider<int>((ref) {
  return ref.watch(matchesControllerProvider).unreadCount;
});