import 'package:flutter/material.dart';

import '../data/sample_articles.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';
import '../widgets/news_card.dart';
import '../widgets/state_views.dart';
import 'article_detail_screen.dart';

/// Saved Articles. Reads straight from BookmarkService, so it never holds its
/// own copy of the list and can never fall out of sync with the rest of the app.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  void _openArticle(BuildContext context, Article article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove all saved articles?'),
          content: const Text('This clears your saved list on this device.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.accent),
              child: const Text('Remove all'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await BookmarkService.instance.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: BookmarkService.instance.savedIds,
      builder: (BuildContext context, Set<String> saved, Widget? _) {
        final List<Article> articles =
            BookmarkService.instance.savedArticles(kArticles);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Articles'),
            actions: <Widget>[
              if (articles.isNotEmpty)
                IconButton(
                  tooltip: 'Remove all',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmClear(context),
                ),
            ],
          ),
          body: articles.isEmpty
              ? EmptyView(
                  icon: Icons.bookmark_border,
                  title: 'No saved articles yet',
                  message:
                      'Tap the bookmark icon on any story to keep it here. Saved '
                      'articles stay on this device, even after you close the app.',
                  actionLabel: 'Browse news',
                  onAction: () => Navigator.of(context).pop(),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: articles.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return SectionHeader(
                        title: 'Your list',
                        trailing:
                            '${articles.length} ${articles.length == 1 ? 'article' : 'articles'}',
                      );
                    }

                    final Article article = articles[index - 1];

                    // Swipe left or right to remove, which is the gesture
                    // people expect from a saved list.
                    return Dismissible(
                      key: ValueKey<String>(article.id),
                      background: _swipeBackground(Alignment.centerLeft),
                      secondaryBackground:
                          _swipeBackground(Alignment.centerRight),
                      onDismissed: (_) async {
                        await BookmarkService.instance.toggle(article.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from Saved Articles.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: NewsCard(
                        article: article,
                        onTap: () => _openArticle(context, article),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _swipeBackground(Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white),
    );
  }
}
