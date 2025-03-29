import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/tinder/tinderCard.dart';

class ApiConfig {
  static const baseUrl = 'http://10.0.2.2:8080';
}

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
      imageUrl: '${ApiConfig.baseUrl}/${json['imageUrl']}',
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
  final Dio _dio = Dio();
  List<User> users = [];
  bool isLoading = true;
  String? error;

  int currentIndex = 0;
  double offsetX = 0.0;
  double opacity = 1.0;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _fetchNextUser();
  }

  Future<void> _fetchNextUser() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final lastUserId = users.isEmpty ? 0 : users.last.id;
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/api/next-user/$lastUserId',
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );

      if (response.data == null) {
        setState(() {
          isLoading = false;
          error = 'No more users available';
        });
        return;
      }

      final newUser = User.fromJson(response.data);

      // Precache the image
      await precacheImage(NetworkImage(newUser.imageUrl), context);

      setState(() {
        users.add(newUser);
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        error = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _handleSwipe(bool isLike) async {
    if (users.isEmpty) return;

    try {
      final currentUser = users[currentIndex];
      await _dio.post(
        '${ApiConfig.baseUrl}/api/swipe',
        data: {
          'swiperId': currentUser.id,
          'targetId': currentUser.id, // This should be adjusted based on your logic
          'isLike': isLike,
        },
      );

      // Move to next user
      setState(() {
        isVisible = false;
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          currentIndex++;
          offsetX = 0.0;
          opacity = 1.0;
          isVisible = true;
        });

        // Prefetch next user if we're running low
        if (currentIndex + 2 >= users.length) {
          _fetchNextUser();
        }
      });
    } catch (e) {
      // Handle swipe error
      debugPrint('Swipe error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && users.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null && users.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error!),
              ElevatedButton(
                onPressed: _fetchNextUser,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Stack(
          children: [
            // Next user card in the background
            if (users.length > currentIndex + 1)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: TinderCard(
                    imageUrl: users[currentIndex + 1].imageUrl,
                    time: users[currentIndex + 1].time,
                    day: users[currentIndex + 1].day,
                    textInfo: users[currentIndex + 1].textInfo,
                    trainType: users[currentIndex + 1].trainType,
                  ),
                ),
              ),
            // Current user card
            if (isVisible && currentIndex < users.length)
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
                    child: TinderCard(
                      imageUrl: users[currentIndex].imageUrl,
                      time: users[currentIndex].time,
                      day: users[currentIndex].day,
                      textInfo: users[currentIndex].textInfo,
                      trainType: users[currentIndex].trainType,
                    ),
                  ),
                ),
              ),
            // Loading indicator when fetching new users
            if (isLoading && users.isNotEmpty)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  void animateCardAway(bool isRightSwipe) {
    setState(() {
      offsetX = isRightSwipe ? 300 : -300;
      opacity = 0.0;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      _handleSwipe(isRightSwipe);
    });
  }

  void resetCardPosition() {
    setState(() {
      offsetX = 0;
      opacity = 1.0;
    });
  }
}