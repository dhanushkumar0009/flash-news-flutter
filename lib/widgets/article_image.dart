import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A network image that never breaks the layout.
///
/// Three states: a grey placeholder while loading, the image when it arrives,
/// and a labelled fallback when the device is offline or the URL is dead.
/// Real news feeds serve broken image links constantly, so this matters.
class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.url,
    required this.height,
    this.width = double.infinity,
    this.borderRadius,
  });

  final String url;
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color placeholder = isDark ? AppColors.darkBorder : const Color(0xFFEDF1F5);
    final Color iconColor = isDark ? AppColors.darkTextFaint : AppColors.lightTextFaint;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
            if (progress == null) return child;
            return Container(
              color: placeholder,
              alignment: Alignment.center,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: iconColor,
                ),
              ),
            );
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
            return Container(
              color: placeholder,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.image_not_supported_outlined, color: iconColor, size: height > 120 ? 30 : 20),
                  if (height > 120) ...<Widget>[
                    const SizedBox(height: 6),
                    Text(
                      'Image unavailable',
                      style: TextStyle(color: iconColor, fontSize: 12),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
