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

  $grpc.ResponseFuture<$0.StartWalkResponse> startWalk(
    $0.StartWalkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startWalk, request, options: options);
  }

  $grpc.ResponseFuture<$0.FinishWalkResponse> finishWalk(
    $0.FinishWalkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishWalk, request, options: options);
  }

  // method descriptors

  static final _$startWalk =
      $grpc.ClientMethod<$0.StartWalkRequest, $0.StartWalkResponse>(
          '/walk.WalkService/StartWalk',
          ($0.StartWalkRequest value) => value.writeToBuffer(),
          $0.StartWalkResponse.fromBuffer);
  static final _$finishWalk =
      $grpc.ClientMethod<$0.FinishWalkRequest, $0.FinishWalkResponse>(
          '/walk.WalkService/FinishWalk',
          ($0.FinishWalkRequest value) => value.writeToBuffer(),
          $0.FinishWalkResponse.fromBuffer);
}

@$pb.GrpcServiceName('walk.WalkService')
abstract class WalkServiceBase extends $grpc.Service {
  $core.String get $name => 'walk.WalkService';

  WalkServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.StartWalkRequest, $0.StartWalkResponse>(
        'StartWalk',
        startWalk_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StartWalkRequest.fromBuffer(value),
        ($0.StartWalkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FinishWalkRequest, $0.FinishWalkResponse>(
        'FinishWalk',
        finishWalk_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FinishWalkRequest.fromBuffer(value),
        ($0.FinishWalkResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.StartWalkResponse> startWalk_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StartWalkRequest> $request) async {
    return startWalk($call, await $request);
  }

  $async.Future<$0.StartWalkResponse> startWalk(
      $grpc.ServiceCall call, $0.StartWalkRequest request);

  $async.Future<$0.FinishWalkResponse> finishWalk_Pre($grpc.ServiceCall $call,
      $async.Future<$0.FinishWalkRequest> $request) async {
    return finishWalk($call, await $request);
  }

  $async.Future<$0.FinishWalkResponse> finishWalk(
      $grpc.ServiceCall call, $0.FinishWalkRequest request);
}
