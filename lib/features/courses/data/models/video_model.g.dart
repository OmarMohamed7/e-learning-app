// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => _VideoModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  courseId: json['course_id'] as String,
  status: json['status'] as String,
  hlsUrl: json['hls_url'] as String?,
  durationSeconds: (json['duration_seconds'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$VideoModelToJson(_VideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'course_id': instance.courseId,
      'status': instance.status,
      'hls_url': instance.hlsUrl,
      'duration_seconds': instance.durationSeconds,
    };
