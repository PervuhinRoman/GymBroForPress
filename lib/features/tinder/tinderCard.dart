import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/constants.dart';
import 'package:gymbro/features/tinder/tags.dart';

class TinderCard extends ConsumerWidget {
  final String imagePath;

  const TinderCard({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var constants = ref.read(constantsProvider);
    return Card(
      shadowColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(constants.paddingUnit),
      ),
      elevation: 6,
      child: SizedBox(
        height: constants.screenHeight / 1.4,
        width: constants.screenWidth / 1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(constants.paddingUnit * 1.5),
                child: SizedBox(
                  height: constants.screenHeight / 2.0,
                  width: constants.screenWidth / 1.5,
                  child: Image(
                    image: AssetImage(imagePath),
                    // width: constants.screenHeight / 2.2,
                    // height: constants.screenHeight / 1.8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: constants.paddingUnit),
              child: Center(
                child: Wrap(
                    direction: Axis.horizontal,
                    spacing: constants.paddingUnit,
                    runSpacing: constants.paddingUnit,
                    children: [
                      Tag(
                        text: '8 am',
                        category: TagCategory.hours,
                      ),
                      Tag(
                        text: 'Friday, Sunday',
                        category: TagCategory.days,
                      ),
                      Tag(
                        text: 'legs, abs',
                        category: TagCategory.trainType,
                      ),
                      Tag(
                        text: 'some text about me ',
                        category: TagCategory.textInfo,
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
