import 'package:equatable/equatable.dart';

import 'instructor.dart';
import 'lesson.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.category,
    required this.thumbnailUrl,
    required this.lessons,
    required this.totalDurationSeconds,
  });

  final String id;
  final String title;
  final String description;

  /// Embedded, not just an id — mirrors how a Firestore course document will
  /// realistically denormalize an instructor snapshot to avoid a second read
  /// on the course-details screen.
  final Instructor instructor;
  final String category;
  final String thumbnailUrl;
  final List<Lesson> lessons;
  final int totalDurationSeconds;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    instructor,
    category,
    thumbnailUrl,
    lessons,
    totalDurationSeconds,
  ];
}
