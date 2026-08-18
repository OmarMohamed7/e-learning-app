// ignore: file_names
import '../entities/lesson_progress.dart';

typedef LastWatchedCourse = ({
  String courseId,
  String courseTitle,
  int totalLessons,
});

abstract interface class IProgressRepository {
  List<LessonProgress> getAllProgress();

  Future<void> saveLessonProgress(LessonProgress progress);

  LastWatchedCourse? getLastWatchedCourse();

  Future<void> setLastWatchedCourse(
    String courseId,
    String courseTitle,
    int totalLessons,
  );
}
