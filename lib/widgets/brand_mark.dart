import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Flash News logo, drawn in code rather than loaded from an image file.
///
/// Keeps the app free of binary assets and means the mark stays sharp at any
/// size and in either theme.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 34, this.showWordmark = true});

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(size * 0.26),
          ),
          child: Icon(
            Icons.bolt_rounded,
            color: Colors.white,
            size: size * 0.66,
          ),
        ),
        if (showWordmark) ...<Widget>[
          const SizedBox(width: 10),
          Text(
            'Flash News',
            style: TextStyle(
              color: textColor,
              fontSize: size * 0.52,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ],
    );
  }
}
