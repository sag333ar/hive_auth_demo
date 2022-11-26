import 'dart:convert';

import 'package:hive_auth_demo/save_convert.dart';

class BridgeResponse {
  final bool valid;
  final String? username;
  final String error;

  BridgeResponse({
    required this.valid,
    required this.username,
    required this.error,
  });

  factory BridgeResponse.fromJson(Map<String, dynamic>? json) => BridgeResponse(
        valid: asBool(json, 'valid'),
        username: asString(json, 'username'),
        error: asString(json, 'error'),
      );

  factory BridgeResponse.fromJsonString(String jsonString) =>
      BridgeResponse.fromJson(json.decode(jsonString));

  Map<String, dynamic> toJson() => {
        'valid': valid,
        'username': username,
        'error': error,
      };
}
