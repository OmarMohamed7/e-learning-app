import 'package:equatable/equatable.dart';

import '../../../categories/data/models/category_model.dart';
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

  /// Embedded, not just an id — the API joins and denormalizes the
  /// instructor row to avoid a second request on the course-details screen.
  final Instructor instructor;
  final CategoryModel category;
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
