import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Horizontally scrolling category filter.
///
/// The selected chip is filled with the brand red so the active filter is
/// obvious at a glance.
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final Color idleText = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          final String category = categories[index];
          final bool isActive = category == selected;

          return Semantics(
            selected: isActive,
            button: true,
            label: '$category category',
            child: GestureDetector(
              onTap: () => onSelected(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accent : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: isActive ? AppColors.accent : border),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isActive ? Colors.white : idleText,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
