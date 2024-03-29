
import 'package:intl/intl.dart';

class UnWorkableSchedule {
  List<Unworkable>? unWorkable;

  UnWorkableSchedule({this.unWorkable});

  UnWorkableSchedule.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      unWorkable = <Unworkable>[];
      json['data'].forEach((v) {
        unWorkable!.add(new Unworkable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.unWorkable != null) {
      data['data'] = this.unWorkable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Unworkable {
  DateTime date;
  List<bool>? time;

  Unworkable({required this.date, this.time});

  factory Unworkable.fromJson(Map<String, dynamic> json) {
    String dateString = json['date'];
    List<String> convert = dateString.split('-');
    DateTime date = DateTime(int.parse(convert[0]), int.parse(convert[1]), int.parse(convert[2]));
    List<bool> time = json['time'].cast<bool>();

    return Unworkable(date: date, time: time);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = DateFormat('yyyy-MM-dd').format(this.date);
    data['time'] = this.time;
    return data;
  }
}

/*
class ImpossibleTime {
  List<Data>? data;

  ImpossibleTime({this.data});

  ImpossibleTime.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? day;
  List<Time>? time;

  Data({this.day, this.time});

  Data.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['time'] != null) {
      time = <Time>[];
      json['time'].forEach((v) {
        time!.add(new Time.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    if (this.time != null) {
      data['time'] = this.time!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Time {
  int? hour;

  Time({this.hour});

  Time.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hour'] = this.hour;
    return data;
  }
}


 */