import 'package:flutter/material.dart';
import 'package:gymbro/features/tinder/tags.dart';

class TinderScreen extends StatefulWidget {
  const TinderScreen({super.key});

  @override
  _TinderScreenState createState() => _TinderScreenState();
}

class _TinderScreenState extends State<TinderScreen> {
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
                child: buildCard(images[(currentIndex + 1) % images.length]),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: SizedBox(
                  width: 300,
                  height: 400,
                  child: Image(
                    image: AssetImage(imagePath),
                    width: 300,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      Tag(
                        text: '8 am',
                        category: TagCategory.hours,
                      ),
                      Tag(
                        text: 'Friday, Sunday',
                        category: TagCategory.days,
                      ),
                      Tag(
                        text: 'legs, abs',
                        category: TagCategory.trainType,
                      ),
                      Tag(
                        text: 'some text about me ',
                        category: TagCategory.textInfo,
                      )
                    ]),
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
