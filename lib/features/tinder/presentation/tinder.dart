import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:gymbro/features/tinder/presentation/tinder_card.dart';

final usersProvider = FutureProvider<List<User>>((ref) async {
  final response = await http.get(Uri.parse('https://5d4116670875e6e657f76b3ca78c219e.serveo.net/api/users'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
});

class User {
  final int id;
  final String imageUrl;
  final String time;
  final String day;
  final String textInfo;
  final String trainType;

  User({
    required this.id,
    required this.imageUrl,
    required this.time,
    required this.day,
    required this.textInfo,
    required this.trainType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      imageUrl: json['imageUrl'],
      time: json['time'],
      day: json['day'],
      textInfo: json['textInfo'],
      trainType: json['trainType'],
    );
  }
}

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
    final usersAsync = ref.watch(usersProvider);

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

  void onSwipeComplete(bool isRightSwipe, List<User> users) {
    setState(() {
      isVisible = false;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        currentIndex = (currentIndex + 1) % users.length;
        offsetX = 0.0;
        opacity = 1.0;
        isVisible = true;
      });
    });
  }

  void animateCardAway(bool isRightSwipe) {
    final users = ref.read(usersProvider).value;
    if (users == null) return;

    setState(() {
      offsetX = isRightSwipe ? 300.0 : -300.0;
      opacity = 0.0;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      onSwipeComplete(isRightSwipe, users);
    });
  }

  void resetCardPosition() {
    setState(() {
      offsetX = 0.0;
      opacity = 1.0;
    });
  }
}
