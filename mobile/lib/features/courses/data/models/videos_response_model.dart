import 'package:freezed_annotation/freezed_annotation.dart';

import 'video_model.dart';

part 'videos_response_model.freezed.dart';
part 'videos_response_model.g.dart';

@freezed
abstract class VideosResponseModel with _$VideosResponseModel {
  const factory VideosResponseModel({
    @Default(<VideoModel>[]) List<VideoModel> items,
    @Default(0) int total,
  }) = _VideosResponseModel;

  factory VideosResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VideosResponseModelFromJson(json);
}
