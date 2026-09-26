import 'package:flutter/widgets.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';

/// Centers [child] horizontally and caps its width at
/// [AppLayout.maxContentWidth], so pages stay readable on tablets.
class MaxWidthContent extends StatelessWidget {
  const MaxWidthContent({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
        child: child,
      ),
    );
  }
}
