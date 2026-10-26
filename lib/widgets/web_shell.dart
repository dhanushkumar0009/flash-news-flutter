import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// On a wide browser window, draws the app inside a phone-shaped frame.
///
/// Flash News is a phone app. Stretched across a desktop browser it looks
/// wrong, so the web build is centred at phone width instead. On Android, and
/// on a narrow browser, this returns the app untouched.
class WebShell extends StatelessWidget {
  const WebShell({super.key, required this.child});

  final Widget child;

  static const double _frameWidth = 400;
  static const double _breakpoint = 720;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < _breakpoint) return child;

        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        final double frameHeight =
            math.min(constraints.maxHeight - 56, 840).toDouble();

        return ColoredBox(
          color: isDark ? const Color(0xFF07090C) : const Color(0xFFE7EBF0),
          child: Center(
            child: Container(
              width: _frameWidth,
              height: frameHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    // Written as fromRGBO so it compiles on every Flutter
                    // version - withOpacity and withValues have each been in
                    // and out of favour.
                    color: Color.fromRGBO(0, 0, 0, isDark ? 0.5 : 0.14),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              // The app inside must believe it is on a phone-sized screen, so
              // MediaQuery is overridden as well as the box constraints.
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  size: Size(_frameWidth, frameHeight),
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
