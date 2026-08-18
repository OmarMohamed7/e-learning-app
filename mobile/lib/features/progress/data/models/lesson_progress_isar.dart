import 'package:isar_community/isar.dart';

import '../../domain/entities/lesson_progress.dart';

part 'lesson_progress_isar.g.dart';

@collection
class LessonProgressIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String lessonId;

  late String courseId;
  late int positionSeconds;
  late int durationSeconds;
  late bool completed;
  late DateTime updatedAt;

  LessonProgress toEntity() => LessonProgress(
    lessonId: lessonId,
    courseId: courseId,
    positionSeconds: positionSeconds,
    durationSeconds: durationSeconds,
    completed: completed,
    updatedAt: updatedAt,
  );

  static LessonProgressIsar fromEntity(LessonProgress entity) =>
      LessonProgressIsar()
        ..lessonId = entity.lessonId
        ..courseId = entity.courseId
        ..positionSeconds = entity.positionSeconds
        ..durationSeconds = entity.durationSeconds
        ..completed = entity.completed
        ..updatedAt = entity.updatedAt;
}
