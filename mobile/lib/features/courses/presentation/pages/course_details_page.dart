import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../progress/presentation/providers/progress_providers.dart';
import '../../data/models/course_model.dart';
import '../providers/courses_providers.dart';
import '../widgets/video_lesson_card.dart';

class CourseDetailsPage extends ConsumerWidget {
  const CourseDetailsPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);
    final videosAsync = ref.watch(courseVideosProvider(courseId));
    final progress = ref.watch(progressControllerProvider);

    CourseModel? course;
    coursesAsync.whenData((courses) {
      for (final candidate in courses) {
        if (candidate.id == courseId) {
          course = candidate;
          break;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(course?.title ?? courseId)),
      body: videosAsync.when(
        data: (videos) {
          if (videos.isEmpty) {
            return Center(child: Text('noCoursesFound'.tr()));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: videos.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final video = videos[index];
              return VideoLessonCard(
                video: video,
                index: index,
                thumbnailUrl: course?.thumbnailUrl,
                completed: progress.isLessonCompleted(video.id),
                onTap: () => context.push(
                  '/course/$courseId/lesson/${video.id}'
                  '?courseTitle=${Uri.encodeComponent(course?.title ?? courseId)}',
                ),
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
                    ref.invalidate(courseVideosProvider(courseId)),
                child: Text('retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
