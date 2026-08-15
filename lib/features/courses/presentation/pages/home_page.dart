import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../categories/presentation/widgets/categories_explore_section.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/instructor.dart';
import '../../domain/entities/lesson.dart';
import '../models/continue_learning_progress.dart';
import '../widgets/continue_learning_section.dart';
import '../widgets/home_header.dart';
import '../widgets/most_popular_class_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // TODO(day-2): replace with data from the course repository / progress
  // use case (plan.md Day 2 — "Course repository", "Local JSON data
  // source"). Kept here as typed sample data so the sections below can be
  // built and demoed against the real domain/presentation models now.
  // ignore: unnecessary_nullable_for_final_variable_declarations
  static final ContinueLearningProgress? _continueLearningProgress =
      ContinueLearningProgress(
        course: _sampleCourses.first,
        completedLessons: 23,
      );

  static final List<Course> _sampleCourses = [
    Course(
      id: 'course-1',
      title: 'Online Class: Complete Website Designer with Figma',
      description: 'Learn to design and ship a full website in Figma.',
      instructor: const Instructor(
        id: 'instructor-1',
        name: 'Ava Chen',
        headline: 'Product Designer',
        bio: '',
        avatarUrl: '',
      ),
      category: 'design',
      thumbnailUrl: 'https://picsum.photos/seed/mentorstream-1/400/300',
      lessons: List.generate(
        50,
        (index) => Lesson(
          id: 'course-1-lesson-$index',
          courseId: 'course-1',
          title: 'Lesson $index',
          description: '',
          order: index,
          durationSeconds: 600,
          thumbnailUrl: '',
        ),
      ),
      totalDurationSeconds: 30000,
    ),
    Course(
      id: 'course-2',
      title: 'Build a Furniture UI Design',
      description: 'Design a furniture e-commerce experience end to end.',
      instructor: const Instructor(
        id: 'instructor-2',
        name: 'Marco Diaz',
        headline: 'UI Designer',
        bio: '',
        avatarUrl: '',
      ),
      category: 'design',
      thumbnailUrl: 'https://picsum.photos/seed/mentorstream-2/400/300',
      lessons: const [],
      totalDurationSeconds: 12000,
    ),
    Course(
      id: 'course-3',
      title: 'Marketing Fundamentals for Startups',
      description: 'The essentials of go-to-market strategy.',
      instructor: const Instructor(
        id: 'instructor-3',
        name: 'Priya Nair',
        headline: 'Growth Marketer',
        bio: '',
        avatarUrl: '',
      ),
      category: 'marketing',
      thumbnailUrl: 'https://picsum.photos/seed/mentorstream-3/400/300',
      lessons: const [],
      totalDurationSeconds: 9000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeader(userName: 'Aaron'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 28,
                children: [
                  ContinueLearningSection(
                    progress: _continueLearningProgress,
                    onTap: () =>
                        _openCourse(context, _continueLearningProgress!.course),
                  ),
                  const CategoriesExploreSection(),
                  MostPopularClassSection(
                    courses: _sampleCourses,
                    onCourseTap: (course) => _openCourse(context, course),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCourse(BuildContext context, Course course) {
    context.push('/course/${course.id}');
  }
}
