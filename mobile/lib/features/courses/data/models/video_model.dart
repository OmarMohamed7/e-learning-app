import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/network_providers.dart';
import '../../domain/entities/lesson.dart';

part 'video_model.freezed.dart';
part 'video_model.g.dart';

@freezed
abstract class VideoModel with _$VideoModel {
  const factory VideoModel({
    required String id,
    required String title,
    @Default('') String description,
    @JsonKey(name: 'course_id') required String courseId,
    required String status,
    @JsonKey(name: 'hls_url') String? hlsUrl,
    @JsonKey(name: 'duration_seconds') @Default(0) int durationSeconds,
  }) = _VideoModel;

  const VideoModel._();

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);

  /// Whether the video has finished processing and has a playable stream.
  bool get isReady => status == 'ready' && hlsUrl != null;

  /// Absolute URL of the HLS master playlist, resolved against
  /// [mediaBaseUrl] since the API returns [hlsUrl] as a server-relative path.
  String? get masterPlaylistUrl => hlsUrl == null ? null : '$mediaBaseUrl$hlsUrl';

  Lesson toEntity({required int order}) => Lesson(
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
