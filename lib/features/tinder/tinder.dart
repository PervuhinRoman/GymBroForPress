import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/features/tinder/tinderCard.dart';

class TinderScreen extends ConsumerStatefulWidget {
  const TinderScreen({super.key});

  @override
  _TinderScreenState createState() => _TinderScreenState();
}

class _TinderScreenState extends ConsumerState<TinderScreen> {
  final List<String> images = [
    'assets/images/cat.jpeg',
    'assets/images/dog.jpeg',
    'assets/images/myles.jpeg',
  ];

  int currentIndex = 0;
  double offsetX = 0.0;
  double opacity = 1.0;
  bool isVisible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var imagePath in images) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: TinderCard(imagePath: images[(currentIndex + 1) % images.length]),
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
                    child: TinderCard(imagePath: images[currentIndex]),
                  ),
                ),
              ),
          ],
        ),
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
