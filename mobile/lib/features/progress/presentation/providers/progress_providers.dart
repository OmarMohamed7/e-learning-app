import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/isar_provider.dart';
import '../../data/repositories/local_progress_repository.dart';
import '../../domain/entities/lesson_progress.dart';
import '../../domain/repositories/i_progress_repository.dart';

final Provider<IProgressRepository> progressRepositoryProvider =
    Provider<IProgressRepository>((ref) {
      return LocalProgressRepository(isar: ref.watch(isarProvider));
    });

class ProgressState {
  const ProgressState({
    required this.lastWatchedCourse,
    required this.lessonProgress,
  });

  final LastWatchedCourse? lastWatchedCourse;

  /// Keyed by lessonId.
  final Map<String, LessonProgress> lessonProgress;

  bool isLessonCompleted(String lessonId) =>
      lessonProgress[lessonId]?.completed ?? false;

  int completedCountForCourse(String courseId) => lessonProgress.values
      .where((progress) => progress.courseId == courseId && progress.completed)
      .length;
}

class ProgressController extends Notifier<ProgressState> {
  late final IProgressRepository _repository;

  @override
  ProgressState build() {
    _repository = ref.watch(progressRepositoryProvider);
    return ProgressState(
      lastWatchedCourse: _repository.getLastWatchedCourse(),
      lessonProgress: {
        for (final progress in _repository.getAllProgress())
          progress.lessonId: progress,
      },
    );
  }

  Future<void> setLastWatchedCourse(
    String courseId,
    String courseTitle,
    int totalLessons,
  ) async {
    if (state.lastWatchedCourse?.courseId == courseId) return;
    await _repository.setLastWatchedCourse(courseId, courseTitle, totalLessons);
    state = ProgressState(
      lastWatchedCourse: (
        courseId: courseId,
        courseTitle: courseTitle,
        totalLessons: totalLessons,
      ),
      lessonProgress: state.lessonProgress,
    );
  }

  Future<void> markLessonCompleted({
    required String lessonId,
    required String courseId,
    required int durationSeconds,
  }) async {
    if (state.isLessonCompleted(lessonId)) return;

    final progress = LessonProgress(
      lessonId: lessonId,
      courseId: courseId,
      positionSeconds: durationSeconds,
      durationSeconds: durationSeconds,
      completed: true,
      updatedAt: DateTime.now(),
    );

    await _repository.saveLessonProgress(progress);
    state = ProgressState(
      lastWatchedCourse: state.lastWatchedCourse,
      lessonProgress: {...state.lessonProgress, lessonId: progress},
    );
  }
}

final NotifierProvider<ProgressController, ProgressState>
progressControllerProvider =
    NotifierProvider<ProgressController, ProgressState>(ProgressController.new);
