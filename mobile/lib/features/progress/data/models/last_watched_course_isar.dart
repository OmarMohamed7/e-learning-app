import 'package:isar_community/isar.dart';

part 'last_watched_course_isar.g.dart';

/// Singleton row (fixed [id]) holding the id of the last course a video was
/// opened for.
@collection
class LastWatchedCourseIsar {
  Id id = 0;

  late String courseId;

  late String courseTitle;

  late int totalLessons;
}
