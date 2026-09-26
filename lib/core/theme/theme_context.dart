import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/status_colors.dart';

/// Short-hands for reading the theme inside widgets.
extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  StatusColors get statusColors => theme.extension<StatusColors>()!;
}
