import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentor_stream_flutter/core/network/network_providers.dart';
import 'package:mentor_stream_flutter/features/courses/data/datasources/course_api.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/course_model.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/video_model.dart';
import 'package:mentor_stream_flutter/features/courses/data/repositories/remote_course_repository.dart';
import 'package:mentor_stream_flutter/features/courses/domain/repositories/i_courses_repo.dart';

final Provider<CourseApi> courseApiProvider = Provider<CourseApi>((ref) {
  final dio = ref.watch(dioProvider);
  return CourseApi(dio);
});

final Provider<RemoteCourseRepository> remoteCourseRepositoryProvider =
    Provider<RemoteCourseRepository>((ref) {
      return RemoteCourseRepository(
        remoteDataSource: ref.watch(courseApiProvider),
      );
    });

final Provider<ICourseRepository> courseRepositoryProvider =
    Provider<ICourseRepository>((ref) {
      return ref.watch(remoteCourseRepositoryProvider);
    });

final FutureProvider<List<CourseModel>> coursesProvider =
    FutureProvider<List<CourseModel>>((ref) {
      return ref.watch(courseRepositoryProvider).getCourses();
    });

final coursesByCategoryProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, category) {
      return ref.watch(courseRepositoryProvider).getCourses(category: category);
    });

final courseVideosProvider = FutureProvider.autoDispose
    .family<List<VideoModel>, String>((ref, courseId) {
      return ref.watch(courseRepositoryProvider).getCourseVideos(courseId);
    });

final courseSearchProvider = FutureProvider.autoDispose
    .family<List<CourseModel>, String>((ref, query) {
      return ref.watch(courseRepositoryProvider).getCourses(search: query);
    });
