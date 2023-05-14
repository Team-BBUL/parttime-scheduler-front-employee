
class Schedule{
  String date;
  int day;
  int night;
  int cost;

  Schedule({required this.date, required this.day, required this.night, required this.cost});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      date: json['date'] as String,
      day: json['day'] as int,
      night: json['night'] as int,
      cost: json['cost'] as int,
    );
  }
}