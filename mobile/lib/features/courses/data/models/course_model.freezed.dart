// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseModel {

 String get id; String get title; String get description; InstructorModel get instructor; String get category;@JsonKey(name: 'thumbnail_url') String get thumbnailUrl; List<LessonModel> get lessons; int get totalDurationSeconds;
/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseModelCopyWith<CourseModel> get copyWith => _$CourseModelCopyWithImpl<CourseModel>(this as CourseModel, _$identity);

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.instructor, instructor) || other.instructor == instructor)&&(identical(other.category, category) || other.category == category)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other.lessons, lessons)&&(identical(other.totalDurationSeconds, totalDurationSeconds) || other.totalDurationSeconds == totalDurationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,instructor,category,thumbnailUrl,const DeepCollectionEquality().hash(lessons),totalDurationSeconds);

@override
String toString() {
  return 'CourseModel(id: $id, title: $title, description: $description, instructor: $instructor, category: $category, thumbnailUrl: $thumbnailUrl, lessons: $lessons, totalDurationSeconds: $totalDurationSeconds)';
}


}

/// @nodoc
abstract mixin class $CourseModelCopyWith<$Res>  {
  factory $CourseModelCopyWith(CourseModel value, $Res Function(CourseModel) _then) = _$CourseModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, InstructorModel instructor, String category,@JsonKey(name: 'thumbnail_url') String thumbnailUrl, List<LessonModel> lessons, int totalDurationSeconds
});


$InstructorModelCopyWith<$Res> get instructor;

}
/// @nodoc
class _$CourseModelCopyWithImpl<$Res>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._self, this._then);

  final CourseModel _self;
  final $Res Function(CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? instructor = null,Object? category = null,Object? thumbnailUrl = null,Object? lessons = null,Object? totalDurationSeconds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,instructor: null == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as InstructorModel,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<LessonModel>,totalDurationSeconds: null == totalDurationSeconds ? _self.totalDurationSeconds : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstructorModelCopyWith<$Res> get instructor {
  
  return $InstructorModelCopyWith<$Res>(_self.instructor, (value) {
    return _then(_self.copyWith(instructor: value));
  });
}
}


/// Adds pattern-matching-related methods to [CourseModel].
extension CourseModelPatterns on CourseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  InstructorModel instructor,  String category, @JsonKey(name: 'thumbnail_url')  String thumbnailUrl,  List<LessonModel> lessons,  int totalDurationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.instructor,_that.category,_that.thumbnailUrl,_that.lessons,_that.totalDurationSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  InstructorModel instructor,  String category, @JsonKey(name: 'thumbnail_url')  String thumbnailUrl,  List<LessonModel> lessons,  int totalDurationSeconds)  $default,) {final _that = this;
switch (_that) {
case _CourseModel():
return $default(_that.id,_that.title,_that.description,_that.instructor,_that.category,_that.thumbnailUrl,_that.lessons,_that.totalDurationSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  InstructorModel instructor,  String category, @JsonKey(name: 'thumbnail_url')  String thumbnailUrl,  List<LessonModel> lessons,  int totalDurationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.instructor,_that.category,_that.thumbnailUrl,_that.lessons,_that.totalDurationSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseModel extends CourseModel {
  const _CourseModel({required this.id, required this.title, required this.description, required this.instructor, required this.category, @JsonKey(name: 'thumbnail_url') required this.thumbnailUrl, final  List<LessonModel> lessons = const <LessonModel>[], this.totalDurationSeconds = 0}): _lessons = lessons,super._();
  factory _CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  InstructorModel instructor;
@override final  String category;
@override@JsonKey(name: 'thumbnail_url') final  String thumbnailUrl;
 final  List<LessonModel> _lessons;
@override@JsonKey() List<LessonModel> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}

@override@JsonKey() final  int totalDurationSeconds;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseModelCopyWith<_CourseModel> get copyWith => __$CourseModelCopyWithImpl<_CourseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.instructor, instructor) || other.instructor == instructor)&&(identical(other.category, category) || other.category == category)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other._lessons, _lessons)&&(identical(other.totalDurationSeconds, totalDurationSeconds) || other.totalDurationSeconds == totalDurationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,instructor,category,thumbnailUrl,const DeepCollectionEquality().hash(_lessons),totalDurationSeconds);

@override
String toString() {
  return 'CourseModel(id: $id, title: $title, description: $description, instructor: $instructor, category: $category, thumbnailUrl: $thumbnailUrl, lessons: $lessons, totalDurationSeconds: $totalDurationSeconds)';
}


}

/// @nodoc
abstract mixin class _$CourseModelCopyWith<$Res> implements $CourseModelCopyWith<$Res> {
  factory _$CourseModelCopyWith(_CourseModel value, $Res Function(_CourseModel) _then) = __$CourseModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, InstructorModel instructor, String category,@JsonKey(name: 'thumbnail_url') String thumbnailUrl, List<LessonModel> lessons, int totalDurationSeconds
});


@override $InstructorModelCopyWith<$Res> get instructor;

}
/// @nodoc
class __$CourseModelCopyWithImpl<$Res>
    implements _$CourseModelCopyWith<$Res> {
  __$CourseModelCopyWithImpl(this._self, this._then);

  final _CourseModel _self;
  final $Res Function(_CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? instructor = null,Object? category = null,Object? thumbnailUrl = null,Object? lessons = null,Object? totalDurationSeconds = null,}) {
  return _then(_CourseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,instructor: null == instructor ? _self.instructor : instructor // ignore: cast_nullable_to_non_nullable
as InstructorModel,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<LessonModel>,totalDurationSeconds: null == totalDurationSeconds ? _self.totalDurationSeconds : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InstructorModelCopyWith<$Res> get instructor {
  
  return $InstructorModelCopyWith<$Res>(_self.instructor, (value) {
    return _then(_self.copyWith(instructor: value));
  });
}
}

// dart format on
