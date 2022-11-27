import 'dart:convert';

import 'package:hive_auth_demo/save_convert.dart';

class BridgeResponse {
  final bool valid;
  final String? username;
  final String error;
  final String? data;

  BridgeResponse({
    required this.valid,
    required this.username,
    required this.error,
    required this.data,
  });

  factory BridgeResponse.fromJson(Map<String, dynamic>? json) => BridgeResponse(
        valid: asBool(json, 'valid'),
        username: asString(json, 'username'),
        error: asString(json, 'error'),
        data: asString(json, 'data'),
      );

  factory BridgeResponse.fromJsonString(String jsonString) =>
      BridgeResponse.fromJson(json.decode(jsonString));

  Map<String, dynamic> toJson() => {
        'valid': valid,
        'username': username,
        'error': error,
      };
}

class UserInfoResponse {
  final String? token;
  final String? expire;

  UserInfoResponse({
    required this.token,
    required this.expire,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic>? json) =>
      UserInfoResponse(
        token: asString(json, 'token'),
        expire: asString(json, 'expire'),
      );

  factory UserInfoResponse.fromJsonString(String jsonString) =>
      UserInfoResponse.fromJson(json.decode(jsonString));
}
