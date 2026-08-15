import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/section_header.dart';
import '../providers/categories_providers.dart';
import '../models/explore_topic.dart';
import 'category_icon_mapper.dart';
import 'explore_topics_row_shimmer.dart';
import 'topic_item_widget.dart';

class CategoriesExploreSection extends ConsumerWidget {
  const CategoriesExploreSection({
    this.onSeeAll,
    this.onCategoryTap,
    super.key,
  });

  final VoidCallback? onSeeAll;
  final ValueChanged<String>? onCategoryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'exploreTopicsTitle'.tr(), onSeeAll: onSeeAll),
        const SizedBox(height: 12),
        categoriesAsync.when(
          data: (categories) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final category in categories)
                TopicItem(
                  topicName: category.name,
                  onTap: onCategoryTap == null
                      ? null
                      : () => onCategoryTap!(category.name),
                ),
            ],
          ),
          loading: () => const ExploreTopicsShimmer(),
          error: (error, stackTrace) => Row(
            children: [
              Expanded(
                child: Text(
                  'genericError'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () => ref.invalidate(categoriesProvider),
                child: Text('retry'.tr()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
