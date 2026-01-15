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

@$core.Deprecated('Use startWalkRequestDescriptor instead')
const StartWalkRequest$json = {
  '1': 'StartWalkRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'championship_id', '3': 2, '4': 1, '5': 9, '10': 'championshipId'},
  ],
};

/// Descriptor for `StartWalkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startWalkRequestDescriptor = $convert.base64Decode(
    'ChBTdGFydFdhbGtSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBInCg9jaGFtcGlvbn'
    'NoaXBfaWQYAiABKAlSDmNoYW1waW9uc2hpcElk');

@$core.Deprecated('Use startWalkResponseDescriptor instead')
const StartWalkResponse$json = {
  '1': 'StartWalkResponse',
  '2': [
    {'1': 'walk_id', '3': 1, '4': 1, '5': 9, '10': 'walkId'},
    {
      '1': 'started_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `StartWalkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startWalkResponseDescriptor = $convert.base64Decode(
    'ChFTdGFydFdhbGtSZXNwb25zZRIXCgd3YWxrX2lkGAEgASgJUgZ3YWxrSWQSOQoKc3RhcnRlZF'
    '9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdA==');

@$core.Deprecated('Use finishWalkRequestDescriptor instead')
const FinishWalkRequest$json = {
  '1': 'FinishWalkRequest',
  '2': [
    {'1': 'walk_id', '3': 1, '4': 1, '5': 9, '10': 'walkId'},
    {
      '1': 'points',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.walk.WalkPoint',
      '10': 'points'
    },
  ],
};

/// Descriptor for `FinishWalkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishWalkRequestDescriptor = $convert.base64Decode(
    'ChFGaW5pc2hXYWxrUmVxdWVzdBIXCgd3YWxrX2lkGAEgASgJUgZ3YWxrSWQSJwoGcG9pbnRzGA'
    'IgAygLMg8ud2Fsay5XYWxrUG9pbnRSBnBvaW50cw==');

@$core.Deprecated('Use finishWalkResponseDescriptor instead')
const FinishWalkResponse$json = {
  '1': 'FinishWalkResponse',
  '2': [
    {'1': 'polygon_wkt', '3': 1, '4': 1, '5': 9, '10': 'polygonWkt'},
  ],
};

/// Descriptor for `FinishWalkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishWalkResponseDescriptor = $convert.base64Decode(
    'ChJGaW5pc2hXYWxrUmVzcG9uc2USHwoLcG9seWdvbl93a3QYASABKAlSCnBvbHlnb25Xa3Q=');

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
  ],
};

/// Descriptor for `WalkPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List walkPointDescriptor = $convert.base64Decode(
    'CglXYWxrUG9pbnQSEAoDbGF0GAEgASgBUgNsYXQSEAoDbG5nGAIgASgBUgNsbmcSOAoJdGltZX'
    'N0YW1wGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdGltZXN0YW1w');
