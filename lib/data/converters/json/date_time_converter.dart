import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    // Parse and convert to local time
    return DateTime.parse(json).toLocal();
  }

  @override
  String toJson(DateTime dateTime) {
    // Convert to UTC and ISO8601 format to send to the server
    return dateTime.toUtc().toIso8601String();
  }
}
