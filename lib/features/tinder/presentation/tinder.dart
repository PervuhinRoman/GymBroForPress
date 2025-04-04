import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../domain/user.dart' as u;
import '../domain/swiper.dart';
import '../domain/matches_list.dart';
import 'match/match_pop_up.dart';
import 'tinder_widgets.dart';

class TinderScreen extends ConsumerWidget {
  const TinderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(u.usersProvider);
    final cardState = ref.watch(cardStateProvider);
    final usersState = ref.watch(u.usersControllerProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(u.usersControllerProvider.notifier).refresh();
                return;
              },
              child: usersAsync.when(
                loading: () => const LoadingIndicator(),
                error: (error, stack) => ErrorDisplay(error: error.toString()),
                data: (users) {
                  if (users.isEmpty) {
                    return const EmptyStateDisplay();
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (cardState.currentIndex >= users.length) {
                      ref.read(cardStateProvider.notifier).setCardIndex(0, users.length);
                    }
                  });

                  return TinderCardStack(
                    users: users,
                    currentIndex: cardState.currentIndex,
                    offsetX: cardState.offsetX,
                    opacity: cardState.opacity,
                    isVisible: cardState.isVisible,
                    onHorizontalDragUpdate: (details) {
                      if (details.primaryDelta != null) {
                        ref.read(cardStateProvider.notifier).updateDragPosition(details.primaryDelta);
                      }
                    },
                    onHorizontalDragEnd: (details) {
                      if (cardState.offsetX.abs() > 150) {
                        final isRightSwipe = cardState.offsetX > 0;
                        _handleSwipe(context, ref, isRightSwipe, users);
                      } else {
                        ref.read(cardStateProvider.notifier).resetCardPosition();
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSwipe(BuildContext context, WidgetRef ref, bool isRightSwipe, List<u.User> users) {
    final cardStateNotifier = ref.read(cardStateProvider.notifier);
    final currentUser = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    final currentIndex = ref.read(cardStateProvider).currentIndex;

    if (currentUser == null) return;

    cardStateNotifier.animateCardAway(isRightSwipe);

    Future.delayed(const Duration(milliseconds: 200), () {
      cardStateNotifier.hideCard();

      final request = SwipeRequest(
        swiperId: currentUser.uid,
        targetId: users[currentIndex].id,
        isLike: isRightSwipe,
      );

      ref.read(swipeProvider(request).future).then((result) {
        if (result.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.error}: ${result.errorMessage}')),
          );
        }

        if (result.isMatch && result.matchedUser != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => MatchPopup(matchedUser: result.matchedUser!),
          );
        }

        cardStateNotifier.showNextCard(users.length);
      });
    });
  }
}
