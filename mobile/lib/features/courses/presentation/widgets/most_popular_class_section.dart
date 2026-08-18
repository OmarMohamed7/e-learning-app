import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/course.dart';
import 'popular_class_card.dart';

class MostPopularClassSection extends StatelessWidget {
  const MostPopularClassSection({
    required this.courses,
    this.onSeeAll,
    this.onCourseTap,
    super.key,
  });

  final List<Course> courses;
  final VoidCallback? onSeeAll;
  final ValueChanged<Course>? onCourseTap;

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'mostPopularClassTitle'.tr(), onSeeAll: onSeeAll),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final course = courses[index];
              return PopularClassCard(
                course: course,
                onTap: onCourseTap == null ? null : () => onCourseTap!(course),
              );
            },
          ),
        ),
      ],
    );
  }
}
