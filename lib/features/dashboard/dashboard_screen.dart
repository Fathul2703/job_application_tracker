import 'package:flutter/material.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const EmptyState(
        icon: Icons.space_dashboard_outlined,
        title: 'Your job search at a glance',
        message:
            'Upcoming interviews, deadlines and your pipeline will appear '
            'here.',
      ),
    );
  }
}
