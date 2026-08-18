// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonProgressModel _$LessonProgressModelFromJson(Map<String, dynamic> json) =>
    _LessonProgressModel(
      lessonId: json['lessonId'] as String,
      courseId: json['courseId'] as String,
      positionSeconds: (json['positionSeconds'] as num).toInt(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      completed: json['completed'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LessonProgressModelToJson(
  _LessonProgressModel instance,
) => <String, dynamic>{
  'lessonId': instance.lessonId,
  'courseId': instance.courseId,
  'positionSeconds': instance.positionSeconds,
  'durationSeconds': instance.durationSeconds,
  'completed': instance.completed,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
