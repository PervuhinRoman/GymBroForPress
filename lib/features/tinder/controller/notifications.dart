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

class UserNotification {
  final String id;
  final User user;
  final DateTime dateTime;
  final bool isRead;
  final String message;

  UserNotification({
    required this.id,
    required this.user,
    required this.dateTime,
    this.isRead = false,
    required this.message,
  });

  UserNotification copyWith({
    String? id,
    User? user,
    DateTime? dateTime,
    bool? isRead,
    String? message,
  }) {
    return UserNotification(
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

  static UserNotification fromJson(Map<String, dynamic> json, Map<String, User> usersMap) {
    final userId = json['userId'] as String;
    final user = usersMap[userId];
    
    if (user == null) {
      throw Exception('User not found for notification');
    }
    
    return UserNotification(
      id: json['id'] as String,
      user: user,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime'] as int),
      isRead: json['isRead'] as bool,
      message: json['message'] as String,
    );
  }
}

class NotificationsState {
  final List<UserNotification> notifications;
  final bool isLoading;
  final String? error;
  final String? lastServerResponse;

  NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.lastServerResponse,
  });

  NotificationsState copyWith({
    List<UserNotification>? notifications,
    bool? isLoading,
    String? error,
    String? lastServerResponse,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastServerResponse: lastServerResponse ?? this.lastServerResponse,
    );
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}

class NotificationsController extends StateNotifier<NotificationsState> {
  NotificationsController(this.ref) : super(NotificationsState()) {
    _loadNotifications();
    loadMatchesFromServer();
  }

  final Ref ref;
  static const String _savedNotificationsKey = 'saved_user_notifications';
  static const String _serverUrl = 'https://gymbro.serveo.net/api';

  Future<void> _loadNotifications() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final users = await ref.read(usersProvider.future);
      final usersMap = {for (var user in users) user.id: user};
      
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList(_savedNotificationsKey) ?? [];
      
      if (notificationsJson.isEmpty) {
        state = state.copyWith(notifications: [], isLoading: false);
        return;
      }
      
      final notifications = notificationsJson
          .map((json) => UserNotification.fromJson(jsonDecode(json), usersMap))
          .toList();
      
      notifications.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      
      state = state.copyWith(notifications: notifications, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Error loading notifications: $e',
        isLoading: false,
      );
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = state.notifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();
      
      await prefs.setStringList(_savedNotificationsKey, notificationsJson);
    } catch (e) {
      print('Error saving notifications: $e');
    }
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
        Uri.parse('$_serverUrl/matches/$currentUserId'),
      ];
      
      String? responseBody;
      int statusCode = 400;
      
      for (var endpoint in endpointsToTry) {
        try {
          print('Trying GET endpoint: $endpoint');
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
      
      if (statusCode != 200 || responseBody == null) {
        state = state.copyWith(
          error: 'Failed to load matches: $statusCode',
          isLoading: false,
          lastServerResponse: 'Error: $statusCode - $responseBody',
        );
        return;
      }
      
      state = state.copyWith(lastServerResponse: responseBody);
      print('Matches response: $responseBody');
      
      final dynamic matchesData;
      try {
        matchesData = jsonDecode(responseBody);
      } catch (e) {
        print('JSON decode error: $e');
        state = state.copyWith(
          error: 'Invalid JSON response: $e',
          isLoading: false,
        );
        return;
      }
      
      List<Map<String, dynamic>> matchMaps = [];
      
      if (matchesData is List) {
        for (var item in matchesData) {
          if (item is Map<String, dynamic>) {
            matchMaps.add(item);
          }
        }
      } else if (matchesData is Map) {
        if (matchesData.containsKey('matches') && matchesData['matches'] is List) {
          for (var item in matchesData['matches']) {
            if (item is Map<String, dynamic>) {
              matchMaps.add(item);
            }
          }
        } else {
          if (matchesData.containsKey('user1Id') && matchesData.containsKey('user2Id')) {
            matchMaps.add(matchesData as Map<String, dynamic>);
          } else {
            matchesData.forEach((key, value) {
              if (value is Map<String, dynamic> && 
                  value.containsKey('user1Id') && 
                  value.containsKey('user2Id')) {
                matchMaps.add(value);
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
      }
      
      print('Extracted ${matchMaps.length} match objects');
      
      if (matchMaps.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }
      
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
      
      final userMatches = matches.where((match) => 
          match.user1Id == currentUserId || match.user2Id == currentUserId).toList();
      
      print('Found ${userMatches.length} matches for user $currentUserId');
      
      if (userMatches.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }
      
      final users = await ref.read(usersProvider.future);
      print('Loaded ${users.length} users');
      
      final usersMap = {for (var user in users) user.id: user};
      
      print('Available user IDs: ${usersMap.keys.join(', ')}');
      
      for (var match in userMatches) {
        final partnerId = match.user1Id == currentUserId ? match.user2Id : match.user1Id;
        
        if (partnerId == currentUserId) {
          print('Skipping self-match for user $currentUserId');
          continue;
        }
        
        print('Processing match with partner ID: $partnerId');
        
        final matchedUser = usersMap[partnerId];
        if (matchedUser != null) {
          final existingNotificationIndex = state.notifications
              .indexWhere((notification) => notification.user.id == partnerId);
          
          if (existingNotificationIndex == -1) {
            print('Creating notification for match with user $partnerId (${matchedUser.name})');
            final notification = UserNotification(
              id: 'match_${partnerId}_${DateTime.now().millisecondsSinceEpoch}',
              user: matchedUser,
              dateTime: DateTime.now(),
              message: 'Вы нашли тренировочного партнера! ${matchedUser.name} также хочет тренироваться с вами.',
            );
            
            final updatedNotifications = [...state.notifications, notification];
            state = state.copyWith(
              notifications: updatedNotifications,
              error: null,
            );
          } else {
            print('Notification for user $partnerId already exists');
          }
        } else {
          print('WARNING: User $partnerId not found in users list');
        }
      }
      
      final sortedNotifications = [...state.notifications]
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
      
      state = state.copyWith(
        notifications: sortedNotifications,
        isLoading: false,
      );
      
      await _saveNotifications();
    } catch (e) {
      print('Error loading matches: $e');
      state = state.copyWith(
        error: 'Error loading matches: $e',
        isLoading: false,
      );
    }
  }

  Future<void> addNotification(UserNotification notification) async {
    final updatedNotifications = [...state.notifications, notification];
    state = state.copyWith(notifications: updatedNotifications);
    await _saveNotifications();
  }

  Future<void> markAsRead(String notificationId) async {
    final updatedNotifications = state.notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
    
    state = state.copyWith(notifications: updatedNotifications);
    await _saveNotifications();
  }

  Future<void> markAllAsRead() async {
    final updatedNotifications = state.notifications.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();
    
    state = state.copyWith(notifications: updatedNotifications);
    await _saveNotifications();
  }

  Future<void> ensureNotificationsStateConsistency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getStringList(_savedNotificationsKey) ?? [];
      
      if (savedJson.isEmpty) {
        await _saveNotifications();
        return;
      }
      
      bool needsUpdate = false;
      final users = await ref.read(usersProvider.future);
      final usersMap = {for (var user in users) user.id: user};
      
      List<UserNotification> savedNotifications = [];
      for (var json in savedJson) {
        try {
          final decoded = jsonDecode(json);
          if (usersMap.containsKey(decoded['userId'])) {
            savedNotifications.add(UserNotification.fromJson(decoded, usersMap));
          }
        } catch (e) {
          print('Error parsing saved notification: $e');
        }
      }
      
      if (savedNotifications.length != state.notifications.length) {
        needsUpdate = true;
      } else {
        final Map<String, bool> stateReadStatus = {
          for (var n in state.notifications) n.id: n.isRead
        };
        final Map<String, bool> savedReadStatus = {
          for (var n in savedNotifications) n.id: n.isRead
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
          for (var n in savedNotifications) n.id: n.isRead
        };
        
        final updatedNotifications = state.notifications.map((notification) {
          if (savedReadStatus.containsKey(notification.id)) {
            return notification.copyWith(isRead: savedReadStatus[notification.id]);
          }
          return notification;
        }).toList();
        
        state = state.copyWith(notifications: updatedNotifications);
      }
      
      await _saveNotifications();
    } catch (e) {
      print('Error ensuring notification state consistency: $e');
    }
  }

  Future<void> removeNotification(String notificationId) async {
    final updatedNotifications = state.notifications
        .where((notification) => notification.id != notificationId)
        .toList();
    
    state = state.copyWith(notifications: updatedNotifications);
    await _saveNotifications();
  }

  Future<void> clearAll() async {
    state = state.copyWith(notifications: []);
    await _saveNotifications();
  }

  Future<void> refresh() async {
    await _loadNotifications();
    await loadMatchesFromServer();
  }

  Future<void> createTestNotification(User user) async {
    final notification = UserNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      user: user,
      dateTime: DateTime.now(),
      isRead: false,
      message: 'Новое совпадение с ${user.name}!',
    );
    
    await addNotification(notification);
  }
}

final notificationsControllerProvider = StateNotifierProvider<NotificationsController, NotificationsState>((ref) {
  return NotificationsController(ref);
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsControllerProvider).unreadCount;
});