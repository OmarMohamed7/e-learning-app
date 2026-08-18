import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_stream_flutter/features/categories/data/models/category_model.dart';
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

  const categoryJson = {'id': 'mobile', 'name': 'Mobile', 'icon': 'phone'};

  const lessonJson = {
    'id': 'lesson-1',
    'title': 'Intro',
    'description': 'Getting started',
    'order': 0,
    'duration_seconds': 300,
    'video_url': '/media/course-1/lesson-1/master.m3u8',
  };

  final courseJson = {
    'id': 'course-1',
    'title': 'Flutter Fundamentals',
    'description': 'Learn Flutter from scratch.',
    'instructor': instructorJson,
    'category': categoryJson,
    'thumbnail_url': 'https://example.com/course.png',
    'lessons': [lessonJson],
    'total_duration_seconds': 300,
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

  test('LessonModel round-trips through JSON', () {
    final model = LessonModel.fromJson(lessonJson);

    expect(model.toJson(), lessonJson);
  });

  test('LessonModel resolves videoUrl into an absolute masterPlaylistUrl', () {
    final model = LessonModel.fromJson(lessonJson);

    expect(
      model.masterPlaylistUrl,
      'http://0.0.0.0:8000/media/course-1/lesson-1/master.m3u8',
    );
  });

  test('LessonModel has no playlist when the video has not finished processing', () {
    final model = LessonModel.fromJson({...lessonJson, 'video_url': ''});

    expect(model.masterPlaylistUrl, isNull);
  });

  test('LessonModel maps to the domain entity, taking courseId from the parent course', () {
    final model = LessonModel.fromJson(lessonJson);
    final entity = model.toEntity(courseId: 'course-1');

    expect(entity, isA<Lesson>());
    expect(entity.courseId, 'course-1');
    expect(entity.masterPlaylistUrl, model.masterPlaylistUrl);
  });

  test('CourseModel round-trips through JSON, including nested models', () {
    final model = CourseModel.fromJson(courseJson);

    expect(model.toJson(), courseJson);
    expect(model.category, CategoryModel.fromJson(categoryJson));
    expect(model.lessons, hasLength(1));
  });

  test('CourseModel maps to the domain entity', () {
    final model = CourseModel.fromJson(courseJson);
    final entity = model.toEntity();

    expect(entity, isA<Course>());
    expect(entity.category, CategoryModel.fromJson(categoryJson));
    expect(entity.lessons.single, isA<Lesson>());
    expect(entity.lessons.single.courseId, entity.id);
  });
}
