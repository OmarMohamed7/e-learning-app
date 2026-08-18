import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A section title paired with an optional "See All" action, reused by any
/// horizontally-scrolling or grid content section on a page.
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.onSeeAll, super.key});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text('seeAll'.tr()),
          ),
      ],
    );
  }
}
