class MonthSchedule {
  List<dynamic>? date;
  String? timeStamp;

  MonthSchedule({this.date, this.timeStamp});

  MonthSchedule.fromJson(Map<String, dynamic> json) {
    if (json['date'] != null) {
      date = <Date>[];
      json['date'].forEach((v) {
        if(v != null){
          date!.add(new Date.fromJson(v));
        }
      });
    }
    timeStamp = json['time_stamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.date != null) {
      data['date'] = this.date!.map((v) => v.toJson()).toList();
    }
    data['time_stamp'] = this.timeStamp;
    return data;
  }

}
class Date {
  int? id;
  String? day;
  List<Schedule>? schedule;

  Date({this.id, this.day, this.schedule});

  Date.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    if (json['schedule'] != null) {
      schedule = <Schedule>[];
      json['schedule'].forEach((v) {
        schedule!.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    if (this.schedule != null) {
      data['schedule'] = this.schedule!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Schedule {
  int? id;
  List<bool>? time;
  List<Workers>? workers;

  Schedule({this.id, this.time, this.workers});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'].cast<bool>();
    if (json['workers'] != null) {
      workers = <Workers>[];
      json['workers'].forEach((v) {
        workers!.add(new Workers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    if (this.workers != null) {
      data['workers'] = this.workers!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Workers {
  int? id;
  String? alias;
  String? color;
  int? cost;

  Workers({this.id, this.alias, this.color, this.cost});

  Workers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    color = json['color'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['color'] = this.color;
    data['cost'] = this.cost;
    return data;
  }
}