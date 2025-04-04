import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/utils/constants.dart';
import 'package:gymbro/features/tinder/domain/user.dart' as u;

class PersonalInfoSection extends ConsumerWidget {
  final u.User user;

  const PersonalInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: constants.paddingUnit),
      padding: EdgeInsets.all(constants.paddingUnit),
      decoration: BoxDecoration(
        color: AppColors.greenSecondary.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(constants.paddingUnit),
        border: Border.all(color: AppColors.greenSecondary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.aboutMe,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.greenPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.textInfo,
            style: const TextStyle(
              fontSize: 13,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
