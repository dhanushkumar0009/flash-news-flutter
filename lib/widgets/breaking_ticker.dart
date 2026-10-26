import 'dart:async';

import 'package:flutter/material.dart';

import '../models/article.dart';
import '../theme/app_theme.dart';

/// The breaking-news banner: a red FLASH pill and a headline that changes
/// every four seconds.
///
/// A StatefulWidget because it owns a Timer and a PageController, both of
/// which must be released in dispose() or the app leaks them on every rebuild.
class BreakingTicker extends StatefulWidget {
  const BreakingTicker({
    super.key,
    required this.articles,
    required this.onTap,
  });

  final List<Article> articles;
  final void Function(Article article) onTap;

  @override
  State<BreakingTicker> createState() => _BreakingTickerState();
}

class _BreakingTickerState extends State<BreakingTicker> {
  static const Duration _interval = Duration(seconds: 4);

  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (widget.articles.length < 2) return;

    _timer = Timer.periodic(_interval, (Timer _) {
      if (!mounted || !_controller.hasClients) return;

      _index = (_index + 1) % widget.articles.length;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) return const SizedBox.shrink();

    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.accentSoft,
        border: Border(
          top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          bottom: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                SizedBox(width: 3),
                Text(
                  'FLASH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              itemCount: widget.articles.length,
              onPageChanged: (int page) => _index = page,
              itemBuilder: (BuildContext context, int index) {
                final Article article = widget.articles[index];

                return GestureDetector(
                  onTap: () => widget.onTap(article),
                  behavior: HitTestBehavior.opaque,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      article.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextStrong
                            : AppColors.accentDark,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
