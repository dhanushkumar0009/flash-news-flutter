import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';
import '../widgets/article_image.dart';

/// How much of the story to show. Mirrors the Quick / Standard / Detailed
/// reading views on the website.
enum ReadingMode { short, standard, full }

/// Full article view. Every field shown comes from the Article that was tapped,
/// so two different cards never show the same text.
class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  ReadingMode _mode = ReadingMode.standard;

  Article get _article => widget.article;

  /// Body text for the current reading mode.
  String get _bodyText {
    final List<String> paragraphs = _article.body.split('\n\n');

    switch (_mode) {
      case ReadingMode.short:
        return '';
      case ReadingMode.standard:
        return paragraphs.first;
      case ReadingMode.full:
        return _article.body;
    }
  }

  Future<void> _openInBrowser() async {
    final Uri uri = Uri.parse(_article.url);

    try {
      final bool launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) _notify('Could not open the link on this device.');
    } catch (_) {
      _notify('Could not open the link on this device.');
    }
  }

  Future<void> _share() async {
    await Clipboard.setData(ClipboardData(
      text: '${_article.title}\n\n${_article.description}\n\n${_article.url}',
    ));
    _notify('Headline and link copied — paste it anywhere to share.');
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_article.category),
        actions: <Widget>[
          ValueListenableBuilder<Set<String>>(
            valueListenable: BookmarkService.instance.savedIds,
            builder: (BuildContext context, Set<String> saved, Widget? _) {
              final bool isSaved = saved.contains(_article.id);

              return IconButton(
                tooltip: isSaved ? 'Remove from saved' : 'Save article',
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? AppColors.accent : null,
                ),
                onPressed: () async {
                  final bool nowSaved =
                      await BookmarkService.instance.toggle(_article.id);
                  _notify(nowSaved
                      ? 'Added to Saved Articles.'
                      : 'Removed from Saved Articles.');
                },
              );
            },
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_outlined),
            onPressed: _share,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: <Widget>[
          ArticleImage(
            url: _article.imageUrl,
            height: 210,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _article.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    if (_article.isBreaking) ...<Widget>[
                      const SizedBox(width: 8),
                      const Text(
                        'BREAKING',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(_article.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 10),
                Text(
                  '${_article.source} · ${_article.formattedDate} · ${_article.relativeTime}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                _ModeSelector(
                  mode: _mode,
                  onChanged: (ReadingMode mode) => setState(() => _mode = mode),
                ),
                const SizedBox(height: 18),
                Text(
                  _article.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15.5,
                    height: 1.55,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                if (_bodyText.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 14),
                  Text(
                    _bodyText,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontSize: 15, height: 1.65),
                  ),
                ],
                if (_mode == ReadingMode.short) ...<Widget>[
                  const SizedBox(height: 14),
                  Text(
                    'Short mode shows the summary only. Switch to Standard or '
                    'Full above to read more.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 26),
                OutlinedButton.icon(
                  onPressed: _openInBrowser,
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('Read on publisher site'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Three-way reading mode switch.
class _ModeSelector extends StatelessWidget {
  const _ModeSelector({required this.mode, required this.onChanged});

  final ReadingMode mode;
  final ValueChanged<ReadingMode> onChanged;

  static const Map<ReadingMode, String> _labels = <ReadingMode, String>{
    ReadingMode.short: 'Short',
    ReadingMode.standard: 'Standard',
    ReadingMode.full: 'Full',
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: border),
      ),
      child: Row(
        children: ReadingMode.values.map((ReadingMode value) {
          final bool isActive = value == mode;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _labels[value]!,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
