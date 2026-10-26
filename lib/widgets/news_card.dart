import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';
import 'article_image.dart';

/// The standard list card: thumbnail on the left, headline and meta on the
/// right, bookmark button in the corner.
///
/// Used by Home, Search and Saved, so all three lists look identical.
class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    this.onBookmarkChanged,
  });

  final Article article;
  final VoidCallback onTap;

  /// Called after the bookmark is toggled. Saved screen uses it to show a
  /// message; Home ignores it.
  final void Function(bool nowSaved)? onBookmarkChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Semantics(
      button: true,
      label: article.title,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ArticleImage(
                  url: article.imageUrl,
                  height: 92,
                  width: 112,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              article.category.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          _BookmarkButton(
                            article: article,
                            onChanged: onBookmarkChanged,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${article.source} · ${article.relativeTime}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
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

/// Bookmark icon that listens to the service, so tapping it on one screen
/// updates every other screen showing the same article.
class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.article, this.onChanged});

  final Article article;
  final void Function(bool nowSaved)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: BookmarkService.instance.savedIds,
      builder: (BuildContext context, Set<String> saved, Widget? _) {
        final bool isSaved = saved.contains(article.id);

        return IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          tooltip: isSaved ? 'Remove from saved' : 'Save article',
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            size: 21,
            color: isSaved
                ? AppColors.accent
                : Theme.of(context).textTheme.bodySmall?.color,
          ),
          onPressed: () async {
            final bool nowSaved =
                await BookmarkService.instance.toggle(article.id);
            onChanged?.call(nowSaved);
          },
        );
      },
    );
  }
}
