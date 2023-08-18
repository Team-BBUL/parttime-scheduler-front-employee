import 'package:sidam_worker/model/change_request_model.dart';

class Alarm {
  final int id;
  final String type;
  String state;
  final String content;
  final DateTime date;
  bool read;
  ChangeRequest? request;
  bool valid = true;

  Alarm({
    required this.id,
    required this.type,
    required this.state,
    required this.content,
    required this.date,
    required this.read,
    required this.request
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
        id: json["id"],
        type: json["type"],
        state: json["state"],
        content: json["content"],
        date: DateTime.parse(json["date"]),
        read: json["read"],
        request: json['request'] != null ?
            ChangeRequest.fromJson(json['request']) :
            null
    );
  }
}