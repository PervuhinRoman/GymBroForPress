import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gymbro/features/tinder/presentation/match/user_info.dart';

import '../../controller/user.dart';

class MatchContent extends StatelessWidget {
  final User matchedUser;

  const MatchContent({super.key, required this.matchedUser});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatar(matchedUser: matchedUser),
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
          value: matchedUser.time,
        ),
        const SizedBox(height: 8),
        UserInfoItem(
          icon: Icons.calendar_today,
          label: l10n.trainingDays,
          value: matchedUser.day,
        ),
        const SizedBox(height: 20),
        if (matchedUser.contact.isNotEmpty)
          ContactInfo(matchedUser: matchedUser),
      ],
    );
  }
}
