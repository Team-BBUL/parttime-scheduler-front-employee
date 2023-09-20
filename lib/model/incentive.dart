class MonthIncentive{
  int? id;
  String? alias;
  List<Incentive>? incentives;

  MonthIncentive({this.id,this.alias, this.incentives});
}

class Incentive {
  int? id;
  int? cost;
  String? description;
  DateTime? date;

  Incentive({ this.id, this.cost, this.description, this.date});

  Incentive.fromJson(Map<String, dynamic> json){
    id = json['id'];
    cost = json['cost'];
    description = json['description'];
    date = DateTime.parse(json['date']);
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cost'] = this.cost;
    data['description'] = this.description;
    data['date'] = this.date?.toIso8601String();
    return data;
  }

  koreanWeekday(){
    int? weekday = this.date?.weekday;
    if(weekday == 1) {
      return '월';
    }else if(weekday == 2) {
      return '화';
    }else if(weekday == 3) {
      return '수';
    }else if(weekday == 4) {
      return '목';
    }else if(weekday == 5) {
      return '금';
    }else if(weekday == 6) {
      return '토';
    }else if(weekday == 7) {
      return '일';
    }
  }

}