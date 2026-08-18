import 'package:mentor_stream_flutter/features/courses/data/datasources/course_api.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/course_model.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/video_model.dart';
import 'package:mentor_stream_flutter/features/courses/domain/repositories/i_courses_repo.dart';

/// [ICourseRepository] backed by the local REST API (via [CourseApi]).
class RemoteCourseRepository implements ICourseRepository {
  const RemoteCourseRepository({required CourseApi remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final CourseApi _remoteDataSource;

  @override
  Future<List<CourseModel>> getCourses({String? category, String? search}) async {
    final response = await _remoteDataSource.getCourses(
      category: category,
      search: search,
    );
    return response.items;
  }

  @override
  Future<List<VideoModel>> getCourseVideos(String courseId) async {
    final response = await _remoteDataSource.getCourseVideos(courseId);
    return response.items;
  }
}
