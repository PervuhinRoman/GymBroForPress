import 'package:flutter/material.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import '../controller/user.dart';

class MatchPopup extends StatelessWidget {
  final User matchedUser;

  const MatchPopup({super.key, required this.matchedUser});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
             AppColors.greenSecondary,
             AppColors.greenPrimary,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TweenAnimationBuilder(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          'MATCH!',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                      'https://gymbro.serveo.net${matchedUser.imageUrl}',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Вы понравились друг другу!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 20,
              right: 20,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Продолжить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}