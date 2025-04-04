import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:gymbro/core/utils/routes.dart';
import 'package:gymbro/core/widgets/custom_app_bar.dart';
import 'package:gymbro/features/ai_chat/presentation/screens/aiml_chat_screen.dart';
import 'package:gymbro/features/profile/presentation/profile_page.dart';
import 'package:gymbro/features/tinder/presentation/form/form.dart';

import '../../../../core/providers/tinder_providers.dart';
import '../../../calendar/presentation/calendar.dart';
import '../../../tinder/domain/form_service.dart';
import '../../../tinder/presentation/tinder.dart';
import '../../../tinder/domain/matches_list.dart';
import '../../../tinder/domain/user.dart' as u;
import '../../../tinder/presentation/matches_list/matches_screen.dart';

class HomeScreenArgs {
  final Function(Locale) setLocale;
  final Function(ThemeMode) setThemeMode;

  HomeScreenArgs({
    required this.setLocale,
    required this.setThemeMode,
  });
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  Future<void> _navigateToForm(BuildContext context) async {
    final formServiceAsync = ref.read(formServiceProvider.future);
    final formService = await formServiceAsync;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormScreen(formService: formService),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unreadCount = ref.watch(unreadMatchesCountProvider);

    return Scaffold(
      appBar: _selectedIndex == 2
          ? null
          : AppBar(
              title: Text(
                _selectedIndex == 0
                    ? l10n.homePageTitle
                    : _selectedIndex == 1
                        ? l10n.workoutPageTitle
                        : 'AI-trainer',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ProfilePage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
                        return FadeTransition(
                          opacity: animation.drive(fadeTween),
                          child: child,
                        );
                      },
                    )),
              ),
              actions: [
                if (_selectedIndex == 1) ...[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        color: Theme.of(context).colorScheme.primary,
                        tooltip: 'Уведомления',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MatchesListScreen(),
                            ),
                          );
                        },
                        onLongPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Создаю тестовое уведомление...')),
                          );

                          ref.read(u.usersProvider.future).then((users) {
                            if (users.isNotEmpty) {
                              final testUser = users.first;
                              ref
                                  .read(matchesControllerProvider.notifier)
                                  .createTestMatch(testUser);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Тестовое уведомление создано')),
                              );
                            }
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ошибка: $error')),
                            );
                          });
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 9 ? '9+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => _navigateToForm(context),
                    tooltip: 'Моя анкета',
                  ),
                ],
              ],
            ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [Calendar(), TinderScreen(), AimlChatScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.homePageTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center),
            label: l10n.workoutPageTitle,
          ),
          // BottomNavigationBarItem(
          //   icon: const Icon(Icons.person),
          //   label: l10n.profilePageTitle,
          // ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.chat), label: 'AI-trainer')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _tabController.animateTo(index);
          });
        },
      ),
    );
  }
}
