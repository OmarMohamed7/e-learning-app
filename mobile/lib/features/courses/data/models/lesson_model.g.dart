// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonModel _$LessonModelFromJson(Map<String, dynamic> json) => _LessonModel(
  id: json['id'] as String,
  courseId: json['courseId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  order: (json['order'] as num).toInt(),
  durationSeconds: (json['durationSeconds'] as num).toInt(),
  thumbnailUrl: json['thumbnailUrl'] as String,
  masterPlaylistUrl: json['masterPlaylistUrl'] as String?,
);

Map<String, dynamic> _$LessonModelToJson(_LessonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'title': instance.title,
      'description': instance.description,
      'order': instance.order,
      'durationSeconds': instance.durationSeconds,
      'thumbnailUrl': instance.thumbnailUrl,
      'masterPlaylistUrl': instance.masterPlaylistUrl,
    };
