import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/continue_learning_progress.dart';

/// Card showing a course thumbnail, title, and lesson-progress bar.
class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({
    required this.progress,
    this.onTap,
    super.key,
  });

  final ContinueLearningProgress progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (progress.completionRatio * 100).round();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      progress.course.thumbnailUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 64,
                        height: 64,
                        color: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.play_circle_outline_rounded,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      progress.course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.completionRatio,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'lessonsProgress'.tr(
                      namedArgs: {
                        'completed': '${progress.completedLessons}',
                        'total': '${progress.totalLessons}',
                      },
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'percentCompleted'.tr(
                      namedArgs: {'percent': '$percent'},
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
