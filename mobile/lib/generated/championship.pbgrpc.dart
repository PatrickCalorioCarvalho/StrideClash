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

  $grpc.ResponseFuture<$0.ListChampionshipsResponse> listChampionships(
    $0.ListChampionshipsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listChampionships, request, options: options);
  }

  $grpc.ResponseFuture<$0.ChampionshipResponse> updateChampionshipEndDate(
    $0.UpdateChampionshipEndDateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateChampionshipEndDate, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.DeleteChampionshipResponse> deleteChampionship(
    $0.DeleteChampionshipRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteChampionship, request, options: options);
  }

  // method descriptors

  static final _$createChampionship =
      $grpc.ClientMethod<$0.CreateChampionshipRequest, $0.ChampionshipResponse>(
          '/game.ChampionshipService/CreateChampionship',
          ($0.CreateChampionshipRequest value) => value.writeToBuffer(),
          $0.ChampionshipResponse.fromBuffer);
  static final _$listChampionships = $grpc.ClientMethod<
          $0.ListChampionshipsRequest, $0.ListChampionshipsResponse>(
      '/game.ChampionshipService/ListChampionships',
      ($0.ListChampionshipsRequest value) => value.writeToBuffer(),
      $0.ListChampionshipsResponse.fromBuffer);
  static final _$updateChampionshipEndDate = $grpc.ClientMethod<
          $0.UpdateChampionshipEndDateRequest, $0.ChampionshipResponse>(
      '/game.ChampionshipService/UpdateChampionshipEndDate',
      ($0.UpdateChampionshipEndDateRequest value) => value.writeToBuffer(),
      $0.ChampionshipResponse.fromBuffer);
  static final _$deleteChampionship = $grpc.ClientMethod<
          $0.DeleteChampionshipRequest, $0.DeleteChampionshipResponse>(
      '/game.ChampionshipService/DeleteChampionship',
      ($0.DeleteChampionshipRequest value) => value.writeToBuffer(),
      $0.DeleteChampionshipResponse.fromBuffer);
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
    $addMethod($grpc.ServiceMethod<$0.ListChampionshipsRequest,
            $0.ListChampionshipsResponse>(
        'ListChampionships',
        listChampionships_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListChampionshipsRequest.fromBuffer(value),
        ($0.ListChampionshipsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateChampionshipEndDateRequest,
            $0.ChampionshipResponse>(
        'UpdateChampionshipEndDate',
        updateChampionshipEndDate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateChampionshipEndDateRequest.fromBuffer(value),
        ($0.ChampionshipResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteChampionshipRequest,
            $0.DeleteChampionshipResponse>(
        'DeleteChampionship',
        deleteChampionship_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteChampionshipRequest.fromBuffer(value),
        ($0.DeleteChampionshipResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ChampionshipResponse> createChampionship_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateChampionshipRequest> $request) async {
    return createChampionship($call, await $request);
  }

  $async.Future<$0.ChampionshipResponse> createChampionship(
      $grpc.ServiceCall call, $0.CreateChampionshipRequest request);

  $async.Future<$0.ListChampionshipsResponse> listChampionships_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListChampionshipsRequest> $request) async {
    return listChampionships($call, await $request);
  }

  $async.Future<$0.ListChampionshipsResponse> listChampionships(
      $grpc.ServiceCall call, $0.ListChampionshipsRequest request);

  $async.Future<$0.ChampionshipResponse> updateChampionshipEndDate_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateChampionshipEndDateRequest> $request) async {
    return updateChampionshipEndDate($call, await $request);
  }

  $async.Future<$0.ChampionshipResponse> updateChampionshipEndDate(
      $grpc.ServiceCall call, $0.UpdateChampionshipEndDateRequest request);

  $async.Future<$0.DeleteChampionshipResponse> deleteChampionship_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteChampionshipRequest> $request) async {
    return deleteChampionship($call, await $request);
  }

  $async.Future<$0.DeleteChampionshipResponse> deleteChampionship(
      $grpc.ServiceCall call, $0.DeleteChampionshipRequest request);
}
