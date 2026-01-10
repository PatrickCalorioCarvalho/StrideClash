// This is a generated file - do not edit.
//
// Generated from championship.proto.

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

import 'championship.pb.dart' as $0;

export 'championship.pb.dart';

@$pb.GrpcServiceName('game.ChampionshipService')
class ChampionshipServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChampionshipServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ChampionshipResponse> createChampionship(
    $0.CreateChampionshipRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createChampionship, request, options: options);
  }

  // method descriptors

  static final _$createChampionship =
      $grpc.ClientMethod<$0.CreateChampionshipRequest, $0.ChampionshipResponse>(
          '/game.ChampionshipService/CreateChampionship',
          ($0.CreateChampionshipRequest value) => value.writeToBuffer(),
          $0.ChampionshipResponse.fromBuffer);
}

@$pb.GrpcServiceName('game.ChampionshipService')
abstract class ChampionshipServiceBase extends $grpc.Service {
  $core.String get $name => 'game.ChampionshipService';

  ChampionshipServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateChampionshipRequest,
            $0.ChampionshipResponse>(
        'CreateChampionship',
        createChampionship_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateChampionshipRequest.fromBuffer(value),
        ($0.ChampionshipResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ChampionshipResponse> createChampionship_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateChampionshipRequest> $request) async {
    return createChampionship($call, await $request);
  }

  $async.Future<$0.ChampionshipResponse> createChampionship(
      $grpc.ServiceCall call, $0.CreateChampionshipRequest request);
}
