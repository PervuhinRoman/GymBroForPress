import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymbro/core/theme/app_colors.dart';
import 'package:gymbro/core/utils/constants.dart';
import 'package:gymbro/features/tinder/controller/user.dart' as u;

class TinderCard extends ConsumerWidget {
  final u.User user;

  const TinderCard({
    super.key,
    required this.user,
  });

  Color getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  IconData getTrainingIcon(String trainType) {
    final type = trainType.toLowerCase();
    if (type.contains('кардио') || type.contains('бег')) {
      return Icons.directions_run;
    } else if (type.contains('сила') || type.contains('силовая')) {
      return Icons.fitness_center;
    } else if (type.contains('йога') || type.contains('растяжка')) {
      return Icons.self_improvement;
    } else if (type.contains('функционал')) {
      return Icons.sports_gymnastics;
    } else if (type.contains('круговая')) {
      return Icons.loop;
    } else {
      return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var constants = ref.read(constantsProvider);
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              constants.paddingUnit * 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              constants.paddingUnit * 1.5),
                          child: Hero(
                            tag: 'profileImage_${user.id}',
                            child: Image.network(
                              'https://gymbro.serveo.net${user.imageUrl}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(Icons.error,
                                    size: 50, color: Colors.red),
                              ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Positioned(
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
                              bottomLeft:
                                  Radius.circular(constants.paddingUnit * 1.5),
                              bottomRight:
                                  Radius.circular(constants.paddingUnit * 1.5),
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
                                decoration: BoxDecoration(
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
                      ),

                      Positioned(
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
                              topRight:
                                  Radius.circular(constants.paddingUnit * 1.5),
                              bottomLeft:
                                  Radius.circular(constants.paddingUnit),
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
                      ),
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
                    Row(
                      children: [
                        const Icon(Icons.fitness_center,
                            size: 16, color: AppColors.violetPrimary),
                        const SizedBox(width: 4),
                        Text(
                          l10n.training,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.violetPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.trainType,
                            style: const TextStyle(fontWeight: FontWeight.w500, color : Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: AppColors.violetPrimary),
                        const SizedBox(width: 4),
                        Text(
                          l10n.trainingTime,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.violetPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.time,
                            style: const TextStyle(fontWeight: FontWeight.w500, color : Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: AppColors.violetPrimary),
                        const SizedBox(width: 4),
                        Text(
                          l10n.trainingDays,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.violetPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.day,
                            style: const TextStyle(fontWeight: FontWeight.w500, color : Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: constants.paddingUnit),
                padding: EdgeInsets.all(constants.paddingUnit),
                decoration: BoxDecoration(
                  color: AppColors.greenSecondary.withValues(alpha: 0.3),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
