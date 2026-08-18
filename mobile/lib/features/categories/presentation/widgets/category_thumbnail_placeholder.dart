import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';
import 'category_icon_mapper.dart';

/// A themed fallback shown in place of a course thumbnail when there's no
/// real image yet (or it fails to load) — a colored tile with the
/// category's icon, so it still reads as "this category" instead of a
/// blank box or an unrelated stock photo.
class CategoryThumbnailPlaceholder extends StatelessWidget {
  const CategoryThumbnailPlaceholder({
    required this.category,
    this.iconSize = 40,
    super.key,
  });

  final CategoryModel category;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: CategoryIconMapper.colorFor(category) ?? theme.colorScheme.primary,
      alignment: Alignment.center,
      child: Icon(
        CategoryIconMapper.iconFor(category),
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}
