import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// AI refactored and checked after by myself
import 'user.dart';

class CardState {
  final int currentIndex;
  final double offsetX;
  final double opacity;
  final bool isVisible;

  CardState({
    this.currentIndex = 0,
    this.offsetX = 0.0,
    this.opacity = 1.0,
    this.isVisible = true,
  });

  CardState copyWith({
    int? currentIndex,
    double? offsetX,
    double? opacity,
    bool? isVisible,
  }) {
    return CardState(
      currentIndex: currentIndex ?? this.currentIndex,
      offsetX: offsetX ?? this.offsetX,
      opacity: opacity ?? this.opacity,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class CardStateNotifier extends StateNotifier<CardState> {
  CardStateNotifier() : super(CardState());

  void updateDragPosition(double? delta) {
    if (delta != null) {
      state = state.copyWith(offsetX: state.offsetX + delta);
    }
  }

  void resetCardPosition() {
    state = state.copyWith(offsetX: 0.0, opacity: 1.0);
  }

  void animateCardAway(bool isRightSwipe) {
    state = state.copyWith(
      offsetX: isRightSwipe ? 300.0 : -300.0,
      opacity: 0.0,
    );
  }

  void hideCard() {
    state = state.copyWith(isVisible: false);
  }

  void showNextCard(int totalCards) {
    state = CardState(
      currentIndex: (state.currentIndex + 1) % totalCards,
      offsetX: 0.0,
      opacity: 1.0,
      isVisible: true,
    );
  }
}

final cardStateProvider = StateNotifierProvider<CardStateNotifier, CardState>((ref) {
  return CardStateNotifier();
});

class SwipeRequest {
  final String swiperId;
  final String targetId;
  final bool isLike;

  SwipeRequest({
    required this.swiperId,
    required this.targetId,
    required this.isLike,
  });

  Map<String, dynamic> toJson() => {
        'swiperId': swiperId,
        'targetId': targetId,
        'isLike': isLike,
      };
}

class SwipeResult {
  final bool isMatch;
  final bool hasError;
  final String errorMessage;
  final User? matchedUser;

  SwipeResult({
    this.isMatch = false,
    this.hasError = false,
    this.errorMessage = '',
    this.matchedUser,
  });
}

class MatchHistoryController {
  static const String _shownMatchesKey = 'shown_matches';
  final Set<String> _shownMatchIds = {};
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await _loadShownMatches();
    _initialized = true;
  }

  Future<void> _loadShownMatches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final matches = prefs.getStringList(_shownMatchesKey) ?? [];
      _shownMatchIds.addAll(matches);
    } catch (e) {
      print('Error loading shown matches: $e');
    }
  }

  Future<void> _saveShownMatches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_shownMatchesKey, _shownMatchIds.toList());
    } catch (e) {
      print('Error saving shown matches: $e');
    }
  }

  bool isMatchShown(String matchId) {
    return _shownMatchIds.contains(matchId);
  }

  Future<void> markMatchAsShown(String matchId) async {
    if (!_initialized) await initialize();
    if (!_shownMatchIds.contains(matchId)) {
      _shownMatchIds.add(matchId);
      await _saveShownMatches();
    }
  }

  Future<void> clearShownMatches() async {
    _shownMatchIds.clear();
    await _saveShownMatches();
  }
}

final swipeProvider = FutureProvider.family<SwipeResult, SwipeRequest>((ref, request) async {
  try {
    final response = await http.post(
      Uri.parse('https://gymbro.serveo.net/api/swipe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final isMatch = responseData['isMatch'] == true;
      
      if (isMatch) {
        final matchId = responseData['match']['id']?.toString() ?? '';
        final matchHistoryController = MatchHistoryController();
        await matchHistoryController.initialize();
        
        if (!matchHistoryController.isMatchShown(matchId)) {
          await matchHistoryController.markMatchAsShown(matchId);
          
          final usersList = await ref.read(usersProvider.future);
          final matchedUser = usersList.firstWhere(
            (user) => 
              user.id == responseData['match']['user1Id'] || 
              user.id == responseData['match']['user2Id'],
            orElse: () => throw Exception('User not found'),
          );
          
          return SwipeResult(
            isMatch: true,
            matchedUser: matchedUser,
          );
        }
      }
      
      return SwipeResult(isMatch: false);
    } else {
      return SwipeResult(
        hasError: true,
        errorMessage: 'Server error: ${response.statusCode}',
      );
    }
  } catch (e) {
    return SwipeResult(
      hasError: true,
      errorMessage: e.toString(),
    );
  }
});
