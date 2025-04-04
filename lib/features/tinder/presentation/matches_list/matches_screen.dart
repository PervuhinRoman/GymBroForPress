import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'dart:convert';
import 'dart:math';

import '../../domain/matches_list.dart';
import '../../domain/user.dart' as app_user;
import '../user_detail/user_detail_dialog.dart';

class MatchesListScreen extends ConsumerStatefulWidget {
  const MatchesListScreen({super.key});

  @override
  ConsumerState<MatchesListScreen> createState() => _MatchesListScreenState();
}

class _MatchesListScreenState extends ConsumerState<MatchesListScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(matchesControllerProvider.notifier)
          .ensureMatchesStateConsistency();
      _refreshMatches();
    });
  }

  Future<void> _refreshMatches() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      await ref
          .read(matchesControllerProvider.notifier)
          .loadMatchesFromServer();
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
    final matchesState = ref.watch(matchesControllerProvider);

    return Scaffold(
      body: Column(
        children: [
          MatchesAppBar(
            isRefreshing: _isRefreshing,
            onRefresh: _refreshMatches,
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshMatches,
              child: _MatchesListContent(
                state: matchesState,
                isRefreshing: _isRefreshing,
                onRefresh: _refreshMatches,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Аппбар для экрана совпадений
class MatchesAppBar extends StatelessWidget {
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final VoidCallback onBack;

  const MatchesAppBar({
    super.key,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
            onPressed: onBack,
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
            icon: isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
            onPressed: isRefreshing ? null : onRefresh,
            tooltip: 'Обновить список',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// Контент списка совпадений
class _MatchesListContent extends StatelessWidget {
  final UserMatchesState state;
  final bool isRefreshing;
  final VoidCallback onRefresh;

  const _MatchesListContent({
    required this.state,
    required this.isRefreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && !isRefreshing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _MatchesErrorState(error: state.error!, onRefresh: onRefresh);
    }

    if (state.matches.isEmpty) {
      return _EmptyMatchesState(onRefresh: onRefresh);
    }

    return _MatchesListView(matches: state.matches);
  }
}

// Состояние ошибки
class _MatchesErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRefresh;

  const _MatchesErrorState({
    required this.error,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
              l10n.error,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

// Пустое состояние
class _EmptyMatchesState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyMatchesState({
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Проверить совпадения'),
          ),
        ],
      ),
    );
  }
}

// Список совпадений
class _MatchesListView extends ConsumerWidget {
  final List<UserMatches> matches;

  const _MatchesListView({
    required this.matches,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, UserMatches> userMatches = {};
    for (var match in matches) {
      if (!userMatches.containsKey(match.user.id) ||
          match.dateTime.isAfter(userMatches[match.user.id]!.dateTime)) {
        userMatches[match.user.id] = match;
      }
    }

    final uniqueMatches = userMatches.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: uniqueMatches.length,
      itemBuilder: (context, index) {
        final match = uniqueMatches[index];
        return MatchItem(
          user: match.user,
          isUnread: !match.isRead,
          onTap: () {
            if (!match.isRead) {
              ref.read(matchesControllerProvider.notifier).markAsRead(match.id);
            }

            showDialog(
              context: context,
              builder: (context) => UserDetailDialog(user: match.user),
            );
          },
        );
      },
    );
  }
}

// Элемент списка совпадений
class MatchItem extends StatelessWidget {
  final app_user.User user;
  final bool isUnread;
  final VoidCallback onTap;

  const MatchItem({
    super.key,
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
              _UserAvatarWithIndicator(user: user, isUnread: isUnread),
              const SizedBox(width: 16),
              _UserInfo(user: user, isUnread: isUnread),
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

// Аватар пользователя с индикатором непрочитанного
class _UserAvatarWithIndicator extends StatelessWidget {
  final app_user.User user;
  final bool isUnread;

  const _UserAvatarWithIndicator({
    required this.user,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: user.imageUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    'https://gymbro.serveo.net${user.imageUrl}',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: theme.colorScheme.primary,
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
                  color: theme.colorScheme.primary,
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
    );
  }
}

// Информация о пользователе
class _UserInfo extends StatelessWidget {
  final app_user.User user;
  final bool isUnread;

  const _UserInfo({
    required this.user,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
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
    );
  }
}
