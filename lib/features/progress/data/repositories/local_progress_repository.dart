import 'package:isar_community/isar.dart';

import '../../domain/entities/lesson_progress.dart';
import '../../domain/repositories/i_progress_repository.dart';
import '../models/last_watched_course_isar.dart';
import '../models/lesson_progress_isar.dart';

const _lastWatchedCourseRowId = 0;

/// [IProgressRepository] backed by Isar — there's no user account/backend
/// for progress yet, so it's tracked on-device only.
class LocalProgressRepository implements IProgressRepository {
  LocalProgressRepository({required Isar isar}) : _isar = isar;

  final Isar _isar;

  @override
  List<LessonProgress> getAllProgress() {
    return _isar.lessonProgressIsars
        .where()
        .findAllSync()
        .map((row) => row.toEntity())
        .toList();
  }

  @override
  Future<void> saveLessonProgress(LessonProgress progress) {
    return _isar.writeTxn(
      () => _isar.lessonProgressIsars.put(
        LessonProgressIsar.fromEntity(progress),
      ),
    );
  }

  @override
  LastWatchedCourse? getLastWatchedCourse() {
    final row = _isar.lastWatchedCourseIsars.getSync(_lastWatchedCourseRowId);
    if (row == null) return null;
    return (
      courseId: row.courseId,
      courseTitle: row.courseTitle,
      totalLessons: row.totalLessons,
    );
  }

  @override
  Future<void> setLastWatchedCourse(
    String courseId,
    String courseTitle,
    int totalLessons,
  ) {
    return _isar.writeTxn(
      () => _isar.lastWatchedCourseIsars.put(
        LastWatchedCourseIsar()
          ..id = _lastWatchedCourseRowId
          ..courseId = courseId
          ..courseTitle = courseTitle
          ..totalLessons = totalLessons,
      ),
    );
  }
}
