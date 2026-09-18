// This is a generated file - do not edit.
//
// Generated from walk.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'walk.pb.dart' as $0;

export 'walk.pb.dart';

@$pb.GrpcServiceName('walk.WalkService')
class WalkServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  WalkServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SyncWalkResponse> syncWalk(
    $0.SyncWalkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$syncWalk, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserStatsResponse> getUserStats(
    $0.GetUserStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserStats, request, options: options);
  }

  // method descriptors

  static final _$syncWalk =
      $grpc.ClientMethod<$0.SyncWalkRequest, $0.SyncWalkResponse>(
          '/walk.WalkService/SyncWalk',
          ($0.SyncWalkRequest value) => value.writeToBuffer(),
          $0.SyncWalkResponse.fromBuffer);
  static final _$getUserStats =
      $grpc.ClientMethod<$0.GetUserStatsRequest, $0.GetUserStatsResponse>(
          '/walk.WalkService/GetUserStats',
          ($0.GetUserStatsRequest value) => value.writeToBuffer(),
          $0.GetUserStatsResponse.fromBuffer);
}

@$pb.GrpcServiceName('walk.WalkService')
abstract class WalkServiceBase extends $grpc.Service {
  $core.String get $name => 'walk.WalkService';

  WalkServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SyncWalkRequest, $0.SyncWalkResponse>(
        'SyncWalk',
        syncWalk_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncWalkRequest.fromBuffer(value),
        ($0.SyncWalkResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetUserStatsRequest, $0.GetUserStatsResponse>(
            'GetUserStats',
            getUserStats_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetUserStatsRequest.fromBuffer(value),
            ($0.GetUserStatsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SyncWalkResponse> syncWalk_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SyncWalkRequest> $request) async {
    return syncWalk($call, await $request);
  }

  $async.Future<$0.SyncWalkResponse> syncWalk(
      $grpc.ServiceCall call, $0.SyncWalkRequest request);

  $async.Future<$0.GetUserStatsResponse> getUserStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUserStatsRequest> $request) async {
    return getUserStats($call, await $request);
  }

  $async.Future<$0.GetUserStatsResponse> getUserStats(
      $grpc.ServiceCall call, $0.GetUserStatsRequest request);
}
