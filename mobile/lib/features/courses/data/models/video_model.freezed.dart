// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoModel {

 String get id; String get title; String get description;@JsonKey(name: 'course_id') String get courseId; String get status;@JsonKey(name: 'hls_url') String? get hlsUrl;@JsonKey(name: 'duration_seconds') int get durationSeconds;
/// Create a copy of VideoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoModelCopyWith<VideoModel> get copyWith => _$VideoModelCopyWithImpl<VideoModel>(this as VideoModel, _$identity);

  /// Serializes this VideoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.status, status) || other.status == status)&&(identical(other.hlsUrl, hlsUrl) || other.hlsUrl == hlsUrl)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,courseId,status,hlsUrl,durationSeconds);

@override
String toString() {
  return 'VideoModel(id: $id, title: $title, description: $description, courseId: $courseId, status: $status, hlsUrl: $hlsUrl, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class $VideoModelCopyWith<$Res>  {
  factory $VideoModelCopyWith(VideoModel value, $Res Function(VideoModel) _then) = _$VideoModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description,@JsonKey(name: 'course_id') String courseId, String status,@JsonKey(name: 'hls_url') String? hlsUrl,@JsonKey(name: 'duration_seconds') int durationSeconds
});




}
/// @nodoc
class _$VideoModelCopyWithImpl<$Res>
    implements $VideoModelCopyWith<$Res> {
  _$VideoModelCopyWithImpl(this._self, this._then);

  final VideoModel _self;
  final $Res Function(VideoModel) _then;

/// Create a copy of VideoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? courseId = null,Object? status = null,Object? hlsUrl = freezed,Object? durationSeconds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,hlsUrl: freezed == hlsUrl ? _self.hlsUrl : hlsUrl // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoModel].
extension VideoModelPatterns on VideoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoModel value)  $default,){
final _that = this;
switch (_that) {
case _VideoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoModel value)?  $default,){
final _that = this;
switch (_that) {
case _VideoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description, @JsonKey(name: 'course_id')  String courseId,  String status, @JsonKey(name: 'hls_url')  String? hlsUrl, @JsonKey(name: 'duration_seconds')  int durationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.courseId,_that.status,_that.hlsUrl,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description, @JsonKey(name: 'course_id')  String courseId,  String status, @JsonKey(name: 'hls_url')  String? hlsUrl, @JsonKey(name: 'duration_seconds')  int durationSeconds)  $default,) {final _that = this;
switch (_that) {
case _VideoModel():
return $default(_that.id,_that.title,_that.description,_that.courseId,_that.status,_that.hlsUrl,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description, @JsonKey(name: 'course_id')  String courseId,  String status, @JsonKey(name: 'hls_url')  String? hlsUrl, @JsonKey(name: 'duration_seconds')  int durationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _VideoModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.courseId,_that.status,_that.hlsUrl,_that.durationSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoModel extends VideoModel {
  const _VideoModel({required this.id, required this.title, this.description = '', @JsonKey(name: 'course_id') required this.courseId, required this.status, @JsonKey(name: 'hls_url') this.hlsUrl, @JsonKey(name: 'duration_seconds') this.durationSeconds = 0}): super._();
  factory _VideoModel.fromJson(Map<String, dynamic> json) => _$VideoModelFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'course_id') final  String courseId;
@override final  String status;
@override@JsonKey(name: 'hls_url') final  String? hlsUrl;
@override@JsonKey(name: 'duration_seconds') final  int durationSeconds;

/// Create a copy of VideoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoModelCopyWith<_VideoModel> get copyWith => __$VideoModelCopyWithImpl<_VideoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.status, status) || other.status == status)&&(identical(other.hlsUrl, hlsUrl) || other.hlsUrl == hlsUrl)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,courseId,status,hlsUrl,durationSeconds);

@override
String toString() {
  return 'VideoModel(id: $id, title: $title, description: $description, courseId: $courseId, status: $status, hlsUrl: $hlsUrl, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class _$VideoModelCopyWith<$Res> implements $VideoModelCopyWith<$Res> {
  factory _$VideoModelCopyWith(_VideoModel value, $Res Function(_VideoModel) _then) = __$VideoModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description,@JsonKey(name: 'course_id') String courseId, String status,@JsonKey(name: 'hls_url') String? hlsUrl,@JsonKey(name: 'duration_seconds') int durationSeconds
});




}
/// @nodoc
class __$VideoModelCopyWithImpl<$Res>
    implements _$VideoModelCopyWith<$Res> {
  __$VideoModelCopyWithImpl(this._self, this._then);

  final _VideoModel _self;
  final $Res Function(_VideoModel) _then;

/// Create a copy of VideoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? courseId = null,Object? status = null,Object? hlsUrl = freezed,Object? durationSeconds = null,}) {
  return _then(_VideoModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,hlsUrl: freezed == hlsUrl ? _self.hlsUrl : hlsUrl // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
