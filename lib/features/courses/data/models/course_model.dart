import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/course.dart';
import 'instructor_model.dart';
import 'lesson_model.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required String id,
    required String title,
    required String description,
    required InstructorModel instructor,
    required String category,
    required String thumbnailUrl,
    required List<LessonModel> lessons,
    required int totalDurationSeconds,
  }) = _CourseModel;

  const CourseModel._();

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  factory CourseModel.fromEntity(Course entity) => CourseModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    instructor: InstructorModel.fromEntity(entity.instructor),
    category: entity.category,
    thumbnailUrl: entity.thumbnailUrl,
    lessons: entity.lessons.map(LessonModel.fromEntity).toList(),
    totalDurationSeconds: entity.totalDurationSeconds,
  );

  Course toEntity() => Course(
    id: id,
    title: title,
    description: description,
    instructor: instructor.toEntity(),
    category: category,
    thumbnailUrl: thumbnailUrl,
    lessons: lessons.map((lesson) => lesson.toEntity()).toList(),
    totalDurationSeconds: totalDurationSeconds,
  );
}
