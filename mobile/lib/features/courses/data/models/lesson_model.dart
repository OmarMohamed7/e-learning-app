import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/lesson.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
abstract class LessonModel with _$LessonModel {
  const factory LessonModel({
    required String id,
    required String courseId,
    required String title,
    required String description,
    required int order,
    required int durationSeconds,
    required String thumbnailUrl,
    String? masterPlaylistUrl,
  }) = _LessonModel;

  const LessonModel._();

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);

  factory LessonModel.fromEntity(Lesson entity) => LessonModel(
    id: entity.id,
    courseId: entity.courseId,
    title: entity.title,
    description: entity.description,
    order: entity.order,
    durationSeconds: entity.durationSeconds,
    thumbnailUrl: entity.thumbnailUrl,
    masterPlaylistUrl: entity.masterPlaylistUrl,
  );

  Lesson toEntity() => Lesson(
    id: id,
    courseId: courseId,
    title: title,
    description: description,
    order: order,
    durationSeconds: durationSeconds,
    thumbnailUrl: thumbnailUrl,
    masterPlaylistUrl: masterPlaylistUrl,
  );
}
