// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instructor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstructorModel {

 String get id; String get name; String get headline; String get bio; String get avatarUrl;
/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstructorModelCopyWith<InstructorModel> get copyWith => _$InstructorModelCopyWithImpl<InstructorModel>(this as InstructorModel, _$identity);

  /// Serializes this InstructorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstructorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,headline,bio,avatarUrl);

@override
String toString() {
  return 'InstructorModel(id: $id, name: $name, headline: $headline, bio: $bio, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $InstructorModelCopyWith<$Res>  {
  factory $InstructorModelCopyWith(InstructorModel value, $Res Function(InstructorModel) _then) = _$InstructorModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String headline, String bio, String avatarUrl
});




}
/// @nodoc
class _$InstructorModelCopyWithImpl<$Res>
    implements $InstructorModelCopyWith<$Res> {
  _$InstructorModelCopyWithImpl(this._self, this._then);

  final InstructorModel _self;
  final $Res Function(InstructorModel) _then;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? headline = null,Object? bio = null,Object? avatarUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InstructorModel].
extension InstructorModelPatterns on InstructorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstructorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstructorModel value)  $default,){
final _that = this;
switch (_that) {
case _InstructorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstructorModel value)?  $default,){
final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String headline,  String bio,  String avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
return $default(_that.id,_that.name,_that.headline,_that.bio,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String headline,  String bio,  String avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _InstructorModel():
return $default(_that.id,_that.name,_that.headline,_that.bio,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String headline,  String bio,  String avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _InstructorModel() when $default != null:
return $default(_that.id,_that.name,_that.headline,_that.bio,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstructorModel extends InstructorModel {
  const _InstructorModel({required this.id, required this.name, required this.headline, required this.bio, required this.avatarUrl}): super._();
  factory _InstructorModel.fromJson(Map<String, dynamic> json) => _$InstructorModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String headline;
@override final  String bio;
@override final  String avatarUrl;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstructorModelCopyWith<_InstructorModel> get copyWith => __$InstructorModelCopyWithImpl<_InstructorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstructorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstructorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,headline,bio,avatarUrl);

@override
String toString() {
  return 'InstructorModel(id: $id, name: $name, headline: $headline, bio: $bio, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$InstructorModelCopyWith<$Res> implements $InstructorModelCopyWith<$Res> {
  factory _$InstructorModelCopyWith(_InstructorModel value, $Res Function(_InstructorModel) _then) = __$InstructorModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String headline, String bio, String avatarUrl
});




}
/// @nodoc
class __$InstructorModelCopyWithImpl<$Res>
    implements _$InstructorModelCopyWith<$Res> {
  __$InstructorModelCopyWithImpl(this._self, this._then);

  final _InstructorModel _self;
  final $Res Function(_InstructorModel) _then;

/// Create a copy of InstructorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? headline = null,Object? bio = null,Object? avatarUrl = null,}) {
  return _then(_InstructorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
