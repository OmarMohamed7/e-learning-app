// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstructorModel _$InstructorModelFromJson(Map<String, dynamic> json) =>
    _InstructorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      headline: json['headline'] as String,
      bio: json['bio'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$InstructorModelToJson(_InstructorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'headline': instance.headline,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
    };
