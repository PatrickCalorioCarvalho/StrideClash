// This is a generated file - do not edit.
//
// Generated from walk.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// SyncWalk uploads a walk recorded entirely offline: the client generates
/// its own id and keeps the walk (and every GPS point) locally the whole
/// time, then calls this once network is available. Safe to retry —
/// syncing the same client_walk_id twice just replays the same result.
class SyncWalkRequest extends $pb.GeneratedMessage {
  factory SyncWalkRequest({
    $core.String? clientWalkId,
    $core.String? userId,
    $core.String? championshipId,
    $1.Timestamp? startedAt,
    $1.Timestamp? finishedAt,
    $core.Iterable<WalkPoint>? points,
  }) {
    final result = create();
    if (clientWalkId != null) result.clientWalkId = clientWalkId;
    if (userId != null) result.userId = userId;
    if (championshipId != null) result.championshipId = championshipId;
    if (startedAt != null) result.startedAt = startedAt;
    if (finishedAt != null) result.finishedAt = finishedAt;
    if (points != null) result.points.addAll(points);
    return result;
  }

  SyncWalkRequest._();

  factory SyncWalkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncWalkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncWalkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientWalkId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'championshipId')
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'finishedAt',
        subBuilder: $1.Timestamp.create)
    ..pPM<WalkPoint>(6, _omitFieldNames ? '' : 'points',
        subBuilder: WalkPoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncWalkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncWalkRequest copyWith(void Function(SyncWalkRequest) updates) =>
      super.copyWith((message) => updates(message as SyncWalkRequest))
          as SyncWalkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncWalkRequest create() => SyncWalkRequest._();
  @$core.override
  SyncWalkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncWalkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncWalkRequest>(create);
  static SyncWalkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientWalkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientWalkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientWalkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientWalkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get championshipId => $_getSZ(2);
  @$pb.TagNumber(3)
  set championshipId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChampionshipId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChampionshipId() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get startedAt => $_getN(3);
  @$pb.TagNumber(4)
  set startedAt($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStartedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureStartedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.Timestamp get finishedAt => $_getN(4);
  @$pb.TagNumber(5)
  set finishedAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFinishedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearFinishedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureFinishedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<WalkPoint> get points => $_getList(5);
}

class SyncWalkResponse extends $pb.GeneratedMessage {
  factory SyncWalkResponse({
    $core.String? polygonWkt,
    $core.double? areaM2,
  }) {
    final result = create();
    if (polygonWkt != null) result.polygonWkt = polygonWkt;
    if (areaM2 != null) result.areaM2 = areaM2;
    return result;
  }

  SyncWalkResponse._();

  factory SyncWalkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncWalkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncWalkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'polygonWkt')
    ..aD(2, _omitFieldNames ? '' : 'areaM2')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncWalkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncWalkResponse copyWith(void Function(SyncWalkResponse) updates) =>
      super.copyWith((message) => updates(message as SyncWalkResponse))
          as SyncWalkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncWalkResponse create() => SyncWalkResponse._();
  @$core.override
  SyncWalkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncWalkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncWalkResponse>(create);
  static SyncWalkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get polygonWkt => $_getSZ(0);
  @$pb.TagNumber(1)
  set polygonWkt($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPolygonWkt() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolygonWkt() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get areaM2 => $_getN(1);
  @$pb.TagNumber(2)
  set areaM2($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAreaM2() => $_has(1);
  @$pb.TagNumber(2)
  void clearAreaM2() => $_clearField(2);
}

class WalkPoint extends $pb.GeneratedMessage {
  factory WalkPoint({
    $core.double? lat,
    $core.double? lng,
    $1.Timestamp? timestamp,
    $core.double? speed,
  }) {
    final result = create();
    if (lat != null) result.lat = lat;
    if (lng != null) result.lng = lng;
    if (timestamp != null) result.timestamp = timestamp;
    if (speed != null) result.speed = speed;
    return result;
  }

  WalkPoint._();

  factory WalkPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WalkPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WalkPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'lat')
    ..aD(2, _omitFieldNames ? '' : 'lng')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $1.Timestamp.create)
    ..aD(4, _omitFieldNames ? '' : 'speed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WalkPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WalkPoint copyWith(void Function(WalkPoint) updates) =>
      super.copyWith((message) => updates(message as WalkPoint)) as WalkPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WalkPoint create() => WalkPoint._();
  @$core.override
  WalkPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WalkPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WalkPoint>(create);
  static WalkPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get lat => $_getN(0);
  @$pb.TagNumber(1)
  set lat($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLat() => $_has(0);
  @$pb.TagNumber(1)
  void clearLat() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get lng => $_getN(1);
  @$pb.TagNumber(2)
  set lng($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLng() => $_has(1);
  @$pb.TagNumber(2)
  void clearLng() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get timestamp => $_getN(2);
  @$pb.TagNumber(3)
  set timestamp($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureTimestamp() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get speed => $_getN(3);
  @$pb.TagNumber(4)
  set speed($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpeed() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeed() => $_clearField(4);
}

class GetUserStatsRequest extends $pb.GeneratedMessage {
  factory GetUserStatsRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  GetUserStatsRequest._();

  factory GetUserStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserStatsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserStatsRequest copyWith(void Function(GetUserStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetUserStatsRequest))
          as GetUserStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserStatsRequest create() => GetUserStatsRequest._();
  @$core.override
  GetUserStatsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserStatsRequest>(create);
  static GetUserStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class GetUserStatsResponse extends $pb.GeneratedMessage {
  factory GetUserStatsResponse({
    $core.double? totalAreaM2,
    $core.int? walkCount,
    $core.Iterable<ChampionshipStat>? byChampionship,
  }) {
    final result = create();
    if (totalAreaM2 != null) result.totalAreaM2 = totalAreaM2;
    if (walkCount != null) result.walkCount = walkCount;
    if (byChampionship != null) result.byChampionship.addAll(byChampionship);
    return result;
  }

  GetUserStatsResponse._();

  factory GetUserStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserStatsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'totalAreaM2')
    ..aI(2, _omitFieldNames ? '' : 'walkCount')
    ..pPM<ChampionshipStat>(3, _omitFieldNames ? '' : 'byChampionship',
        subBuilder: ChampionshipStat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserStatsResponse copyWith(void Function(GetUserStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetUserStatsResponse))
          as GetUserStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserStatsResponse create() => GetUserStatsResponse._();
  @$core.override
  GetUserStatsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserStatsResponse>(create);
  static GetUserStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get totalAreaM2 => $_getN(0);
  @$pb.TagNumber(1)
  set totalAreaM2($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalAreaM2() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalAreaM2() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get walkCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set walkCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWalkCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearWalkCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ChampionshipStat> get byChampionship => $_getList(2);
}

/// Per-championship breakdown of a user's walked area. Walks whose
/// championship was deleted (championship_id set NULL) or that were never
/// tied to one are grouped together with championship_id empty.
class ChampionshipStat extends $pb.GeneratedMessage {
  factory ChampionshipStat({
    $core.String? championshipId,
    $core.String? championshipName,
    $core.double? areaM2,
    $core.int? walkCount,
  }) {
    final result = create();
    if (championshipId != null) result.championshipId = championshipId;
    if (championshipName != null) result.championshipName = championshipName;
    if (areaM2 != null) result.areaM2 = areaM2;
    if (walkCount != null) result.walkCount = walkCount;
    return result;
  }

  ChampionshipStat._();

  factory ChampionshipStat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChampionshipStat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChampionshipStat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'championshipId')
    ..aOS(2, _omitFieldNames ? '' : 'championshipName')
    ..aD(3, _omitFieldNames ? '' : 'areaM2')
    ..aI(4, _omitFieldNames ? '' : 'walkCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChampionshipStat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChampionshipStat copyWith(void Function(ChampionshipStat) updates) =>
      super.copyWith((message) => updates(message as ChampionshipStat))
          as ChampionshipStat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChampionshipStat create() => ChampionshipStat._();
  @$core.override
  ChampionshipStat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChampionshipStat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChampionshipStat>(create);
  static ChampionshipStat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get championshipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set championshipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChampionshipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChampionshipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get championshipName => $_getSZ(1);
  @$pb.TagNumber(2)
  set championshipName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChampionshipName() => $_has(1);
  @$pb.TagNumber(2)
  void clearChampionshipName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get areaM2 => $_getN(2);
  @$pb.TagNumber(3)
  set areaM2($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAreaM2() => $_has(2);
  @$pb.TagNumber(3)
  void clearAreaM2() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get walkCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set walkCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWalkCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearWalkCount() => $_clearField(4);
}

/// Drills into one ChampionshipStat group — championship_id empty means the
/// same "sem campeonato" group ChampionshipStat groups under an empty id.
class ListMyWalksRequest extends $pb.GeneratedMessage {
  factory ListMyWalksRequest({
    $core.String? userId,
    $core.String? championshipId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (championshipId != null) result.championshipId = championshipId;
    return result;
  }

  ListMyWalksRequest._();

  factory ListMyWalksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMyWalksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMyWalksRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'championshipId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyWalksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyWalksRequest copyWith(void Function(ListMyWalksRequest) updates) =>
      super.copyWith((message) => updates(message as ListMyWalksRequest))
          as ListMyWalksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMyWalksRequest create() => ListMyWalksRequest._();
  @$core.override
  ListMyWalksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMyWalksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMyWalksRequest>(create);
  static ListMyWalksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get championshipId => $_getSZ(1);
  @$pb.TagNumber(2)
  set championshipId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChampionshipId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChampionshipId() => $_clearField(2);
}

class ListMyWalksResponse extends $pb.GeneratedMessage {
  factory ListMyWalksResponse({
    $core.Iterable<WalkSummary>? walks,
  }) {
    final result = create();
    if (walks != null) result.walks.addAll(walks);
    return result;
  }

  ListMyWalksResponse._();

  factory ListMyWalksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMyWalksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMyWalksResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..pPM<WalkSummary>(1, _omitFieldNames ? '' : 'walks',
        subBuilder: WalkSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyWalksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyWalksResponse copyWith(void Function(ListMyWalksResponse) updates) =>
      super.copyWith((message) => updates(message as ListMyWalksResponse))
          as ListMyWalksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMyWalksResponse create() => ListMyWalksResponse._();
  @$core.override
  ListMyWalksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMyWalksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMyWalksResponse>(create);
  static ListMyWalksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WalkSummary> get walks => $_getList(0);
}

class WalkSummary extends $pb.GeneratedMessage {
  factory WalkSummary({
    $core.String? id,
    $1.Timestamp? startedAt,
    $1.Timestamp? finishedAt,
    $core.double? areaM2,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (startedAt != null) result.startedAt = startedAt;
    if (finishedAt != null) result.finishedAt = finishedAt;
    if (areaM2 != null) result.areaM2 = areaM2;
    return result;
  }

  WalkSummary._();

  factory WalkSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WalkSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WalkSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'finishedAt',
        subBuilder: $1.Timestamp.create)
    ..aD(4, _omitFieldNames ? '' : 'areaM2')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WalkSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WalkSummary copyWith(void Function(WalkSummary) updates) =>
      super.copyWith((message) => updates(message as WalkSummary))
          as WalkSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WalkSummary create() => WalkSummary._();
  @$core.override
  WalkSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WalkSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WalkSummary>(create);
  static WalkSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get startedAt => $_getN(1);
  @$pb.TagNumber(2)
  set startedAt($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStartedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureStartedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Timestamp get finishedAt => $_getN(2);
  @$pb.TagNumber(3)
  set finishedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFinishedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearFinishedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureFinishedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get areaM2 => $_getN(3);
  @$pb.TagNumber(4)
  set areaM2($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAreaM2() => $_has(3);
  @$pb.TagNumber(4)
  void clearAreaM2() => $_clearField(4);
}

class DeleteWalkRequest extends $pb.GeneratedMessage {
  factory DeleteWalkRequest({
    $core.String? walkId,
    $core.String? userId,
  }) {
    final result = create();
    if (walkId != null) result.walkId = walkId;
    if (userId != null) result.userId = userId;
    return result;
  }

  DeleteWalkRequest._();

  factory DeleteWalkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteWalkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteWalkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'walkId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWalkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWalkRequest copyWith(void Function(DeleteWalkRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteWalkRequest))
          as DeleteWalkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteWalkRequest create() => DeleteWalkRequest._();
  @$core.override
  DeleteWalkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteWalkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteWalkRequest>(create);
  static DeleteWalkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get walkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set walkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWalkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWalkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class DeleteWalkResponse extends $pb.GeneratedMessage {
  factory DeleteWalkResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteWalkResponse._();

  factory DeleteWalkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteWalkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteWalkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWalkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteWalkResponse copyWith(void Function(DeleteWalkResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteWalkResponse))
          as DeleteWalkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteWalkResponse create() => DeleteWalkResponse._();
  @$core.override
  DeleteWalkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteWalkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteWalkResponse>(create);
  static DeleteWalkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
