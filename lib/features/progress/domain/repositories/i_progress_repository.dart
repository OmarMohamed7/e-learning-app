// ignore: file_names
import '../entities/lesson_progress.dart';

abstract interface class IProgressRepository {
  List<LessonProgress> getAllProgress();

  Future<void> saveLessonProgress(LessonProgress progress);

  String? getLastWatchedCourseId();

  Future<void> setLastWatchedCourseId(String courseId, String courseTitle);
}
