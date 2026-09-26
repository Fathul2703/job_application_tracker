import 'package:flutter/material.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Applications')),
      body: const EmptyState(
        icon: Icons.work_outline,
        title: 'No applications yet',
        message:
            'Track every role you save or apply for, from first click to '
            'final offer.',
      ),
    );
  }
}
