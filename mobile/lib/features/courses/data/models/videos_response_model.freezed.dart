// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'videos_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideosResponseModel {

 List<VideoModel> get items; int get total;
/// Create a copy of VideosResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideosResponseModelCopyWith<VideosResponseModel> get copyWith => _$VideosResponseModelCopyWithImpl<VideosResponseModel>(this as VideosResponseModel, _$identity);

  /// Serializes this VideosResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideosResponseModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total);

@override
String toString() {
  return 'VideosResponseModel(items: $items, total: $total)';
}


}

/// @nodoc
abstract mixin class $VideosResponseModelCopyWith<$Res>  {
  factory $VideosResponseModelCopyWith(VideosResponseModel value, $Res Function(VideosResponseModel) _then) = _$VideosResponseModelCopyWithImpl;
@useResult
$Res call({
 List<VideoModel> items, int total
});




}
/// @nodoc
class _$VideosResponseModelCopyWithImpl<$Res>
    implements $VideosResponseModelCopyWith<$Res> {
  _$VideosResponseModelCopyWithImpl(this._self, this._then);

  final VideosResponseModel _self;
  final $Res Function(VideosResponseModel) _then;

/// Create a copy of VideosResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<VideoModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VideosResponseModel].
extension VideosResponseModelPatterns on VideosResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideosResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideosResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideosResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _VideosResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideosResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _VideosResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VideoModel> items,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideosResponseModel() when $default != null:
return $default(_that.items,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VideoModel> items,  int total)  $default,) {final _that = this;
switch (_that) {
case _VideosResponseModel():
return $default(_that.items,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VideoModel> items,  int total)?  $default,) {final _that = this;
switch (_that) {
case _VideosResponseModel() when $default != null:
return $default(_that.items,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideosResponseModel implements VideosResponseModel {
  const _VideosResponseModel({final  List<VideoModel> items = const <VideoModel>[], this.total = 0}): _items = items;
  factory _VideosResponseModel.fromJson(Map<String, dynamic> json) => _$VideosResponseModelFromJson(json);

 final  List<VideoModel> _items;
@override@JsonKey() List<VideoModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;

/// Create a copy of VideosResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideosResponseModelCopyWith<_VideosResponseModel> get copyWith => __$VideosResponseModelCopyWithImpl<_VideosResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideosResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideosResponseModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total);

@override
String toString() {
  return 'VideosResponseModel(items: $items, total: $total)';
}


}

/// @nodoc
abstract mixin class _$VideosResponseModelCopyWith<$Res> implements $VideosResponseModelCopyWith<$Res> {
  factory _$VideosResponseModelCopyWith(_VideosResponseModel value, $Res Function(_VideosResponseModel) _then) = __$VideosResponseModelCopyWithImpl;
@override @useResult
$Res call({
 List<VideoModel> items, int total
});




}
/// @nodoc
class __$VideosResponseModelCopyWithImpl<$Res>
    implements _$VideosResponseModelCopyWith<$Res> {
  __$VideosResponseModelCopyWithImpl(this._self, this._then);

  final _VideosResponseModel _self;
  final $Res Function(_VideosResponseModel) _then;

/// Create a copy of VideosResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,}) {
  return _then(_VideosResponseModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<VideoModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
