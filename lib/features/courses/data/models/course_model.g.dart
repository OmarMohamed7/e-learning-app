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
  category: json['category'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  lessons: (json['lessons'] as List<dynamic>)
      .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalDurationSeconds: (json['totalDurationSeconds'] as num).toInt(),
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'instructor': instance.instructor.toJson(),
      'category': instance.category,
      'thumbnailUrl': instance.thumbnailUrl,
      'lessons': instance.lessons.map((e) => e.toJson()).toList(),
      'totalDurationSeconds': instance.totalDurationSeconds,
    };
