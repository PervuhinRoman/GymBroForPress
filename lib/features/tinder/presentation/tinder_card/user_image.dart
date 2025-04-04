import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/utils/constants.dart';
import 'package:gymbro/features/tinder/domain/user.dart' as u;

class UserImage extends ConsumerWidget {
  final u.User user;

  const UserImage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(constants.paddingUnit * 1.5),
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
        borderRadius: BorderRadius.circular(constants.paddingUnit * 1.5),
        child: Hero(
          tag: 'profileImage_${user.id}',
          child: Image.network(
            'https://gymbro.serveo.net${user.imageUrl}',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.error, size: 50, color: Colors.red),
            ),
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
          ),
        ),
      ),
    );
  }
}