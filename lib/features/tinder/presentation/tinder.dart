import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../controller/user.dart' as u;
import 'match_pop_up.dart';
import 'tinder_ui_components.dart';

class TinderScreen extends ConsumerStatefulWidget {
  const TinderScreen({super.key});

  @override
  _TinderScreenState createState() => _TinderScreenState();
}

class _TinderScreenState extends ConsumerState<TinderScreen> {
  int currentIndex = 0;
  double offsetX = 0.0;
  double opacity = 1.0;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(u.usersProvider);

    return Scaffold(
      body: usersAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(error: error.toString()),
        data: (users) {
          if (users.isEmpty) {
            return const EmptyStateDisplay();
          }

          return TinderCardStack(
            users: users,
            currentIndex: currentIndex,
            offsetX: offsetX,
            opacity: opacity,
            isVisible: isVisible,
            onHorizontalDragUpdate: (details) {
              setState(() {
                offsetX += details.primaryDelta ?? 0;
              });
            },
            onHorizontalDragEnd: (details) {
              if (offsetX.abs() > 150) {
                final isRightSwipe = offsetX > 0;
                animateCardAway(isRightSwipe);
              } else {
                resetCardPosition();
              }
            },
          );
        },
      ),
    );
  }

  void onSwipeComplete(bool isRightSwipe, List<u.User> users) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() {
      isVisible = false;
    });

    u.User? matchedUser;

    http.post(
      Uri.parse('https://gymbro.serveo.net/api/swipe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'swiperId': currentUser.uid,
          'targetId': users[currentIndex].id,
          'isLike': isRightSwipe,
        },
      ),
    ).then((response) {
      if (mounted && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['isMatch'] == true) {
          matchedUser = users.firstWhere(
            (u) =>
                u.id == responseData['match']['user1Id'] ||
                u.id == responseData['match']['user2Id'],
          );
          
          if (mounted && matchedUser != null) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => MatchPopup(matchedUser: matchedUser!),
            );
          }
        }
      }
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }).whenComplete(() {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          if (mounted) {
            setState(() {
              currentIndex = (currentIndex + 1) % users.length;
              offsetX = 0.0;
              opacity = 1.0;
              isVisible = true;
            });
          }
        },
      );
    });
  }

  void animateCardAway(bool isRightSwipe) {
    final users = ref.read(u.usersProvider).value;
    if (users == null) return;

    setState(
      () {
        offsetX = isRightSwipe ? 300.0 : -300.0;
        opacity = 0.0;
      },
    );

    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        onSwipeComplete(isRightSwipe, users);
      },
    );
  }

  void resetCardPosition() {
    setState(
      () {
        offsetX = 0.0;
        opacity = 1.0;
      },
    );
  }
}
