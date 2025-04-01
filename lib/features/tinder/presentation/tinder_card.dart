import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/utils/constants.dart';
import 'package:gymbro/features/tinder/presentation/tags.dart';
import 'package:gymbro/features/tinder/presentation/tinder.dart';

class TinderCard extends ConsumerWidget {
  final User user;

  const TinderCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var constants = ref.read(constantsProvider);
    return Padding(
      padding: EdgeInsets.all(constants.paddingUnit * 2),
      child: Card(
        shadowColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constants.paddingUnit),
        ),
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: constants.paddingUnit * 2,
              horizontal: constants.paddingUnit * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(constants.paddingUnit * 1.5),
                child:
                Image.network('https://gymbro.serveo.net${user.imageUrl}',
                  width: constants.screenHeight / 2.2,
                  height: constants.screenHeight / 1.8,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(constants.paddingUnit),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      spacing: constants.paddingUnit,
                      runSpacing: constants.paddingUnit,
                      children: [
                        Tag(
                          text: user.time,
                          category: TagCategory.hours,
                        ),
                        Tag(
                          text: user.day,
                          category: TagCategory.days,
                        ),
                        Tag(
                          text: user.trainType,
                          category: TagCategory.trainType,
                        ),
                        Tag(
                          text: user.textInfo,
                          category: TagCategory.textInfo,
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
