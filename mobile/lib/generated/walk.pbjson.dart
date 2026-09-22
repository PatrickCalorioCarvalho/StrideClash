// This is a generated file - do not edit.
//
// Generated from walk.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use syncWalkRequestDescriptor instead')
const SyncWalkRequest$json = {
  '1': 'SyncWalkRequest',
  '2': [
    {'1': 'client_walk_id', '3': 1, '4': 1, '5': 9, '10': 'clientWalkId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'championship_id', '3': 3, '4': 1, '5': 9, '10': 'championshipId'},
    {
      '1': 'started_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'finished_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'finishedAt'
    },
    {
      '1': 'points',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.walk.WalkPoint',
      '10': 'points'
    },
  ],
};

/// Descriptor for `SyncWalkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncWalkRequestDescriptor = $convert.base64Decode(
    'Cg9TeW5jV2Fsa1JlcXVlc3QSJAoOY2xpZW50X3dhbGtfaWQYASABKAlSDGNsaWVudFdhbGtJZB'
    'IXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQSJwoPY2hhbXBpb25zaGlwX2lkGAMgASgJUg5jaGFt'
    'cGlvbnNoaXBJZBI5CgpzdGFydGVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJc3RhcnRlZEF0EjsKC2ZpbmlzaGVkX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIKZmluaXNoZWRBdBInCgZwb2ludHMYBiADKAsyDy53YWxrLldhbGtQb2ludFIGcG'
    '9pbnRz');

@$core.Deprecated('Use syncWalkResponseDescriptor instead')
const SyncWalkResponse$json = {
  '1': 'SyncWalkResponse',
  '2': [
    {'1': 'polygon_wkt', '3': 1, '4': 1, '5': 9, '10': 'polygonWkt'},
    {'1': 'area_m2', '3': 2, '4': 1, '5': 1, '10': 'areaM2'},
  ],
};

/// Descriptor for `SyncWalkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncWalkResponseDescriptor = $convert.base64Decode(
    'ChBTeW5jV2Fsa1Jlc3BvbnNlEh8KC3BvbHlnb25fd2t0GAEgASgJUgpwb2x5Z29uV2t0EhcKB2'
    'FyZWFfbTIYAiABKAFSBmFyZWFNMg==');

@$core.Deprecated('Use walkPointDescriptor instead')
const WalkPoint$json = {
  '1': 'WalkPoint',
  '2': [
    {'1': 'lat', '3': 1, '4': 1, '5': 1, '10': 'lat'},
    {'1': 'lng', '3': 2, '4': 1, '5': 1, '10': 'lng'},
    {
      '1': 'timestamp',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {'1': 'speed', '3': 4, '4': 1, '5': 1, '10': 'speed'},
  ],
};

/// Descriptor for `WalkPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List walkPointDescriptor = $convert.base64Decode(
    'CglXYWxrUG9pbnQSEAoDbGF0GAEgASgBUgNsYXQSEAoDbG5nGAIgASgBUgNsbmcSOAoJdGltZX'
    'N0YW1wGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdGltZXN0YW1wEhQKBXNw'
    'ZWVkGAQgASgBUgVzcGVlZA==');

@$core.Deprecated('Use getUserStatsRequestDescriptor instead')
const GetUserStatsRequest$json = {
  '1': 'GetUserStatsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetUserStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserStatsRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRVc2VyU3RhdHNSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use getUserStatsResponseDescriptor instead')
const GetUserStatsResponse$json = {
  '1': 'GetUserStatsResponse',
  '2': [
    {'1': 'total_area_m2', '3': 1, '4': 1, '5': 1, '10': 'totalAreaM2'},
    {'1': 'walk_count', '3': 2, '4': 1, '5': 5, '10': 'walkCount'},
    {
      '1': 'by_championship',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.walk.ChampionshipStat',
      '10': 'byChampionship'
    },
  ],
};

/// Descriptor for `GetUserStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserStatsResponseDescriptor = $convert.base64Decode(
    'ChRHZXRVc2VyU3RhdHNSZXNwb25zZRIiCg10b3RhbF9hcmVhX20yGAEgASgBUgt0b3RhbEFyZW'
    'FNMhIdCgp3YWxrX2NvdW50GAIgASgFUgl3YWxrQ291bnQSPwoPYnlfY2hhbXBpb25zaGlwGAMg'
    'AygLMhYud2Fsay5DaGFtcGlvbnNoaXBTdGF0Ug5ieUNoYW1waW9uc2hpcA==');

@$core.Deprecated('Use championshipStatDescriptor instead')
const ChampionshipStat$json = {
  '1': 'ChampionshipStat',
  '2': [
    {'1': 'championship_id', '3': 1, '4': 1, '5': 9, '10': 'championshipId'},
    {
      '1': 'championship_name',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'championshipName'
    },
    {'1': 'area_m2', '3': 3, '4': 1, '5': 1, '10': 'areaM2'},
    {'1': 'walk_count', '3': 4, '4': 1, '5': 5, '10': 'walkCount'},
  ],
};

/// Descriptor for `ChampionshipStat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List championshipStatDescriptor = $convert.base64Decode(
    'ChBDaGFtcGlvbnNoaXBTdGF0EicKD2NoYW1waW9uc2hpcF9pZBgBIAEoCVIOY2hhbXBpb25zaG'
    'lwSWQSKwoRY2hhbXBpb25zaGlwX25hbWUYAiABKAlSEGNoYW1waW9uc2hpcE5hbWUSFwoHYXJl'
    'YV9tMhgDIAEoAVIGYXJlYU0yEh0KCndhbGtfY291bnQYBCABKAVSCXdhbGtDb3VudA==');

@$core.Deprecated('Use listMyWalksRequestDescriptor instead')
const ListMyWalksRequest$json = {
  '1': 'ListMyWalksRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'championship_id', '3': 2, '4': 1, '5': 9, '10': 'championshipId'},
  ],
};

/// Descriptor for `ListMyWalksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMyWalksRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0TXlXYWxrc1JlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEicKD2NoYW1waW'
    '9uc2hpcF9pZBgCIAEoCVIOY2hhbXBpb25zaGlwSWQ=');

@$core.Deprecated('Use listMyWalksResponseDescriptor instead')
const ListMyWalksResponse$json = {
  '1': 'ListMyWalksResponse',
  '2': [
    {
      '1': 'walks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.walk.WalkSummary',
      '10': 'walks'
    },
  ],
};

/// Descriptor for `ListMyWalksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMyWalksResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0TXlXYWxrc1Jlc3BvbnNlEicKBXdhbGtzGAEgAygLMhEud2Fsay5XYWxrU3VtbWFyeV'
    'IFd2Fsa3M=');

@$core.Deprecated('Use walkSummaryDescriptor instead')
const WalkSummary$json = {
  '1': 'WalkSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'started_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'finished_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'finishedAt'
    },
    {'1': 'area_m2', '3': 4, '4': 1, '5': 1, '10': 'areaM2'},
  ],
};

/// Descriptor for `WalkSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List walkSummaryDescriptor = $convert.base64Decode(
    'CgtXYWxrU3VtbWFyeRIOCgJpZBgBIAEoCVICaWQSOQoKc3RhcnRlZF9hdBgCIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBI7CgtmaW5pc2hlZF9hdBgDIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmZpbmlzaGVkQXQSFwoHYXJlYV9tMhgEIAEoAV'
    'IGYXJlYU0y');

@$core.Deprecated('Use deleteWalkRequestDescriptor instead')
const DeleteWalkRequest$json = {
  '1': 'DeleteWalkRequest',
  '2': [
    {'1': 'walk_id', '3': 1, '4': 1, '5': 9, '10': 'walkId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `DeleteWalkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteWalkRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVXYWxrUmVxdWVzdBIXCgd3YWxrX2lkGAEgASgJUgZ3YWxrSWQSFwoHdXNlcl9pZB'
    'gCIAEoCVIGdXNlcklk');

@$core.Deprecated('Use deleteWalkResponseDescriptor instead')
const DeleteWalkResponse$json = {
  '1': 'DeleteWalkResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteWalkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteWalkResponseDescriptor =
    $convert.base64Decode(
        'ChJEZWxldGVXYWxrUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');
