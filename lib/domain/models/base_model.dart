import 'dart:convert';

abstract class BaseModel {
  Map<String, dynamic> toJson();

  String encode() => jsonEncode(toJson());
}
