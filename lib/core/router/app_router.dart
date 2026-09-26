import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/features/analytics/analytics_screen.dart';
import 'package:job_application_tracker/features/applications/application_detail_screen.dart';
import 'package:job_application_tracker/features/applications/application_form_screen.dart';
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

  static const newApplication = '/applications/new';
  static String applicationDetail(int id) => '/applications/$id';
  static String editApplication(int id) => '/applications/$id/edit';
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
                routes: [
                  // Declared before ':id' so "new" is never parsed as an id.
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (_, state) => MaterialPage(
                      key: state.pageKey,
                      fullscreenDialog: true,
                      child: const ApplicationFormScreen(),
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        ApplicationDetailScreen(applicationId: _idParam(state)),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: rootNavigatorKey,
                        pageBuilder: (_, state) => MaterialPage(
                          key: state.pageKey,
                          fullscreenDialog: true,
                          child: EditApplicationScreen(
                            applicationId: _idParam(state),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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

/// Route id parameter; an invalid id maps to -1, which never exists and so
/// renders the "not found" state.
int _idParam(GoRouterState state) =>
    int.tryParse(state.pathParameters['id'] ?? '') ?? -1;
