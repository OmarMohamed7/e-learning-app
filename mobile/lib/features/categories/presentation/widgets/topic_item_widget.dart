import 'package:flutter/material.dart';
import 'package:mentor_stream_flutter/features/categories/presentation/widgets/category_icon_mapper.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({required this.topicName, this.onTap, super.key});

  final String topicName;
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
              child: Icon(
                CategoryIconMapper.resolve(topicName),
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(topicName, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
