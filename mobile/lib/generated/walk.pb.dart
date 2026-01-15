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

class StartWalkRequest extends $pb.GeneratedMessage {
  factory StartWalkRequest({
    $core.String? userId,
    $core.String? championshipId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (championshipId != null) result.championshipId = championshipId;
    return result;
  }

  StartWalkRequest._();

  factory StartWalkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartWalkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartWalkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'championshipId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWalkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWalkRequest copyWith(void Function(StartWalkRequest) updates) =>
      super.copyWith((message) => updates(message as StartWalkRequest))
          as StartWalkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartWalkRequest create() => StartWalkRequest._();
  @$core.override
  StartWalkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartWalkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartWalkRequest>(create);
  static StartWalkRequest? _defaultInstance;

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

class StartWalkResponse extends $pb.GeneratedMessage {
  factory StartWalkResponse({
    $core.String? walkId,
    $1.Timestamp? startedAt,
  }) {
    final result = create();
    if (walkId != null) result.walkId = walkId;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  StartWalkResponse._();

  factory StartWalkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartWalkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartWalkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'walkId')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWalkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWalkResponse copyWith(void Function(StartWalkResponse) updates) =>
      super.copyWith((message) => updates(message as StartWalkResponse))
          as StartWalkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartWalkResponse create() => StartWalkResponse._();
  @$core.override
  StartWalkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartWalkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartWalkResponse>(create);
  static StartWalkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get walkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set walkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWalkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWalkId() => $_clearField(1);

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
}

class FinishWalkRequest extends $pb.GeneratedMessage {
  factory FinishWalkRequest({
    $core.String? walkId,
    $core.Iterable<WalkPoint>? points,
  }) {
    final result = create();
    if (walkId != null) result.walkId = walkId;
    if (points != null) result.points.addAll(points);
    return result;
  }

  FinishWalkRequest._();

  factory FinishWalkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishWalkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishWalkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'walkId')
    ..pPM<WalkPoint>(2, _omitFieldNames ? '' : 'points',
        subBuilder: WalkPoint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishWalkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishWalkRequest copyWith(void Function(FinishWalkRequest) updates) =>
      super.copyWith((message) => updates(message as FinishWalkRequest))
          as FinishWalkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishWalkRequest create() => FinishWalkRequest._();
  @$core.override
  FinishWalkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishWalkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishWalkRequest>(create);
  static FinishWalkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get walkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set walkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWalkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWalkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<WalkPoint> get points => $_getList(1);
}

class FinishWalkResponse extends $pb.GeneratedMessage {
  factory FinishWalkResponse({
    $core.String? polygonWkt,
  }) {
    final result = create();
    if (polygonWkt != null) result.polygonWkt = polygonWkt;
    return result;
  }

  FinishWalkResponse._();

  factory FinishWalkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishWalkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishWalkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'walk'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'polygonWkt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishWalkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishWalkResponse copyWith(void Function(FinishWalkResponse) updates) =>
      super.copyWith((message) => updates(message as FinishWalkResponse))
          as FinishWalkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishWalkResponse create() => FinishWalkResponse._();
  @$core.override
  FinishWalkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishWalkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishWalkResponse>(create);
  static FinishWalkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get polygonWkt => $_getSZ(0);
  @$pb.TagNumber(1)
  set polygonWkt($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPolygonWkt() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolygonWkt() => $_clearField(1);
}

class WalkPoint extends $pb.GeneratedMessage {
  factory WalkPoint({
    $core.double? lat,
    $core.double? lng,
    $1.Timestamp? timestamp,
  }) {
    final result = create();
    if (lat != null) result.lat = lat;
    if (lng != null) result.lng = lng;
    if (timestamp != null) result.timestamp = timestamp;
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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
