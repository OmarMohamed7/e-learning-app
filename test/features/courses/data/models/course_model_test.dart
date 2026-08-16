import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/course_model.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/instructor_model.dart';
import 'package:mentor_stream_flutter/features/courses/data/models/lesson_model.dart';
import 'package:mentor_stream_flutter/features/courses/domain/entities/course.dart';
import 'package:mentor_stream_flutter/features/courses/domain/entities/instructor.dart';
import 'package:mentor_stream_flutter/features/courses/domain/entities/lesson.dart';

void main() {
  const instructorJson = {
    'id': 'instructor-1',
    'name': 'Ada Lovelace',
    'headline': 'Software Pioneer',
    'bio': 'Wrote the first algorithm.',
    'avatarUrl': 'https://example.com/ada.png',
  };

  const lessonJson = {
    'id': 'lesson-1',
    'courseId': 'course-1',
    'title': 'Intro',
    'description': 'Getting started',
    'order': 0,
    'durationSeconds': 300,
    'thumbnailUrl': 'https://example.com/lesson.png',
    'masterPlaylistUrl': null,
  };

  final courseJson = {
    'id': 'course-1',
    'title': 'Flutter Fundamentals',
    'description': 'Learn Flutter from scratch.',
    'instructor': instructorJson,
    'category': 'mobile',
    'thumbnail_url': 'https://example.com/course.png',
    'lessons': [lessonJson],
    'totalDurationSeconds': 300,
  };

  test('InstructorModel round-trips through JSON', () {
    final model = InstructorModel.fromJson(instructorJson);

    expect(model.toJson(), instructorJson);
  });

  test('InstructorModel maps to and from the domain entity', () {
    final model = InstructorModel.fromJson(instructorJson);
    final entity = model.toEntity();

    expect(entity, isA<Instructor>());
    expect(entity.id, 'instructor-1');
    expect(InstructorModel.fromEntity(entity), model);
  });

  test('LessonModel round-trips through JSON with a null optional field', () {
    final model = LessonModel.fromJson(lessonJson);

    expect(model.toJson(), lessonJson);
    expect(model.masterPlaylistUrl, isNull);
  });

  test('LessonModel maps to and from the domain entity', () {
    final model = LessonModel.fromJson(lessonJson);
    final entity = model.toEntity();

    expect(entity, isA<Lesson>());
    expect(LessonModel.fromEntity(entity), model);
  });

  test('CourseModel round-trips through JSON, including nested models', () {
    final model = CourseModel.fromJson(courseJson);

    expect(model.toJson(), courseJson);
    expect(model.lessons, hasLength(1));
  });

  test('CourseModel maps to and from the domain entity', () {
    final model = CourseModel.fromJson(courseJson);
    final entity = model.toEntity();

    expect(entity, isA<Course>());
    expect(entity.lessons.single, isA<Lesson>());
    expect(CourseModel.fromEntity(entity), model);
  });
}
