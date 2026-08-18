import 'package:freezed_annotation/freezed_annotation.dart';

import 'course_model.dart';

part 'courses_response_model.freezed.dart';
part 'courses_response_model.g.dart';

@freezed
abstract class CoursesResponseModel with _$CoursesResponseModel {
  const factory CoursesResponseModel({
    @Default(<CourseModel>[]) List<CourseModel> items,
    @Default(0) int total,
  }) = _CoursesResponseModel;

  factory CoursesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CoursesResponseModelFromJson(json);
}
