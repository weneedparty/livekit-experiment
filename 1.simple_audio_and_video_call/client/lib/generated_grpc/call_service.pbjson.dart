///
//  Generated code. Do not modify.
//  source: call_service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use helloRequestDescriptor instead')
const HelloRequest$json = const {
  '1': 'HelloRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `HelloRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloRequestDescriptor = $convert.base64Decode('CgxIZWxsb1JlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZQ==');
@$core.Deprecated('Use helloReplyDescriptor instead')
const HelloReply$json = const {
  '1': 'HelloReply',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `HelloReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloReplyDescriptor = $convert.base64Decode('CgpIZWxsb1JlcGx5EhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use onlineRequestDescriptor instead')
const OnlineRequest$json = const {
  '1': 'OnlineRequest',
  '2': const [
    const {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `OnlineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onlineRequestDescriptor = $convert.base64Decode('Cg1PbmxpbmVSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbA==');
@$core.Deprecated('Use onlineResponseDescriptor instead')
const OnlineResponse$json = const {
  '1': 'OnlineResponse',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9, '10': 'error'},
    const {'1': 'json_string', '3': 2, '4': 1, '5': 9, '10': 'jsonString'},
    const {'1': 'call_coming', '3': 3, '4': 1, '5': 8, '10': 'callComing'},
    const {'1': 'room_name', '3': 4, '4': 1, '5': 9, '10': 'roomName'},
    const {'1': 'call_initiator', '3': 5, '4': 1, '5': 9, '10': 'callInitiator'},
    const {'1': 'token', '3': 6, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `OnlineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onlineResponseDescriptor = $convert.base64Decode('Cg5PbmxpbmVSZXNwb25zZRIUCgVlcnJvchgBIAEoCVIFZXJyb3ISHwoLanNvbl9zdHJpbmcYAiABKAlSCmpzb25TdHJpbmcSHwoLY2FsbF9jb21pbmcYAyABKAhSCmNhbGxDb21pbmcSGwoJcm9vbV9uYW1lGAQgASgJUghyb29tTmFtZRIlCg5jYWxsX2luaXRpYXRvchgFIAEoCVINY2FsbEluaXRpYXRvchIUCgV0b2tlbhgGIAEoCVIFdG9rZW4=');
@$core.Deprecated('Use callRequestDescriptor instead')
const CallRequest$json = const {
  '1': 'CallRequest',
  '2': const [
    const {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'target_email', '3': 2, '4': 1, '5': 9, '10': 'targetEmail'},
  ],
};

/// Descriptor for `CallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callRequestDescriptor = $convert.base64Decode('CgtDYWxsUmVxdWVzdBIUCgVlbWFpbBgBIAEoCVIFZW1haWwSIQoMdGFyZ2V0X2VtYWlsGAIgASgJUgt0YXJnZXRFbWFpbA==');
@$core.Deprecated('Use callResponseDescriptor instead')
const CallResponse$json = const {
  '1': 'CallResponse',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9, '10': 'error'},
    const {'1': 'json_string', '3': 2, '4': 1, '5': 9, '10': 'jsonString'},
    const {'1': 'room_name', '3': 3, '4': 1, '5': 9, '10': 'roomName'},
    const {'1': 'token', '3': 4, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `CallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callResponseDescriptor = $convert.base64Decode('CgxDYWxsUmVzcG9uc2USFAoFZXJyb3IYASABKAlSBWVycm9yEh8KC2pzb25fc3RyaW5nGAIgASgJUgpqc29uU3RyaW5nEhsKCXJvb21fbmFtZRgDIAEoCVIIcm9vbU5hbWUSFAoFdG9rZW4YBCABKAlSBXRva2Vu');
