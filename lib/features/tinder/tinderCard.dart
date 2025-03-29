import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/utils/constants.dart';
import 'package:gymbro/features/tinder/tags.dart';

class TinderCard extends ConsumerWidget {
  final String imageUrl;
  final String time;
  final String day;
  final String textInfo;
  final String trainType;

  const TinderCard({
    super.key,
    required this.imageUrl,
    required this.time,
    required this.day,
    required this.textInfo,
    required this.trainType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var constants = ref.read(constantsProvider);
    return Padding(
      padding: EdgeInsets.all(constants.paddingUnit * 2),
      child: Card(
        shadowColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                child: Image.network(
                  imageUrl,
                  width: constants.screenHeight / 2.2,
                  height: constants.screenHeight / 1.8,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
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
                          text: time,
                          category: TagCategory.hours,
                        ),
                        Tag(
                          text: day,
                          category: TagCategory.days,
                        ),
                        Tag(
                          text: trainType,
                          category: TagCategory.trainType,
                        ),
                        Tag(
                          text: textInfo,
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