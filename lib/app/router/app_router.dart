import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/pages/account_page.dart';
import '../../features/courses/presentation/pages/category_courses_page.dart';
import '../../features/courses/presentation/pages/course_details_page.dart';
import '../../features/courses/presentation/pages/home_page.dart';
import '../../features/courses/presentation/pages/my_courses_page.dart';
import '../../features/video_player/presentation/pages/video_player_page.dart';
import '../shell/main_shell.dart';

final Provider<GoRouter> goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const HomePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/courses',
                builder: (context, state) => const MyCoursesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/category/:categoryId',
        builder: (context, state) => CategoryCoursesPage(
          categoryId: state.pathParameters['categoryId']!,
          categoryName: state.uri.queryParameters['categoryName']!,
        ),
      ),
      GoRoute(
        path: '/course/:courseId',
        builder: (context, state) =>
            CourseDetailsPage(courseId: state.pathParameters['courseId']!),
        routes: [
          GoRoute(
            path: 'lesson/:lessonId',
            builder: (context, state) => VideoPlayerPage(
              courseId: state.pathParameters['courseId']!,
              lessonId: state.pathParameters['lessonId']!,
              courseTitle: state.uri.queryParameters['courseTitle']!,
            ),
          ),
        ],
      ),
    ],
  );
});
