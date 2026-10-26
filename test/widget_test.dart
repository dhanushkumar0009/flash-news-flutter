import 'package:flash_news/data/sample_articles.dart';
import 'package:flash_news/models/article.dart';
import 'package:flutter_test/flutter_test.dart';

/// Two small checks you can run with `flutter test`.
///
/// They test the data and the search logic rather than the screens, because
/// those need no device and no network.
void main() {
  test('every article has a unique id and a category from the chip list', () {
    final Set<String> ids = <String>{};

    for (final Article article in kArticles) {
      expect(ids.add(article.id), isTrue, reason: 'duplicate id ${article.id}');
      expect(kCategories.contains(article.category), isTrue,
          reason: '${article.category} is not in kCategories');
    }

    expect(kArticles.length, greaterThan(10));
  });

  test('search matches on title, source and category', () {
    final Article article = kArticles.first;

    expect(article.matches(article.source), isTrue);
    expect(article.matches(article.category.toLowerCase()), isTrue);
    expect(article.matches('zzzzzznotarealword'), isFalse);
    expect(article.matches('   '), isTrue, reason: 'blank query matches all');
  });
}
