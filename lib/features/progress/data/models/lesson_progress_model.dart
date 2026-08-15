import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/lesson_progress.dart';

part 'lesson_progress_model.freezed.dart';
part 'lesson_progress_model.g.dart';

@freezed
abstract class LessonProgressModel with _$LessonProgressModel {
  const factory LessonProgressModel({
    required String lessonId,
    required String courseId,
    required int positionSeconds,
    required int durationSeconds,
    required bool completed,
    required DateTime updatedAt,
  }) = _LessonProgressModel;

  const LessonProgressModel._();

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) =>
      _$LessonProgressModelFromJson(json);

  factory LessonProgressModel.fromEntity(LessonProgress entity) =>
      LessonProgressModel(
        lessonId: entity.lessonId,
        courseId: entity.courseId,
        positionSeconds: entity.positionSeconds,
        durationSeconds: entity.durationSeconds,
        completed: entity.completed,
        updatedAt: entity.updatedAt,
      );

  LessonProgress toEntity() => LessonProgress(
    lessonId: lessonId,
    courseId: courseId,
    positionSeconds: positionSeconds,
    durationSeconds: durationSeconds,
    completed: completed,
    updatedAt: updatedAt,
  );
}
