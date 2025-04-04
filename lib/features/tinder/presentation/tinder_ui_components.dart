import 'package:flutter/material.dart';
import '../domain/user.dart' as u;
import 'tinder_card/tinder_card.dart';

class TinderCardStack extends StatelessWidget {
  final List<u.User> users;
  final int currentIndex;
  final double offsetX;
  final double opacity;
  final bool isVisible;
  final Function(DragUpdateDetails) onHorizontalDragUpdate;
  final Function(DragEndDetails) onHorizontalDragEnd;

  const TinderCardStack({
    super.key,
    required this.users,
    required this.currentIndex,
    required this.offsetX,
    required this.opacity,
    required this.isVisible,
    required this.onHorizontalDragUpdate,
    required this.onHorizontalDragEnd,
  });

  @override
  Widget build(BuildContext context) {
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
              onHorizontalDragUpdate: onHorizontalDragUpdate,
              onHorizontalDragEnd: onHorizontalDragEnd,
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
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorDisplay extends StatelessWidget {
  final String error;

  const ErrorDisplay({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Error: $error'));
  }
}

class EmptyStateDisplay extends StatelessWidget {
  const EmptyStateDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No users found'));
  }
} 