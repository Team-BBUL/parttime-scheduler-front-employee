import 'package:sidam_worker/model/user_model.dart';

class ScheduleList {
  final int id;
  final DateTime day;
  final List<Schedule> schedule;

  ScheduleList({
    required this.id,
    required this.day,
    required this.schedule
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "day": "${day.year}-${day.month}-${day.day}",
    "schedule": schedule.map<Map<String, dynamic>>(
            (value) => value.toJson()
    ).toList(),
  };
}

class Schedule {

  late int id;
  late DateTime day;
  late List<bool> time;
  late List<User> workers;

  Schedule({
    required this.id,
    required this.day,
    required this.time,
    required this.workers
  });

  Schedule.dummy(DateTime day, int time) {
    this.id = 0;
    this.workers = [];
    this.time = [];
    this.day = day;

    for (int i = 0; i < time; i++) {
      this.time.add(false);
    }
  }

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

  static Schedule fromSingleJson(Map<String, dynamic> json) {
    return Schedule(
        id: json['id'],
        day: json['day'],
        time: json['time'].map<bool>((value) {
          return value ? true : false;
        }).toList(),
        workers: json['workers'].map<User>((user) {
          return User.fromJson(user);
        }).toList()
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "workers": workers.map<Map<String, dynamic>>((value) {
      return value.toJson();
    }).toList()
  };
}