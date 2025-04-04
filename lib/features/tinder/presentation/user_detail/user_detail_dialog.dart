import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/user.dart' as u;
import '../tinder_card/sections/personal_info_section.dart';
import '../tinder_card/sections/training_preferences_section.dart';
import '../tinder_card/user_image.dart';
import '../tinder_card/info_row.dart';

class UserDetailDialog extends ConsumerWidget {
  final u.User user;

  const UserDetailDialog({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: UserImage(user: user),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TrainingBadge(user: user),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InfoRow(
                            icon: Icons.access_time,
                            label: 'Время:',
                            value: user.trainingTime,
                          ),
                        ),
                        Expanded(
                          child: InfoRow(
                            icon: Icons.calendar_today,
                            label: 'Дни:',
                            value: user.trainingDays,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PersonalInfoSection(user: user),
                    const SizedBox(height: 16),
                    if (user.contact.isNotEmpty)
                      ElevatedButton.icon(
                        onPressed: () async {
                          final username = user.contact.replaceAll('@', '');
                          final tgUri =
                              Uri.parse('tg://resolve?domain=$username');
                          final webUri = Uri.parse('https://t.me/$username');

                          try {
                            if (await canLaunchUrl(tgUri)) {
                              await launchUrl(tgUri);
                            } else if (await canLaunchUrl(webUri)) {
                              await launchUrl(webUri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Не удалось открыть Telegram для пользователя $username')),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Ошибка при открытии Telegram: $e')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.telegram),
                        label: Text('Связаться в Telegram: ${user.contact}'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color(0xFF0088cc), // Telegram color
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
