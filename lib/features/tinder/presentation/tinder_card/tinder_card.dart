import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/utils/constants.dart';
import 'package:gymbro/features/tinder/domain/user.dart' as u;
import 'package:gymbro/features/tinder/presentation/tinder_card/sections/personal_info_section.dart';
import 'package:gymbro/features/tinder/presentation/tinder_card/sections/training_preferences_section.dart';
import 'package:gymbro/features/tinder/presentation/tinder_card/user_image.dart';


import 'image_overlay.dart';
import 'info_row.dart';

class TinderCard extends ConsumerWidget {
  final u.User user;

  const TinderCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.all(constants.paddingUnit * 2),
      child: Card(
        shadowColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constants.paddingUnit * 1.5),
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: constants.paddingUnit * 2,
            horizontal: constants.paddingUnit * 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: constants.paddingUnit,
                    horizontal: constants.paddingUnit,
                  ),
                  child: Stack(
                    children: [
                      UserImage(user: user),
                      ImageOverlay(user: user),
                      TrainingBadge(user: user),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: constants.paddingUnit * 1.5),
                padding: EdgeInsets.all(constants.paddingUnit),
                decoration: BoxDecoration(
                  color: AppColors.violetPaleX2,
                  borderRadius: BorderRadius.circular(constants.paddingUnit),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(
                      icon: Icons.fitness_center,
                      label: l10n.training,
                      value: user.trainType,
                    ),
                    InfoRow(
                      icon: Icons.access_time,
                      label: l10n.trainingTime,
                      value: user.trainingTime,
                    ),
                    InfoRow(
                      icon: Icons.calendar_today,
                      label: l10n.trainingDays,
                      value: user.trainingDays,
                    ),
                  ],
                ),
              ),
              PersonalInfoSection(user: user),
            ],
          ),
        ),
      ),
    );
  }
}