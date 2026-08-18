import 'package:flutter/material.dart';
import 'package:mentor_stream_flutter/features/categories/presentation/widgets/category_icon_mapper.dart';

import '../../../../core/extensions/string_extensions.dart';
import '../../data/models/category_model.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({required this.category, this.onTap, super.key});

  final CategoryModel category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = CategoryIconMapper.colorFor(category) ?? scheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(CategoryIconMapper.iconFor(category), color: color),
            ),
            const SizedBox(height: 8),
            Text(
              category.name.capitalizeFirst,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
