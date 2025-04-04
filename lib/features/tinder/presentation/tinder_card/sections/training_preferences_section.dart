import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/utils/constants.dart';
import 'package:gymbro/features/tinder/domain/user.dart' as u;
import '../../../../../core/theme/app_colors.dart';
import '../tinder_card_helpers.dart';

class TrainingBadge extends ConsumerWidget {
  final u.User user;

  const TrainingBadge({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);

    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: constants.paddingUnit,
          vertical: constants.paddingUnit / 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.violetPrimary,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(constants.paddingUnit * 1.5),
            bottomLeft: Radius.circular(constants.paddingUnit),
          ),
        ),
        child: Row(
          children: [
            Icon(
              getTrainingIcon(user.trainType),
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              user.trainType,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
