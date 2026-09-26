import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';

/// An [AppBar] whose leading button, title and actions line up with page
/// content wrapped in `MaxWidthContent`.
///
/// On wide windows (tablets, landscape) content is centred at
/// [AppLayout.maxContentWidth]; a plain AppBar would keep its title at the
/// far left. This insets everything by the same side margin. On phones the
/// margin is zero, so it looks exactly like a regular AppBar.
class ContentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ContentAppBar({this.title, this.leading, this.actions, super.key});

  final Widget? title;

  /// Defaults to a back or close button when the route can be popped, like
  /// [AppBar].
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Side margin that centres [AppLayout.maxContentWidth] in [width].
  static double insetFor(double width) =>
      math.max(0, (width - AppLayout.maxContentWidth) / 2);

  /// Same implied leading as [AppBar]: close for full-screen dialogs,
  /// back otherwise, nothing on a root route.
  static Widget? _impliedLeading(BuildContext context) {
    final route = ModalRoute.of(context);
    if (!(route?.impliesAppBarDismissal ?? false)) return null;
    return route is PageRoute && route.fullscreenDialog
        ? const CloseButton()
        : const BackButton();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final inset = insetFor(constraints.maxWidth);
        final leadingWidget = leading ?? _impliedLeading(context);

        return AppBar(
          automaticallyImplyLeading: false,
          leading: leadingWidget == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(left: inset),
                  child: leadingWidget,
                ),
          leadingWidth: leadingWidget == null ? null : kToolbarHeight + inset,
          titleSpacing: leadingWidget == null
              ? NavigationToolbar.kMiddleSpacing + inset
              : NavigationToolbar.kMiddleSpacing,
          title: title,
          actions: actions,
          actionsPadding: inset == 0 ? null : EdgeInsets.only(right: inset),
        );
      },
    );
  }
}
