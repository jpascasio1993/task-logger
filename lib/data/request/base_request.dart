import 'dart:convert';

abstract class BaseRequest {
  Map<String, dynamic> toJson();

  String encode() => jsonEncode(toJson());
}
