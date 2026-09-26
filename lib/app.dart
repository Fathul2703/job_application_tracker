import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/app_theme.dart';
import 'package:job_application_tracker/providers/theme_mode_provider.dart';

class JobTrackerApp extends ConsumerWidget {
  const JobTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Job Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
