import 'package:equatable/equatable.dart';

class Lesson extends Equatable {
  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.order,
    required this.durationSeconds,
    required this.thumbnailUrl,
    this.masterPlaylistUrl,
  });

  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final int durationSeconds;
  final String thumbnailUrl;

  /// URL of the HLS master playlist (`master.m3u8`) for this lesson.
  /// Null until a real video asset has been produced/hosted (plan.md §10).
  final String? masterPlaylistUrl;

  @override
  List<Object?> get props => [
    id,
    courseId,
    title,
    description,
    order,
    durationSeconds,
    thumbnailUrl,
    masterPlaylistUrl,
  ];
}
