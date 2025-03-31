import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro/core/providers/app_settings_provider.dart';
import 'package:gymbro/core/providers/tab_provider.dart';
import 'package:gymbro/features/profile/presentation/profile_screen.dart';
import 'package:gymbro/features/tinder/form.dart';

import '../../../calendar/calendar.dart';
import '../../../tinder/tinder.dart';

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
  bool _isTabControllerListenerActive = true; // Флаг для контроля слушателя

  @override
  void initState() {
    super.initState();
    // Инициализация TabController с сохраненной вкладкой
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: ref.read(tabProvider),
    );

    // Слушаем изменения TabController
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // Проверяем флаг перед обновлением провайдера
    if (_tabController.indexIsChanging && _isTabControllerListenerActive) {
      ref.read(tabProvider.notifier).setTab(_tabController.index);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Синхронизация TabController с провайдером после обновления виджета
    _syncTabControllerWithProvider();
  }

  // Синхронизируем TabController с провайдером безопасно
  void _syncTabControllerWithProvider() {
    final selectedTab = ref.read(tabProvider);
    if (_tabController.index != selectedTab) {
      // Временно отключаем слушатель, чтобы избежать цикла обратной связи
      _isTabControllerListenerActive = false;
      // Используем Future.microtask, чтобы обновление произошло после построения виджета
      Future.microtask(() {
        if (mounted) {
          _tabController.animateTo(selectedTab);
          // Восстанавливаем слушатель
          _isTabControllerListenerActive = true;
        }
      });
    }
  }

  void _navigateToQuestionnaire(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedTab = ref.watch(tabProvider);

    // Безопасная синхронизация TabController после построения
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _tabController.index != selectedTab) {
        _syncTabControllerWithProvider();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (selectedTab == 1)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToQuestionnaire(context),
              tooltip: 'Моя анкета',
            ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageSelector(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _showThemeSelector(context, ref),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Calendar(),
          TinderScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.homePageTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center),
            label: l10n.workoutPageTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profilePageTitle,
          ),
        ],
        currentIndex: selectedTab,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) => ref.read(tabProvider.notifier).setTab(index),
      ),
    );
  }

  // Диалоговое окно для выбора языка
  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Русский'),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setLocale(const Locale('ru'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Диалоговое окно для выбора темы
  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('System'),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Light'),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                onTap: () {
                  ref
                      .read(appSettingsNotifierProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
