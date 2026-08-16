// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoursesResponseModel _$CoursesResponseModelFromJson(
  Map<String, dynamic> json,
) => _CoursesResponseModel(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CourseModel>[],
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CoursesResponseModelToJson(
  _CoursesResponseModel instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'total': instance.total,
};
