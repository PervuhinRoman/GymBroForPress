import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/tinder/presentation/tinder_card.dart';
import 'package:http/http.dart' as http;

import '../controller/user.dart' as u;
import 'match_pop_up.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          return Center(
            child: Stack(
              children: [
                if (users.length > 1)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: TinderCard(
                        user: users[(currentIndex + 1) % users.length],
                      ),
                    ),
                  ),
                if (isVisible)
                  GestureDetector(
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
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      transform: Matrix4.translationValues(offsetX, 0, 0)
                        ..rotateZ(0.02 * offsetX / 150),
                      child: Opacity(
                        opacity: opacity,
                        child: TinderCard(user: users[currentIndex]),
                      ),
                    ),
                  ),
              ],
            ),
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

    Future(
      () async {
        try {
          final response = await http.post(
            Uri.parse('https://gymbro.serveo.net/api/swipe'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
              {
                'swiperId': currentUser.uid,
                'targetId': users[currentIndex].id,
                'isLike': isRightSwipe,
              },
            ),
          );

          if (mounted && response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            if (responseData['isMatch'] == true) {
              final matchedUser = users.firstWhere(
                (u) =>
                    u.id == responseData['match']['user1Id'] ||
                    u.id == responseData['match']['user2Id'],
              );

              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (ctx) => MatchPopup(matchedUser: matchedUser),
                    );
                  }
                },
              );
            }
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка: $e')),
            );
          }
        }
      },
    );

    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        if (mounted) {
          setState(
            () {
              currentIndex = (currentIndex + 1) % users.length;
              offsetX = 0.0;
              opacity = 1.0;
              isVisible = true;
            },
          );
        }
      },
    );
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
