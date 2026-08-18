// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  instructor: InstructorModel.fromJson(
    json['instructor'] as Map<String, dynamic>,
  ),
  category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
  thumbnailUrl: json['thumbnail_url'] as String,
  lessons:
      (json['lessons'] as List<dynamic>?)
          ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LessonModel>[],
  totalDurationSeconds: (json['total_duration_seconds'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'instructor': instance.instructor.toJson(),
      'category': instance.category.toJson(),
      'thumbnail_url': instance.thumbnailUrl,
      'lessons': instance.lessons.map((e) => e.toJson()).toList(),
      'total_duration_seconds': instance.totalDurationSeconds,
    };
