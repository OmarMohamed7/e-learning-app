import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../categories/presentation/widgets/categories_explore_section.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../models/continue_learning_progress.dart';
import '../providers/courses_providers.dart';
import '../widgets/continue_learning_section.dart';
import '../widgets/home_header.dart';
import '../widgets/most_popular_class_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);
    final progress = ref.watch(progressControllerProvider);

    ContinueLearningProgress? continueLearning;
    final lastWatched = progress.lastWatchedCourse;
    if (lastWatched != null) {
      coursesAsync.whenData((courses) {
        for (final course in courses) {
          if (course.id != lastWatched.courseId) continue;

          continueLearning = ContinueLearningProgress(
            course: course.toEntity(),
            completedLessons: progress.completedCountForCourse(
              lastWatched.courseId,
            ),
            totalLessons: lastWatched.totalLessons,
          );
          break;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          HomeHeader(
            userName: 'Omar',
            onSearchTap: () => context.push('/search'),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 28,
                      children: [
                        ContinueLearningSection(
                          course: continueLearning,
                          onCourseTap: (course) =>
                              context.push('/course/${course.id}'),
                        ),
                        CategoriesExploreSection(
                          onCategoryTap: (categoryId) => context.push(
                            '/category/$categoryId?categoryName=${Uri.encodeComponent(categoryId)}',
                          ),
                        ),
                        MostPopularClassSection(
                          courses: coursesAsync.maybeWhen(
                            data: (courses) =>
                                courses.map((e) => e.toEntity()).toList(),
                            orElse: () => [],
                          ),
                          onCourseTap: (course) =>
                              context.push('/course/${course.id}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
