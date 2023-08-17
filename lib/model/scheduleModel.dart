
import 'package:sidam_worker/model/userModel.dart';

class Schedule {

  final int id;
  final DateTime day;
  final List<bool> time;
  final List<User> workers;

  Schedule({
    required this.id,
    required this.day,
    required this.time,
    required this.workers
  });

  factory Schedule.fromJson(Map<String, dynamic> json, DateTime day) {
    return Schedule(
        id: json['id'],
        day: day,
        time: json['time'].map<bool>((value) {
          return value ? true : false;
        }).toList(),
        workers: json['workers'].map<User>((user) {
          return User.fromJson(user);
        }).toList()
    );
  }
}