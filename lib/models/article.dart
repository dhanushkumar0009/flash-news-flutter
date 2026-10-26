/// A single news story.
///
/// Everything the app shows comes from this one shape, so the same widget can
/// render a featured story, a list card, or a search result.
class Article {
  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.body,
    required this.category,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.url,
    this.isBreaking = false,
  });

  final String id;
  final String title;
  final String description;

  /// Longer sample text, used by the Standard and Full reading modes.
  final String body;

  final String category;
  final String source;
  final DateTime publishedAt;
  final String imageUrl;
  final String url;
  final bool isBreaking;

  /// "3 hours ago" style text for the card meta line.
  String get relativeTime {
    final difference = DateTime.now().difference(publishedAt);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }
    final days = difference.inDays;
    if (days < 7) return '$days ${days == 1 ? 'day' : 'days'} ago';
    return formattedDate;
  }

  /// "25 Oct 2026" - written by hand so the app needs no date package.
  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${publishedAt.day} ${months[publishedAt.month - 1]} ${publishedAt.year}';
  }

  /// Used by the search screen. Matching on several fields at once means a
  /// search for "cricket" finds a story whose title never says the word.
  bool matches(String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return true;

    return title.toLowerCase().contains(term) ||
        description.toLowerCase().contains(term) ||
        source.toLowerCase().contains(term) ||
        category.toLowerCase().contains(term);
  }
}
