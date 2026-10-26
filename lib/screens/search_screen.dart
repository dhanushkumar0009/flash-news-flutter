import 'package:flutter/material.dart';

import '../data/sample_articles.dart';
import '../models/article.dart';
import '../widgets/news_card.dart';
import '../widgets/state_views.dart';
import 'article_detail_screen.dart';

/// Search across every article. Filtering happens on each keystroke in
/// setState, which is fast enough for a local list and keeps the code simple.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Article.matches() checks the headline, summary, source and category, so
  /// "sports", "Reuters" and "cricket" all return sensible results.
  List<Article> get _results {
    if (_query.trim().isEmpty) return const <Article>[];

    final List<Article> found =
        kArticles.where((Article article) => article.matches(_query)).toList();
    found.sort((Article a, Article b) => b.publishedAt.compareTo(a.publishedAt));
    return found;
  }

  void _openArticle(Article article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Article> results = _results;
    final bool hasQuery = _query.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              maxLength: 60,
              onChanged: (String value) => setState(() => _query = value),
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Search headlines, sources or categories',
                prefixIcon: const Icon(Icons.search, size: 21),
                suffixIcon: hasQuery
                    ? IconButton(
                        tooltip: 'Clear',
                        icon: const Icon(Icons.close, size: 19),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (hasQuery)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  results.isEmpty
                      ? 'No results'
                      : '${results.length} ${results.length == 1 ? 'result' : 'results'}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (!hasQuery) {
                  return const EmptyView(
                    icon: Icons.search,
                    title: 'Search Flash News',
                    message:
                        'Start typing to filter all stories by headline, summary, '
                        'source or category.',
                  );
                }

                if (results.isEmpty) {
                  return EmptyView(
                    icon: Icons.search_off,
                    title: 'Nothing matched "${_query.trim()}"',
                    message:
                        'Try a shorter word, or search a category such as Sports '
                        'or Technology.',
                    actionLabel: 'Clear search',
                    onAction: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final Article article = results[index];
                    return NewsCard(
                      article: article,
                      onTap: () => _openArticle(article),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
