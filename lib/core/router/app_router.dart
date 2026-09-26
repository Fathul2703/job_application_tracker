import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/features/analytics/analytics_screen.dart';
import 'package:job_application_tracker/features/applications/applications_screen.dart';
import 'package:job_application_tracker/features/dashboard/dashboard_screen.dart';
import 'package:job_application_tracker/features/settings/settings_screen.dart';
import 'package:job_application_tracker/features/shell/app_shell.dart';

/// Route paths. Always navigate with these constants, never string literals.
abstract final class AppRoutes {
  static const dashboard = '/dashboard';
  static const applications = '/applications';
  static const analytics = '/analytics';
  static const settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  // Full-screen routes (forms) will use this key as `parentNavigatorKey` so
  // they cover the navigation shell.
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(path: '/', redirect: (_, _) => AppRoutes.dashboard),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (_, _) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.applications,
                builder: (_, _) => const ApplicationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.analytics,
                builder: (_, _) => const AnalyticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
