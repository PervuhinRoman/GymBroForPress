import 'package:flutter/material.dart';

class TinderScreen extends StatefulWidget {
  const TinderScreen({super.key});

  @override
  _TinderScreenState createState() => _TinderScreenState();
}

class _TinderScreenState extends State<TinderScreen> {
  final List<String> images = [
    'assets/cat.jpeg',
    'assets/dog.jpeg',
  ];

  int currentIndex = 0;
  double offsetX = 0.0;
  double opacity = 1.0;

  void onSwipeComplete(bool isRightSwipe) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          offsetX = 0.0;
          opacity = 1.0;
          currentIndex = (currentIndex + 1) % images.length;
        });
      }
    });
  }

//https://stackoverflow.com/questions/51343735/flutter-image-preload
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
            if (currentIndex < images.length)
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    offsetX += details.primaryDelta ?? 0;
                    opacity = 1 - (offsetX.abs() / 300).clamp(0.0, 1.0);
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
                    child: buildCard(images[currentIndex]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String imagePath) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: SizedBox(
        width: 340,
        height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image(
                    image: AssetImage(imagePath), width: 300, height: 400)),
            Center(child: Text('ill do it later')),
          ],
        ),
      ),
    );
  }

  void animateCardAway(bool isRightSwipe) {
    setState(() {
      offsetX = isRightSwipe ? 500 : -500;
      opacity = 0.0;
    });

    onSwipeComplete(isRightSwipe);
  }

  void resetCardPosition() {
    setState(() {
      offsetX = 0;
      opacity = 1.0;
    });
  }
}
