import 'package:mentor_stream_flutter/features/courses/data/datasources/course_api.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/course_model.dart';
import 'package:mentor_stream_flutter/features/courses/domain/repositories/i_courses_repo.dart';

/// [ICourseRepository] backed by the local REST API (via [CourseApi]).
class RemoteCourseRepository implements ICourseRepository {
  const RemoteCourseRepository({required CourseApi remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final CourseApi _remoteDataSource;

  @override
  Future<List<CourseModel>> getCourses({String? category}) async {
    final response = await _remoteDataSource.getCourses(category: category);
    return response.items;
  }
}
