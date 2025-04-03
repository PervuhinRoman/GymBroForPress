import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/utils/constants.dart';
import 'package:gymbro/features/tinder/controller/user.dart' as u;
import 'package:gymbro/features/tinder/presentation/tinder_card/tinder_card_helpers.dart';

import '../../../../core/theme/app_colors.dart';

class ImageOverlay extends ConsumerWidget {
  final u.User user;

  const ImageOverlay({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(constants.paddingUnit * 1.5),
            bottomRight: Radius.circular(constants.paddingUnit * 1.5),
          ),
        ),
        padding: EdgeInsets.all(constants.paddingUnit),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.greenPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                getTrainingIcon(user.trainType),
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
