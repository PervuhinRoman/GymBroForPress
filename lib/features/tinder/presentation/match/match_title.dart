import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymbro/features/tinder/presentation/match/user_info.dart';

import '../../domain/user.dart';


class MatchTitle extends StatelessWidget {
  final AppLocalizations l10n;

  const MatchTitle({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sports_handball,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.gymBroFound,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MatchContent extends StatelessWidget {
  final User matchedUser;

  const MatchContent({super.key, required this.matchedUser});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleImage(matchedUser: matchedUser),
        const SizedBox(height: 15),
        Text(
          matchedUser.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        const SizedBox(height: 15),
        Text(
          l10n.youFoundTrainingPartner,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        UserInfoItem(
          icon: Icons.access_time,
          label: l10n.trainingTime,
          value: matchedUser.trainingTime,
        ),
        const SizedBox(height: 8),
        UserInfoItem(
          icon: Icons.calendar_today,
          label: l10n.trainingDays,
          value: matchedUser.trainingDays,
        ),
        const SizedBox(height: 20),
        if (matchedUser.contact.isNotEmpty)
          ContactInfo(matchedUser: matchedUser),
      ],
    );
  }
}
