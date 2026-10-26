import 'package:flutter/material.dart';

import '../data/sample_articles.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../widgets/breaking_ticker.dart';
import '../widgets/brand_mark.dart';
import '../widgets/category_chips.dart';
import '../widgets/featured_card.dart';
import '../widgets/news_card.dart';
import '../widgets/state_views.dart';
import 'article_detail_screen.dart';
import 'saved_screen.dart';
import 'search_screen.dart';

/// The main screen: breaking banner, search entry, category chips, a featured
/// story and the latest list, all under a pull-to-refresh.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = kCategories.first; // 'All'
  bool _isLoading = true;

  /// Rebuilt on refresh so the list visibly changes order, the way a real feed
  /// would after fetching.
  late List<Article> _articles = List<Article>.of(kArticles);

  @override
  void initState() {
    super.initState();
    _firstLoad();
  }

  /// A short delay on launch so the skeleton cards are shown once. The data is
  /// local, so without this the loading state would never be visible.
  Future<void> _firstLoad() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _articles = List<Article>.of(kArticles)
        ..sort((Article a, Article b) => b.publishedAt.compareTo(a.publishedAt));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feed refreshed.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// 'All' means no filter; every other chip keeps only its own category.
  List<Article> get _visible {
    final List<Article> filtered = _category == 'All'
        ? List<Article>.of(_articles)
        : _articles
            .where((Article article) => article.category == _category)
            .toList();

    filtered
        .sort((Article a, Article b) => b.publishedAt.compareTo(a.publishedAt));
    return filtered;
  }

  List<Article> get _breaking =>
      _articles.where((Article article) => article.isBreaking).toList();

  void _openArticle(Article article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
    );
  }

  void _openSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SavedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Article> visible = _visible;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const BrandMark(size: 30),
        actions: <Widget>[
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeService.instance.mode,
            builder: (BuildContext context, ThemeMode mode, Widget? _) {
              final bool isDark =
                  Theme.of(context).brightness == Brightness.dark;
              return IconButton(
                tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                icon: Icon(isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined),
                onPressed: () => ThemeService.instance.toggle(),
              );
            },
          ),
          ValueListenableBuilder<Set<String>>(
            valueListenable: BookmarkService.instance.savedIds,
            builder: (BuildContext context, Set<String> saved, Widget? _) {
              return IconButton(
                tooltip: 'Saved articles',
                onPressed: _openSaved,
                icon: Badge(
                  isLabelVisible: saved.isNotEmpty,
                  label: Text('${saved.length}'),
                  backgroundColor: AppColors.accent,
                  child: const Icon(Icons.bookmark_border),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: <Widget>[
          BreakingTicker(articles: _breaking, onTap: _openArticle),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppColors.accent,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 28),
                children: <Widget>[
                  const SizedBox(height: 14),
                  _SearchEntry(onTap: _openSearch),
                  const SizedBox(height: 14),
                  CategoryChips(
                    categories: kCategories,
                    selected: _category,
                    onSelected: (String category) {
                      if (category == _category) return;
                      setState(() => _category = category);
                    },
                  ),
                  const SizedBox(height: 18),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CardSkeleton(count: 4),
                    )
                  else if (visible.isEmpty)
                    EmptyView(
                      icon: Icons.inbox_outlined,
                      title: 'Nothing in $_category right now',
                      message:
                          'Pick another category, or pull down to refresh the feed.',
                      actionLabel: 'Show all news',
                      onAction: () => setState(() => _category = 'All'),
                    )
                  else
                    ..._feed(visible),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Featured story first, then the rest as list cards.
  List<Widget> _feed(List<Article> visible) {
    final Article featured = visible.first;
    final List<Article> rest = visible.skip(1).toList();

    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(
              title: _category == 'All' ? 'Featured' : '$_category · Featured',
            ),
            FeaturedCard(
              article: featured,
              onTap: () => _openArticle(featured),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Latest',
              trailing: '${visible.length} stories',
            ),
          ],
        ),
      ),
      ...rest.map((Article article) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: NewsCard(
            article: article,
            onTap: () => _openArticle(article),
          ),
        );
      }),
    ];
  }
}

/// A tappable box that looks like a search field but opens the search screen.
/// Keeping the real TextField on its own screen means the home list is never
/// rebuilt while someone types.
class _SearchEntry extends StatelessWidget {
  const _SearchEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Semantics(
        button: true,
        label: 'Search news',
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.search, size: 20, color: theme.textTheme.bodySmall?.color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search headlines, sources or categories',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
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
