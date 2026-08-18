import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/network_providers.dart';
import '../../domain/entities/lesson.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
abstract class LessonModel with _$LessonModel {
  const factory LessonModel({
    required String id,
    required String title,
    required String description,
    required int order,
    @JsonKey(name: 'duration_seconds') required int durationSeconds,
    @JsonKey(name: 'video_url') required String videoUrl,
  }) = _LessonModel;

  const LessonModel._();

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);

  /// Absolute URL of the HLS master playlist, resolved against
  /// [mediaBaseUrl] since the API returns [videoUrl] as a server-relative
  /// path. Empty until the underlying video has finished processing.
  String? get masterPlaylistUrl =>
      videoUrl.isEmpty ? null : '$mediaBaseUrl$videoUrl';

  Lesson toEntity({required String courseId}) => Lesson(
    id: id,
    courseId: courseId,
    title: title,
    description: description,
    order: order,
    durationSeconds: durationSeconds,
    thumbnailUrl: '',
    masterPlaylistUrl: masterPlaylistUrl,
  );
}
