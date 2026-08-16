// ignore: file_names
import '../../data/models/course_model.dart';
import '../../data/models/video_model.dart';

abstract interface class ICourseRepository {
  Future<List<CourseModel>> getCourses({String? category});

  Future<List<VideoModel>> getCourseVideos(String courseId);
}
