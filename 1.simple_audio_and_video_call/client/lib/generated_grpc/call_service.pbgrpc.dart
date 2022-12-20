///
//  Generated code. Do not modify.
//  source: call_service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'call_service.pb.dart' as $0;
export 'call_service.pb.dart';

class CallServiceClient extends $grpc.Client {
  static final _$sayHello = $grpc.ClientMethod<$0.HelloRequest, $0.HelloReply>(
      '/call_service.CallService/SayHello',
      ($0.HelloRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HelloReply.fromBuffer(value));
  static final _$iAmOnline =
      $grpc.ClientMethod<$0.OnlineRequest, $0.OnlineResponse>(
          '/call_service.CallService/IAmOnline',
          ($0.OnlineRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.OnlineResponse.fromBuffer(value));
  static final _$makeACall =
      $grpc.ClientMethod<$0.CallRequest, $0.CallResponse>(
          '/call_service.CallService/MakeACall',
          ($0.CallRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.CallResponse.fromBuffer(value));

  CallServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.HelloReply> sayHello($0.HelloRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sayHello, request, options: options);
  }

  $grpc.ResponseFuture<$0.OnlineResponse> iAmOnline($0.OnlineRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$iAmOnline, request, options: options);
  }

  $grpc.ResponseFuture<$0.CallResponse> makeACall($0.CallRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$makeACall, request, options: options);
  }
}

abstract class CallServiceBase extends $grpc.Service {
  $core.String get $name => 'call_service.CallService';

  CallServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.HelloRequest, $0.HelloReply>(
        'SayHello',
        sayHello_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HelloRequest.fromBuffer(value),
        ($0.HelloReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OnlineRequest, $0.OnlineResponse>(
        'IAmOnline',
        iAmOnline_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.OnlineRequest.fromBuffer(value),
        ($0.OnlineResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CallRequest, $0.CallResponse>(
        'MakeACall',
        makeACall_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CallRequest.fromBuffer(value),
        ($0.CallResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.HelloReply> sayHello_Pre(
      $grpc.ServiceCall call, $async.Future<$0.HelloRequest> request) async {
    return sayHello(call, await request);
  }

  $async.Future<$0.OnlineResponse> iAmOnline_Pre(
      $grpc.ServiceCall call, $async.Future<$0.OnlineRequest> request) async {
    return iAmOnline(call, await request);
  }

  $async.Future<$0.CallResponse> makeACall_Pre(
      $grpc.ServiceCall call, $async.Future<$0.CallRequest> request) async {
    return makeACall(call, await request);
  }

  $async.Future<$0.HelloReply> sayHello(
      $grpc.ServiceCall call, $0.HelloRequest request);
  $async.Future<$0.OnlineResponse> iAmOnline(
      $grpc.ServiceCall call, $0.OnlineRequest request);
  $async.Future<$0.CallResponse> makeACall(
      $grpc.ServiceCall call, $0.CallRequest request);
}
