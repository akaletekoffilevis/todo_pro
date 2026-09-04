import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/tasks_screen.dart';
import '../../features/home/presentation/screens/stats_screen.dart';
import '../../features/home/presentation/screens/task_editor_screen.dart';
import '../../features/home/presentation/screens/focus_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// Routeur applicatif basé sur go_router.
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/tasks', builder: (context, state) => const TasksScreen()),
    GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(path: '/focus', builder: (context, state) => const FocusScreen()),
    GoRoute(
      path: '/editor',
      builder: (context, state) =>
          TaskEditorScreen(task: state.extra as dynamic),
    ),
  ],
);
