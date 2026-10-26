import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';
import 'article_image.dart';

/// The large card at the top of the Featured section: wide image, category
/// badge, headline and a two-line summary.
class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key, required this.article, required this.onTap});

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Semantics(
      button: true,
      label: 'Featured story: ${article.title}',
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ArticleImage(
                      url: article.imageUrl,
                      height: 184,
                      borderRadius: BorderRadius.zero,
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${article.source} · ${article.relativeTime}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          ValueListenableBuilder<Set<String>>(
                            valueListenable: BookmarkService.instance.savedIds,
                            builder: (BuildContext context, Set<String> saved,
                                Widget? _) {
                              final bool isSaved = saved.contains(article.id);
                              return IconButton(
                                visualDensity: VisualDensity.compact,
                                tooltip: isSaved
                                    ? 'Remove from saved'
                                    : 'Save article',
                                icon: Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  size: 22,
                                  color: isSaved
                                      ? AppColors.accent
                                      : theme.textTheme.bodySmall?.color,
                                ),
                                onPressed: () => BookmarkService.instance
                                    .toggle(article.id),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
