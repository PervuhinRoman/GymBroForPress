import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'dart:convert';
import 'dart:math';

import '../../controller/notifications.dart';
import '../../controller/user.dart' as app_user;
import '../user_detail/user_detail_screen.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsControllerProvider.notifier).ensureNotificationsStateConsistency();
      _refreshMatches();
    });
  }

  Future<void> _refreshMatches() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      await ref.read(notificationsControllerProvider.notifier).loadMatchesFromServer();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки матчей: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsControllerProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Совпадения',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: _isRefreshing 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                  onPressed: _isRefreshing ? null : _refreshMatches,
                  tooltip: 'Обновить список',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _refreshMatches();
              },
              child: notificationsState.isLoading && !_isRefreshing
                  ? const Center(child: CircularProgressIndicator())
                  : _buildMatchesList(context, notificationsState, theme, l10n, ref),
            ),
          ),
        ],
        
      ),
    );
  }

  Widget _buildMatchesList(
    BuildContext context, 
    NotificationsState state, 
    ThemeData theme, 
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '${l10n.error}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${state.error}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _refreshMatches,

                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'У вас пока нет совпадений',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Когда вы найдете совпадение,\nоно появится здесь',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            
            if (state.lastServerResponse != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Отладочная информация:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Text(
                    state.lastServerResponse!,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshMatches,
              icon: const Icon(Icons.refresh),
              label: const Text('Проверить совпадения'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                final controller = ref.read(notificationsControllerProvider.notifier);
                
                try {
                  final currentUser = firebase.FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пользователь не авторизован')),
                    );
                    return;
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Создаю тестовый матч...')),
                  );
                  
                  final users = await ref.read(app_user.usersProvider.future);
                  
                  if (users.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Список пользователей пуст')),
                    );
                    return;
                  }
                  
                  app_user.User? otherUser;
                  for (var user in users) {
                    if (user.id != currentUser.uid) {
                      otherUser = user;
                      break;
                    }
                  }
                  
                  if (otherUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Не найдено других пользователей')),
                    );
                    return;
                  }
                  
                  final notification = UserNotification(
                    id: 'test_match_${DateTime.now().millisecondsSinceEpoch}',
                    user: otherUser,
                    dateTime: DateTime.now(),
                    message: 'Вы нашли тренировочного партнера! ${otherUser.name} также хочет тренироваться с вами.',
                    isRead: false,
                  );
                  
                  await controller.addNotification(notification);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Создано тестовое совпадение с ${otherUser.name}')),
                  );
                  
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: $e')),
                  );
                }
              },
              child: const Text('Создать тестовое совпадение'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                try {
                  final response = await http.get(
                    Uri.parse('https://gymbro.serveo.net/api/matches'),
                    headers: {'Content-Type': 'application/json'},
                  );
                  
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ответ сервера: ${response.body}')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка: ${response.statusCode}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка запроса: $e')),
                  );
                }
              },
              child: const Text('Тестовый запрос'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                ref.read(notificationsControllerProvider.notifier).loadMatchesFromServer();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Запрос на обновление матчей отправлен')),
                );
              },
              child: const Text('Обновить матчи'),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () async {
                try {
                  final currentUser = firebase.FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пользователь не авторизован')),
                    );
                    return;
                  }

                  final asyncUsers = await ref.read(app_user.usersProvider.future);
                  if (asyncUsers.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Нет доступных пользователей')),
                    );
                    return;
                  }

                  app_user.User? otherUser;
                  for (final user in asyncUsers) {
                    if (user.id != currentUser.uid) {
                      otherUser = user;
                      break;
                    }
                  }

                  if (otherUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Нет других пользователей')),
                    );
                    return;
                  }

                  final newNotification = UserNotification(
                    id: 'test_match_${DateTime.now().millisecondsSinceEpoch}',
                    user: otherUser,
                    dateTime: DateTime.now(),
                    message: 'Вы нашли тренировочного партнера! ${otherUser.name} также хочет тренироваться с вами.',
                    isRead: false,
                  );

                  ref.read(notificationsControllerProvider.notifier).addNotification(newNotification);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Создан тестовый матч с ${otherUser.name}')),
                  );
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка создания тестового матча: $e')),
                  );
                }
              },
              child: const Text('Создать тестовый матч'),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () async {
                try {
                  final userId = firebase.FirebaseAuth.instance.currentUser?.uid;
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пользователь не авторизован')),
                    );
                    return;
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Проверка API для userId: $userId')),
                  );
                  
                  final baseUrl = 'https://gymbro.serveo.net/api';
                  
                  try {
                    final response = await http.get(Uri.parse('$baseUrl/matches'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('GET /matches: ${response.statusCode}\n${response.body.substring(0, min(100, response.body.length))}')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка GET /matches: $e')),
                    );
                  }
                  
                  try {
                    final response = await http.get(Uri.parse('$baseUrl/matches?userId=$userId'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('GET /matches?userId: ${response.statusCode}\n${response.body.substring(0, min(100, response.body.length))}')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка GET /matches?userId: $e')),
                    );
                  }
                  
                  try {
                    final response = await http.post(
                      Uri.parse('$baseUrl/matches'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'userId': userId}),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('POST /matches: ${response.statusCode}\n${response.body.substring(0, min(100, response.body.length))}')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка POST /matches: $e')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Общая ошибка: $e')),
                  );
                }
              },
              child: const Text('Проверить API'),
            ),
          ],
        ),
      );
    }

    final Map<String, UserNotification> userNotifications = {};
    for (var notification in state.notifications) {
      if (!userNotifications.containsKey(notification.user.id) ||
          notification.dateTime.isAfter(userNotifications[notification.user.id]!.dateTime)) {
        userNotifications[notification.user.id] = notification;
      }
    }

    final uniqueNotifications = userNotifications.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: uniqueNotifications.length,
      itemBuilder: (context, index) {
        final notification = uniqueNotifications[index];
        return _MatchItem(
          user: notification.user,
          isUnread: !notification.isRead,
          onTap: () {
            if (!notification.isRead) {
              ref.read(notificationsControllerProvider.notifier)
                  .markAsRead(notification.id);
              setState(() {});
            }
            
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserDetailScreen(user: notification.user),
              ),
            );
          },
        );
      },
    );
  }
}

class _MatchItem extends StatelessWidget {
  final app_user.User user;
  final bool isUnread;
  final VoidCallback onTap;

  const _MatchItem({
    required this.user,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUnread 
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    child: user.imageUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              'https://gymbro.serveo.net${user.imageUrl}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image: $error');
                                return Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / 
                                          loadingProgress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2,
                                  ),
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                  if (isUnread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.trainType,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.trainingTime,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.trainingDays,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 