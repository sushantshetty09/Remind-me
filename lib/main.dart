import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember/core/theme/app_theme.dart';
import 'package:remember/data/providers.dart';
import 'package:remember/features/today/today_screen.dart';
import 'package:remember/features/add/add_screen.dart';
import 'package:remember/features/notes/notes_screen.dart';
import 'package:remember/features/settings/settings_screen.dart';
import 'package:remember/features/reliability/reliability_screen.dart';
import 'package:remember/services/notification_service.dart';
import 'package:remember/services/scheduler_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification engine & timezone database
  await NotificationService().initialize();

  runApp(const ProviderScope(child: RememberApp()));
}

class RememberApp extends StatelessWidget {
  const RememberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remember',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigationScreen(),
      routes: {
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  @override
  void initState() {
    super.initState();
    // Run app launch health self-check
    Future.microtask(() async {
      final reliabilityService = ref.read(reliabilityServiceProvider);
      await reliabilityService.performHealthCheckAndRepair();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final pages = const [
      TodayScreen(),
      AddScreen(),
      NotesScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_none_outlined),
            selectedIcon: Icon(Icons.mic),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt),
            label: 'Notes',
          ),
        ],
      ),
    );
  }
}
