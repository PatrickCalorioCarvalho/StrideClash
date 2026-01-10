// This is a generated file - do not edit.
//
// Generated from championship.proto.

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

class Championship extends $pb.GeneratedMessage {
  factory Championship({
    $core.String? id,
    $core.String? name,
    $1.Timestamp? startAt,
    $1.Timestamp? endAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (startAt != null) result.startAt = startAt;
    if (endAt != null) result.endAt = endAt;
    return result;
  }

  Championship._();

  factory Championship.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Championship.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Championship',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'game'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'startAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'endAt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Championship clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Championship copyWith(void Function(Championship) updates) =>
      super.copyWith((message) => updates(message as Championship))
          as Championship;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Championship create() => Championship._();
  @$core.override
  Championship createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Championship getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Championship>(create);
  static Championship? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get startAt => $_getN(2);
  @$pb.TagNumber(3)
  set startAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureStartAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.Timestamp get endAt => $_getN(3);
  @$pb.TagNumber(4)
  set endAt($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEndAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureEndAt() => $_ensure(3);
}

class CreateChampionshipRequest extends $pb.GeneratedMessage {
  factory CreateChampionshipRequest({
    $core.String? name,
    $1.Timestamp? startAt,
    $1.Timestamp? endAt,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (startAt != null) result.startAt = startAt;
    if (endAt != null) result.endAt = endAt;
    return result;
  }

  CreateChampionshipRequest._();

  factory CreateChampionshipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateChampionshipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChampionshipRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'game'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'startAt',
        subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'endAt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChampionshipRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChampionshipRequest copyWith(
          void Function(CreateChampionshipRequest) updates) =>
      super.copyWith((message) => updates(message as CreateChampionshipRequest))
          as CreateChampionshipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateChampionshipRequest create() => CreateChampionshipRequest._();
  @$core.override
  CreateChampionshipRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateChampionshipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChampionshipRequest>(create);
  static CreateChampionshipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get startAt => $_getN(1);
  @$pb.TagNumber(2)
  set startAt($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStartAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureStartAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Timestamp get endAt => $_getN(2);
  @$pb.TagNumber(3)
  set endAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEndAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureEndAt() => $_ensure(2);
}

class ChampionshipResponse extends $pb.GeneratedMessage {
  factory ChampionshipResponse({
    Championship? championship,
  }) {
    final result = create();
    if (championship != null) result.championship = championship;
    return result;
  }

  ChampionshipResponse._();

  factory ChampionshipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChampionshipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChampionshipResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'game'),
      createEmptyInstance: create)
    ..aOM<Championship>(1, _omitFieldNames ? '' : 'championship',
        subBuilder: Championship.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChampionshipResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChampionshipResponse copyWith(void Function(ChampionshipResponse) updates) =>
      super.copyWith((message) => updates(message as ChampionshipResponse))
          as ChampionshipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChampionshipResponse create() => ChampionshipResponse._();
  @$core.override
  ChampionshipResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChampionshipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChampionshipResponse>(create);
  static ChampionshipResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Championship get championship => $_getN(0);
  @$pb.TagNumber(1)
  set championship(Championship value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChampionship() => $_has(0);
  @$pb.TagNumber(1)
  void clearChampionship() => $_clearField(1);
  @$pb.TagNumber(1)
  Championship ensureChampionship() => $_ensure(0);
}

class ListChampionshipsRequest extends $pb.GeneratedMessage {
  factory ListChampionshipsRequest() => create();

  ListChampionshipsRequest._();

  factory ListChampionshipsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListChampionshipsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChampionshipsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'game'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChampionshipsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChampionshipsRequest copyWith(
          void Function(ListChampionshipsRequest) updates) =>
      super.copyWith((message) => updates(message as ListChampionshipsRequest))
          as ListChampionshipsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChampionshipsRequest create() => ListChampionshipsRequest._();
  @$core.override
  ListChampionshipsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListChampionshipsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChampionshipsRequest>(create);
  static ListChampionshipsRequest? _defaultInstance;
}

class ListChampionshipsResponse extends $pb.GeneratedMessage {
  factory ListChampionshipsResponse({
    $core.Iterable<Championship>? championships,
  }) {
    final result = create();
    if (championships != null) result.championships.addAll(championships);
    return result;
  }

  ListChampionshipsResponse._();

  factory ListChampionshipsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListChampionshipsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChampionshipsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'game'),
      createEmptyInstance: create)
    ..pPM<Championship>(1, _omitFieldNames ? '' : 'championships',
        subBuilder: Championship.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChampionshipsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChampionshipsResponse copyWith(
          void Function(ListChampionshipsResponse) updates) =>
      super.copyWith((message) => updates(message as ListChampionshipsResponse))
          as ListChampionshipsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChampionshipsResponse create() => ListChampionshipsResponse._();
  @$core.override
  ListChampionshipsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListChampionshipsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChampionshipsResponse>(create);
  static ListChampionshipsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Championship> get championships => $_getList(0);
}

class UpdateChampionshipEndDateRequest extends $pb.GeneratedMessage {
  factory UpdateChampionshipEndDateRequest({
    $core.String? id,
    $1.Timestamp? newEndAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (newEndAt != null) result.newEndAt = newEndAt;
    return result;
  }

  UpdateChampionshipEndDateRequest._();

  factory UpdateChampionshipEndDateRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateChampionshipEndDateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateChampionshipEndDateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'game'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'newEndAt',
        subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChampionshipEndDateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateChampionshipEndDateRequest copyWith(
          void Function(UpdateChampionshipEndDateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateChampionshipEndDateRequest))
          as UpdateChampionshipEndDateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateChampionshipEndDateRequest create() =>
      UpdateChampionshipEndDateRequest._();
  @$core.override
  UpdateChampionshipEndDateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateChampionshipEndDateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateChampionshipEndDateRequest>(
          create);
  static UpdateChampionshipEndDateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get newEndAt => $_getN(1);
  @$pb.TagNumber(2)
  set newEndAt($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNewEndAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewEndAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureNewEndAt() => $_ensure(1);
}

class DeleteChampionshipRequest extends $pb.GeneratedMessage {
  factory DeleteChampionshipRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  DeleteChampionshipRequest._();

  factory DeleteChampionshipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteChampionshipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteChampionshipRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'game'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChampionshipRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChampionshipRequest copyWith(
          void Function(DeleteChampionshipRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteChampionshipRequest))
          as DeleteChampionshipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteChampionshipRequest create() => DeleteChampionshipRequest._();
  @$core.override
  DeleteChampionshipRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteChampionshipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteChampionshipRequest>(create);
  static DeleteChampionshipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteChampionshipResponse extends $pb.GeneratedMessage {
  factory DeleteChampionshipResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteChampionshipResponse._();

  factory DeleteChampionshipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteChampionshipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteChampionshipResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'game'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChampionshipResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChampionshipResponse copyWith(
          void Function(DeleteChampionshipResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteChampionshipResponse))
          as DeleteChampionshipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteChampionshipResponse create() => DeleteChampionshipResponse._();
  @$core.override
  DeleteChampionshipResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteChampionshipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteChampionshipResponse>(create);
  static DeleteChampionshipResponse? _defaultInstance;

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
