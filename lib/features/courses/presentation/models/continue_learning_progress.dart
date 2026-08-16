import '../../domain/entities/course.dart';

/// Presentation-layer aggregate pairing a [Course] with how far the learner
/// has progressed through it, for the "Continue Learning" card. Kept
/// separate from [Course]/`LessonProgress` since neither entity alone
/// carries a ready-made "N of M lessons completed" summary.
class ContinueLearningProgress {
  const ContinueLearningProgress({
    required this.course,
    required this.completedLessons,
    required this.totalLessons,
  });

  final Course course;
  final int completedLessons;
  final int totalLessons;

  double get completionRatio =>
      totalLessons == 0 ? 0 : completedLessons / totalLessons;
}
