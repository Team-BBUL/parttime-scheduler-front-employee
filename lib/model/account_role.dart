class AccountRole{
  int? id;
  String? alias;
  int? level;
  int? cost;
  String? color;
  bool? isSalary;
  bool? vaild;

  AccountRole({this.id, this.alias, this.level, this.cost, this.color, this.isSalary, this.vaild});

  AccountRole.fromJson(Map<String, dynamic> json){
    id = json['id'];
    alias = json['alias'];
    level = json['level'];
    cost = json['cost'];
    color = json['color'];
    isSalary = json['isSalary'];
    vaild = json['vaild'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['level'] = this.level;
    data['cost'] = this.cost;
    data['color'] = this.color;
    data['isSalary'] = this.isSalary;
    data['vaild'] = this.vaild;
    return data;
  }
}