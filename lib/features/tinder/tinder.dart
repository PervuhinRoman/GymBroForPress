import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/tinder/tinderCard.dart';

class ApiConfig {
  // Для Android эмулятора
  static const baseUrl = 'http://10.0.2.2:8080';

// Для iOS симулятора или теста на том же компьютере
// static const baseUrl = 'http://localhost:8080';

// Для реального устройства (замените на IP вашего компьютера)
// static const baseUrl = 'http://192.168.1.100:8080';
}

class TinderScreen extends ConsumerStatefulWidget {
  const TinderScreen({super.key});

  @override
  _TinderScreenState createState() => _TinderScreenState();
}

class _TinderScreenState extends ConsumerState<TinderScreen> {
  final Dio _dio = Dio();
  List<String> images = [];
  bool isLoading = true;
  String? error;

  int currentIndex = 0;
  double offsetX = 0.0;
  double opacity = 1.0;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {

      setState(() {
        isLoading = true;
        error = null;
      });

      final url = '${ApiConfig.baseUrl}/api/next-user/0';
      debugPrint('$url');

      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );

      debugPrint(' Response: ${response.statusCode}');
      debugPrint('Main response: ${response.data}');

      final user = response.data as Map<String, dynamic>;
      final imageUrl = '${ApiConfig.baseUrl}/${user['imageUrl']}';
      debugPrint(' URL image: $imageUrl');

      final imageResponse = await _dio.head(imageUrl);

      if (imageResponse.statusCode != 200) {
        throw Exception('Изображение не найдено (${imageResponse.statusCode})');
      }

      setState(() {
        images = [imageUrl];
        isLoading = false;
      });

      await precacheImage(NetworkImage(imageUrl), context);

    } catch (e, stackTrace) {
      debugPrint('$e');
      debugPrint('$stackTrace');

      setState(() {
        // error = 'Ошибка: ${e.toString().replaceAll('DioException', '')}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error!),
              ElevatedButton(
                onPressed: _fetchUsers,
                child: const Text('Repeat'),
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
            if (images.length > 1)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: TinderCard(
                      imageUrl: images[(currentIndex + 1) % images.length]),
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
                    child: TinderCard(imageUrl: images[currentIndex]),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchUsers,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void onSwipeComplete(bool isRightSwipe) {
    setState(() {
      isVisible = false;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
        offsetX = 0.0;
        opacity = 1.0;
        isVisible = true;
      });
    });
  }

  void animateCardAway(bool isRightSwipe) {
    setState(() {
      offsetX = isRightSwipe ? 300 : -300;
      opacity = 0.0;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      onSwipeComplete(isRightSwipe);
    });
  }

  void resetCardPosition() {
    setState(() {
      offsetX = 0;
      opacity = 1.0;
    });
  }
}
