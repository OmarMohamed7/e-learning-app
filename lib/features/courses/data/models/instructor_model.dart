import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/instructor.dart';

part 'instructor_model.freezed.dart';
part 'instructor_model.g.dart';

@freezed
abstract class InstructorModel with _$InstructorModel {
  const factory InstructorModel({
    required String id,
    required String name,
    required String headline,
    required String bio,
    required String avatarUrl,
  }) = _InstructorModel;

  const InstructorModel._();

  factory InstructorModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorModelFromJson(json);

  factory InstructorModel.fromEntity(Instructor entity) => InstructorModel(
    id: entity.id,
    name: entity.name,
    headline: entity.headline,
    bio: entity.bio,
    avatarUrl: entity.avatarUrl,
  );

  Instructor toEntity() => Instructor(
    id: id,
    name: name,
    headline: headline,
    bio: bio,
    avatarUrl: avatarUrl,
  );
}
