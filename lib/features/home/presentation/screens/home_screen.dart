import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:gymbro/core/utils/routes.dart';
import 'package:gymbro/core/widgets/custom_app_bar.dart';
import 'package:gymbro/features/ai_chat/presentation/screens/aiml_chat_screen.dart';
import 'package:gymbro/features/tinder/presentation/form.dart';
import 'package:gymbro/features/profile/presentation/profile_page.dart';
import 'package:gymbro/features/tinder/presentation/form_widgets/form.dart';

import '../../../calendar/presentation/calendar.dart';
import '../../../tinder/controller/form_service.dart';
import '../../../tinder/presentation/tinder.dart';

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

    return Scaffold(
      appBar: CustomAppBar(
        showProfileAvatar: true,
        showBackButton: false,
        onProfileTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProfilePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Define the curve for better transition dynamics
                const curve = Curves.easeInOut;

                // Create a tween for the slide transition
                var slideTween = Tween<Offset>(
                  begin: Offset(1.0, 0.0), // Start from the right
                  end: Offset.zero, // End at the current position
                ).chain(CurveTween(curve: curve));

                // Create a tween for the fade transition
                var fadeTween = Tween<double>(
                  begin: 0.0, // Fully transparent
                  end: 1.0, // Fully opaque
                ).chain(CurveTween(curve: curve));

                // Apply both slide and fade transitions
                return SlideTransition(
                  position: animation.drive(slideTween),
                  child: FadeTransition(
                    opacity: animation.drive(fadeTween),
                    child: child,
                  ),
                );
              },
            )
            // MaterialPageRoute(
            //   builder: (context) => const ProfilePage(),
            // ),
            ),
        actions: [
          if (_selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => _navigateToForm(context),
              tooltip: 'Моя анкета',
            ),
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
