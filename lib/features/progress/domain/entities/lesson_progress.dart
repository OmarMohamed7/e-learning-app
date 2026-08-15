import 'package:equatable/equatable.dart';

/// Playback progress for a single lesson. Referenced by id rather than
/// embedding a [Lesson]/[Course] entity, keeping the progress feature
/// decoupled from the courses feature.
class LessonProgress extends Equatable {
  const LessonProgress({
    required this.lessonId,
    required this.courseId,
    required this.positionSeconds,
    required this.durationSeconds,
    required this.completed,
    required this.updatedAt,
  });

  final String lessonId;
  final String courseId;
  final int positionSeconds;
  final int durationSeconds;
  final bool completed;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    lessonId,
    courseId,
    positionSeconds,
    durationSeconds,
    completed,
    updatedAt,
  ];
}
