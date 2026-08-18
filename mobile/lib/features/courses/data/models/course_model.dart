import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../categories/data/models/category_model.dart';
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
    required CategoryModel category,
    @JsonKey(name: 'thumbnail_url') required String thumbnailUrl,
    @Default(<LessonModel>[]) List<LessonModel> lessons,
    @JsonKey(name: 'total_duration_seconds') @Default(0) int totalDurationSeconds,
  }) = _CourseModel;

  const CourseModel._();

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Course toEntity() => Course(
    id: id,
    title: title,
    description: description,
    instructor: instructor.toEntity(),
    category: category,
    thumbnailUrl: thumbnailUrl,
    lessons: lessons.map((lesson) => lesson.toEntity(courseId: id)).toList(),
    totalDurationSeconds: totalDurationSeconds,
  );
}
