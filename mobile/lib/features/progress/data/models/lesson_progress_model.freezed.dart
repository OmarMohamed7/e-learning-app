// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_progress_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonProgressModel {

 String get lessonId; String get courseId; int get positionSeconds; int get durationSeconds; bool get completed; DateTime get updatedAt;
/// Create a copy of LessonProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonProgressModelCopyWith<LessonProgressModel> get copyWith => _$LessonProgressModelCopyWithImpl<LessonProgressModel>(this as LessonProgressModel, _$identity);

  /// Serializes this LessonProgressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonProgressModel&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.positionSeconds, positionSeconds) || other.positionSeconds == positionSeconds)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,courseId,positionSeconds,durationSeconds,completed,updatedAt);

@override
String toString() {
  return 'LessonProgressModel(lessonId: $lessonId, courseId: $courseId, positionSeconds: $positionSeconds, durationSeconds: $durationSeconds, completed: $completed, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LessonProgressModelCopyWith<$Res>  {
  factory $LessonProgressModelCopyWith(LessonProgressModel value, $Res Function(LessonProgressModel) _then) = _$LessonProgressModelCopyWithImpl;
@useResult
$Res call({
 String lessonId, String courseId, int positionSeconds, int durationSeconds, bool completed, DateTime updatedAt
});




}
/// @nodoc
class _$LessonProgressModelCopyWithImpl<$Res>
    implements $LessonProgressModelCopyWith<$Res> {
  _$LessonProgressModelCopyWithImpl(this._self, this._then);

  final LessonProgressModel _self;
  final $Res Function(LessonProgressModel) _then;

/// Create a copy of LessonProgressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? courseId = null,Object? positionSeconds = null,Object? durationSeconds = null,Object? completed = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,positionSeconds: null == positionSeconds ? _self.positionSeconds : positionSeconds // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonProgressModel].
extension LessonProgressModelPatterns on LessonProgressModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonProgressModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _LessonProgressModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _LessonProgressModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lessonId,  String courseId,  int positionSeconds,  int durationSeconds,  bool completed,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonProgressModel() when $default != null:
return $default(_that.lessonId,_that.courseId,_that.positionSeconds,_that.durationSeconds,_that.completed,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lessonId,  String courseId,  int positionSeconds,  int durationSeconds,  bool completed,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LessonProgressModel():
return $default(_that.lessonId,_that.courseId,_that.positionSeconds,_that.durationSeconds,_that.completed,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lessonId,  String courseId,  int positionSeconds,  int durationSeconds,  bool completed,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LessonProgressModel() when $default != null:
return $default(_that.lessonId,_that.courseId,_that.positionSeconds,_that.durationSeconds,_that.completed,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonProgressModel extends LessonProgressModel {
  const _LessonProgressModel({required this.lessonId, required this.courseId, required this.positionSeconds, required this.durationSeconds, required this.completed, required this.updatedAt}): super._();
  factory _LessonProgressModel.fromJson(Map<String, dynamic> json) => _$LessonProgressModelFromJson(json);

@override final  String lessonId;
@override final  String courseId;
@override final  int positionSeconds;
@override final  int durationSeconds;
@override final  bool completed;
@override final  DateTime updatedAt;

/// Create a copy of LessonProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonProgressModelCopyWith<_LessonProgressModel> get copyWith => __$LessonProgressModelCopyWithImpl<_LessonProgressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonProgressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonProgressModel&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.positionSeconds, positionSeconds) || other.positionSeconds == positionSeconds)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,courseId,positionSeconds,durationSeconds,completed,updatedAt);

@override
String toString() {
  return 'LessonProgressModel(lessonId: $lessonId, courseId: $courseId, positionSeconds: $positionSeconds, durationSeconds: $durationSeconds, completed: $completed, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LessonProgressModelCopyWith<$Res> implements $LessonProgressModelCopyWith<$Res> {
  factory _$LessonProgressModelCopyWith(_LessonProgressModel value, $Res Function(_LessonProgressModel) _then) = __$LessonProgressModelCopyWithImpl;
@override @useResult
$Res call({
 String lessonId, String courseId, int positionSeconds, int durationSeconds, bool completed, DateTime updatedAt
});




}
/// @nodoc
class __$LessonProgressModelCopyWithImpl<$Res>
    implements _$LessonProgressModelCopyWith<$Res> {
  __$LessonProgressModelCopyWithImpl(this._self, this._then);

  final _LessonProgressModel _self;
  final $Res Function(_LessonProgressModel) _then;

/// Create a copy of LessonProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? courseId = null,Object? positionSeconds = null,Object? durationSeconds = null,Object? completed = null,Object? updatedAt = null,}) {
  return _then(_LessonProgressModel(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,positionSeconds: null == positionSeconds ? _self.positionSeconds : positionSeconds // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
