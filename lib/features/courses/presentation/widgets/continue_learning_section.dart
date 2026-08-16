import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/course.dart';
import '../models/continue_learning_progress.dart';
import 'continue_learning_card.dart';

class ContinueLearningSection extends ConsumerWidget {
  final ContinueLearningProgress? course;
  final void Function(Course course)? onCourseTap;

  const ContinueLearningSection({super.key, this.course, this.onCourseTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return course != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'continueLearningTitle'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ContinueLearningCard(
                progress: ContinueLearningProgress(
                  course: course!.course,
                  completedLessons: course!.completedLessons,
                ),
                onTap: () =>
                    onCourseTap == null ? null : onCourseTap!(course!.course),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
