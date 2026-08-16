// ignore: file_names
import '../../data/models/course_model.dart';

abstract interface class ICourseRepository {
  Future<List<CourseModel>> getCourses({String? category});
}
