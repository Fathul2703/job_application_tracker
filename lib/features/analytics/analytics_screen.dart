import 'package:flutter/material.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: const EmptyState(
        icon: Icons.insights_outlined,
        title: 'Insights need data',
        message:
            'Response, interview and offer rates will be calculated from '
            'your applications.',
      ),
    );
  }
}
