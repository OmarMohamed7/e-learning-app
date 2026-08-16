import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/course_model.dart';
import '../models/courses_response_model.dart';

part 'course_api.g.dart';

@RestApi()
abstract class CourseApi {
  factory CourseApi(Dio dio, {String? baseUrl}) = _CourseApi;

  @GET('/courses')
  Future<CoursesResponseModel> getCourses({
    @Query('category') String? category,
  });

  @GET('/courses/{id}')
  Future<CourseModel> getCourse(@Path('id') String id);
}
