import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/continue_learning_progress.dart';
import 'continue_learning_card.dart';

/// The "Continue Learning" section. Renders nothing when [progress] is
/// null, i.e. the learner has no course currently in progress.
class ContinueLearningSection extends StatelessWidget {
  const ContinueLearningSection({required this.progress, this.onTap, super.key});

  final ContinueLearningProgress? progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = this.progress;
    if (progress == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'continueLearningTitle'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ContinueLearningCard(progress: progress, onTap: onTap),
      ],
    );
  }
}
