import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_application_tracker/core/theme/app_typography.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/services/analytics.dart';

/// Monthly statistics, newest month first. Also the table view of
/// the monthly chart.
class MonthlyTable extends StatelessWidget {
  const MonthlyTable({required this.months, super.key});

  final List<MonthStats> months;

  static const _columns = ['Sent', 'Resp.', 'Int.', 'Offers'];

  @override
  Widget build(BuildContext context) {
    final header = context.textTheme.labelMedium?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );
    final cell = context.textTheme.bodyMedium?.tabular;

    Widget row(String label, List<String> values, TextStyle? style) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          for (final value in values)
            SizedBox(
              width: 56,
              child: Text(value, style: style, textAlign: TextAlign.end),
            ),
        ],
      ),
    );

    return Column(
      children: [
        row('Month', _columns, header),
        const Divider(),
        for (final m in months.reversed)
          row(DateFormat.yMMM().format(m.month), [
            '${m.applied}',
            '${m.responses}',
            '${m.interviews}',
            '${m.offers}',
          ], cell),
      ],
    );
  }
}
