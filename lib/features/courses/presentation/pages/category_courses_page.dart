import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/courses_providers.dart';
import '../widgets/popular_class_card.dart';

class CategoryCoursesPage extends ConsumerWidget {
  const CategoryCoursesPage({
    required this.categoryId,
    required this.categoryName,
    super.key,
  });

  final String categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesByCategoryProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: coursesAsync.when(
        data: (courses) {
          if (courses.isEmpty) {
            return Center(child: Text('noCoursesFound'.tr()));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: courses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final course = courses[index];
              return PopularClassCard(
                course: course.toEntity(),
                width: double.infinity,
                onTap: () => context.push('/course/${course.id}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('genericError'.tr()),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    ref.invalidate(coursesByCategoryProvider(categoryId)),
                child: Text('retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
