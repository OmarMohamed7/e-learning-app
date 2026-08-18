// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideosResponseModel _$VideosResponseModelFromJson(Map<String, dynamic> json) =>
    _VideosResponseModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VideoModel>[],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VideosResponseModelToJson(
  _VideosResponseModel instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
};
