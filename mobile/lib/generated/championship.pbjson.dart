// This is a generated file - do not edit.
//
// Generated from championship.proto.

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

@$core.Deprecated('Use championshipDescriptor instead')
const Championship$json = {
  '1': 'Championship',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'start_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startAt'
    },
    {
      '1': 'end_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endAt'
    },
  ],
};

/// Descriptor for `Championship`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List championshipDescriptor = $convert.base64Decode(
    'CgxDaGFtcGlvbnNoaXASDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSNQoIc3'
    'RhcnRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdzdGFydEF0EjEKBmVu'
    'ZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWVuZEF0');

@$core.Deprecated('Use createChampionshipRequestDescriptor instead')
const CreateChampionshipRequest$json = {
  '1': 'CreateChampionshipRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'start_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startAt'
    },
    {
      '1': 'end_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endAt'
    },
  ],
};

/// Descriptor for `CreateChampionshipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChampionshipRequestDescriptor = $convert.base64Decode(
    'ChlDcmVhdGVDaGFtcGlvbnNoaXBSZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWUSNQoIc3Rhcn'
    'RfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdzdGFydEF0EjEKBmVuZF9h'
    'dBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWVuZEF0');

@$core.Deprecated('Use championshipResponseDescriptor instead')
const ChampionshipResponse$json = {
  '1': 'ChampionshipResponse',
  '2': [
    {
      '1': 'championship',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.game.Championship',
      '10': 'championship'
    },
  ],
};

/// Descriptor for `ChampionshipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List championshipResponseDescriptor = $convert.base64Decode(
    'ChRDaGFtcGlvbnNoaXBSZXNwb25zZRI2CgxjaGFtcGlvbnNoaXAYASABKAsyEi5nYW1lLkNoYW'
    '1waW9uc2hpcFIMY2hhbXBpb25zaGlw');

@$core.Deprecated('Use listChampionshipsRequestDescriptor instead')
const ListChampionshipsRequest$json = {
  '1': 'ListChampionshipsRequest',
};

/// Descriptor for `ListChampionshipsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChampionshipsRequestDescriptor =
    $convert.base64Decode('ChhMaXN0Q2hhbXBpb25zaGlwc1JlcXVlc3Q=');

@$core.Deprecated('Use listChampionshipsResponseDescriptor instead')
const ListChampionshipsResponse$json = {
  '1': 'ListChampionshipsResponse',
  '2': [
    {
      '1': 'championships',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.game.Championship',
      '10': 'championships'
    },
  ],
};

/// Descriptor for `ListChampionshipsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChampionshipsResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0Q2hhbXBpb25zaGlwc1Jlc3BvbnNlEjgKDWNoYW1waW9uc2hpcHMYASADKAsyEi5nYW'
        '1lLkNoYW1waW9uc2hpcFINY2hhbXBpb25zaGlwcw==');

@$core.Deprecated('Use updateChampionshipEndDateRequestDescriptor instead')
const UpdateChampionshipEndDateRequest$json = {
  '1': 'UpdateChampionshipEndDateRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'new_end_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'newEndAt'
    },
  ],
};

/// Descriptor for `UpdateChampionshipEndDateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateChampionshipEndDateRequestDescriptor =
    $convert.base64Decode(
        'CiBVcGRhdGVDaGFtcGlvbnNoaXBFbmREYXRlUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSOAoKbm'
        'V3X2VuZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCG5ld0VuZEF0');

@$core.Deprecated('Use deleteChampionshipRequestDescriptor instead')
const DeleteChampionshipRequest$json = {
  '1': 'DeleteChampionshipRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteChampionshipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChampionshipRequestDescriptor =
    $convert.base64Decode(
        'ChlEZWxldGVDaGFtcGlvbnNoaXBSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use deleteChampionshipResponseDescriptor instead')
const DeleteChampionshipResponse$json = {
  '1': 'DeleteChampionshipResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteChampionshipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChampionshipResponseDescriptor =
    $convert.base64Decode(
        'ChpEZWxldGVDaGFtcGlvbnNoaXBSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');
