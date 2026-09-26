import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';

/// Rounded square with the company's initials. The tint is derived from the
/// name, so the same company always gets the same color.
class CompanyAvatar extends StatelessWidget {
  const CompanyAvatar(this.companyName, {this.size = 44, super.key});

  final String companyName;
  final double size;

  static String initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    final letters = words.length == 1
        ? words.first.substring(0, words.first.length.clamp(0, 2))
        : '${words[0][0]}${words[1][0]}';
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    // Soft tints of the scheme's accent colors keep the list calm while
    // still telling companies apart.
    final accents = [colors.primary, colors.tertiary, colors.secondary];
    final hash = companyName.codeUnits.fold(0, (sum, unit) => sum + unit);
    final foreground = accents[hash % accents.length];
    final background = foreground.withValues(alpha: 0.12);

    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(
              size >= 56 ? AppRadius.lg : AppRadius.md,
            ),
          ),
          child: Center(
            child: Text(
              initialsOf(companyName),
              style:
                  (size >= 56
                          ? context.textTheme.titleLarge
                          : context.textTheme.titleSmall)
                      ?.copyWith(color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}
