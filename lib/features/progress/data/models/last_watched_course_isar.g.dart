// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_watched_course_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLastWatchedCourseIsarCollection on Isar {
  IsarCollection<LastWatchedCourseIsar> get lastWatchedCourseIsars =>
      this.collection();
}

const LastWatchedCourseIsarSchema = CollectionSchema(
  name: r'LastWatchedCourseIsar',
  id: -7921357261549141551,
  properties: {
    r'courseId': PropertySchema(
      id: 0,
      name: r'courseId',
      type: IsarType.string,
    ),
    r'courseTitle': PropertySchema(
      id: 1,
      name: r'courseTitle',
      type: IsarType.string,
    ),
  },

  estimateSize: _lastWatchedCourseIsarEstimateSize,
  serialize: _lastWatchedCourseIsarSerialize,
  deserialize: _lastWatchedCourseIsarDeserialize,
  deserializeProp: _lastWatchedCourseIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _lastWatchedCourseIsarGetId,
  getLinks: _lastWatchedCourseIsarGetLinks,
  attach: _lastWatchedCourseIsarAttach,
  version: '3.3.2',
);

int _lastWatchedCourseIsarEstimateSize(
  LastWatchedCourseIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.courseId.length * 3;
  bytesCount += 3 + object.courseTitle.length * 3;
  return bytesCount;
}

void _lastWatchedCourseIsarSerialize(
  LastWatchedCourseIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.courseId);
  writer.writeString(offsets[1], object.courseTitle);
}

LastWatchedCourseIsar _lastWatchedCourseIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LastWatchedCourseIsar();
  object.courseId = reader.readString(offsets[0]);
  object.courseTitle = reader.readString(offsets[1]);
  object.id = id;
  return object;
}

P _lastWatchedCourseIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _lastWatchedCourseIsarGetId(LastWatchedCourseIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lastWatchedCourseIsarGetLinks(
  LastWatchedCourseIsar object,
) {
  return [];
}

void _lastWatchedCourseIsarAttach(
  IsarCollection<dynamic> col,
  Id id,
  LastWatchedCourseIsar object,
) {
  object.id = id;
}

extension LastWatchedCourseIsarQueryWhereSort
    on QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QWhere> {
  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LastWatchedCourseIsarQueryWhere
    on
        QueryBuilder<
          LastWatchedCourseIsar,
          LastWatchedCourseIsar,
          QWhereClause
        > {
  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LastWatchedCourseIsarQueryFilter
    on
        QueryBuilder<
          LastWatchedCourseIsar,
          LastWatchedCourseIsar,
          QFilterCondition
        > {
  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'courseId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'courseId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'courseId', value: ''),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'courseId', value: ''),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'courseTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'courseTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'courseTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'courseTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'courseTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'courseTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'courseTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'courseTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'courseTitle', value: ''),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  courseTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'courseTitle', value: ''),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LastWatchedCourseIsar,
    LastWatchedCourseIsar,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LastWatchedCourseIsarQueryObject
    on
        QueryBuilder<
          LastWatchedCourseIsar,
          LastWatchedCourseIsar,
          QFilterCondition
        > {}

extension LastWatchedCourseIsarQueryLinks
    on
        QueryBuilder<
          LastWatchedCourseIsar,
          LastWatchedCourseIsar,
          QFilterCondition
        > {}

extension LastWatchedCourseIsarQuerySortBy
    on QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QSortBy> {
  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  sortByCourseTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseTitle', Sort.asc);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  sortByCourseTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseTitle', Sort.desc);
    });
  }
}

extension LastWatchedCourseIsarQuerySortThenBy
    on QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QSortThenBy> {
  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  thenByCourseTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseTitle', Sort.asc);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  thenByCourseTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseTitle', Sort.desc);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension LastWatchedCourseIsarQueryWhereDistinct
    on QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QDistinct> {
  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QDistinct>
  distinctByCourseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LastWatchedCourseIsar, LastWatchedCourseIsar, QDistinct>
  distinctByCourseTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseTitle', caseSensitive: caseSensitive);
    });
  }
}

extension LastWatchedCourseIsarQueryProperty
    on
        QueryBuilder<
          LastWatchedCourseIsar,
          LastWatchedCourseIsar,
          QQueryProperty
        > {
  QueryBuilder<LastWatchedCourseIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LastWatchedCourseIsar, String, QQueryOperations>
  courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<LastWatchedCourseIsar, String, QQueryOperations>
  courseTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseTitle');
    });
  }
}
