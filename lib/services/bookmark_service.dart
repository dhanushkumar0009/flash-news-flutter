import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';

/// Stores saved article ids on the device with shared_preferences.
///
/// A single shared instance holds the ids in a [ValueNotifier], so any screen
/// can wrap itself in a ValueListenableBuilder and rebuild the moment an
/// article is saved or removed - no state management package needed.
class BookmarkService {
  BookmarkService._();

  static final BookmarkService instance = BookmarkService._();

  static const String _storageKey = 'flashnews.bookmarks';

  final ValueNotifier<Set<String>> savedIds = ValueNotifier<Set<String>>(<String>{});

  /// Called once at startup, before the first screen is shown.
  Future<void> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> stored = prefs.getStringList(_storageKey) ?? <String>[];
      savedIds.value = stored.toSet();
    } catch (_) {
      // Storage can fail on a locked or full device. An empty set is a safe
      // fallback - the app still runs, bookmarks just do not persist.
      savedIds.value = <String>{};
    }
  }

  bool isSaved(String articleId) => savedIds.value.contains(articleId);

  /// Saves the article if it is not saved, removes it if it is.
  /// Returns true when the article ended up saved.
  Future<bool> toggle(String articleId) async {
    final Set<String> updated = Set<String>.from(savedIds.value);
    final bool nowSaved = !updated.contains(articleId);

    if (nowSaved) {
      updated.add(articleId);
    } else {
      updated.remove(articleId);
    }

    // Update the UI first so the button responds immediately, then persist.
    savedIds.value = updated;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, updated.toList());
    } catch (_) {
      // Ignore - the in-memory set is still correct for this session.
    }

    return nowSaved;
  }

  Future<void> clearAll() async {
    savedIds.value = <String>{};
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (_) {}
  }

  /// Saved articles, newest first, resolved against the full article list.
  List<Article> savedArticles(List<Article> all) {
    final List<Article> result =
        all.where((Article article) => savedIds.value.contains(article.id)).toList();
    result.sort((Article a, Article b) => b.publishedAt.compareTo(a.publishedAt));
    return result;
  }
}
