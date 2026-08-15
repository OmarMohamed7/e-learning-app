import 'package:flutter/material.dart';

import '../models/explore_topic.dart';

/// A single circular icon + label in the "Explore Topics" row.
class TopicItem extends StatelessWidget {
  const TopicItem({required this.topic, this.onTap, super.key});

  final ExploreTopic topic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: scheme.primary.withValues(alpha: 0.1),
              child: Icon(topic.icon, color: scheme.primary),
            ),
            const SizedBox(height: 8),
            Text(topic.label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
