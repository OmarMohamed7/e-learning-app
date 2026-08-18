import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_stream_flutter/features/progress/data/models/lesson_progress_model.dart';
import 'package:mentor_stream_flutter/features/progress/domain/entities/lesson_progress.dart';

void main() {
  final updatedAt = DateTime.utc(2026, 8, 13, 22, 30);

  final json = {
    'lessonId': 'lesson-1',
    'courseId': 'course-1',
    'positionSeconds': 120,
    'durationSeconds': 300,
    'completed': false,
    'updatedAt': updatedAt.toIso8601String(),
  };

  test('LessonProgressModel round-trips through JSON', () {
    final model = LessonProgressModel.fromJson(json);

    expect(model.toJson(), json);
    expect(model.updatedAt, updatedAt);
  });

  test('LessonProgressModel maps to and from the domain entity', () {
    final model = LessonProgressModel.fromJson(json);
    final entity = model.toEntity();

    expect(entity, isA<LessonProgress>());
    expect(entity.updatedAt, updatedAt);
    expect(LessonProgressModel.fromEntity(entity), model);
  });
}
