class AccountRole{
  int? id;
  String? alias;
  int? level;
  int? cost;
  String? color;
  bool? isSalary;
  bool? valid;
  String? role;

  AccountRole({this.id, this.alias, this.level, this.cost, this.color, this.isSalary, this.valid});

  AccountRole.fromJson(Map<String, dynamic> json){
    id = json['id'];
    alias = json['alias'];
    level = json['level'];
    cost = json['cost'];
    color = json['color'];
    isSalary = json['isSalary'];
    valid = json['valid'];
    role = json['role'];
  }

  factory AccountRole.fromSimpleJson(Map<String, dynamic> json) {
    return AccountRole(
        id: json['id'],
        alias: json['alias'],
        color: json['color'],
        cost: json['cost']
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['level'] = this.level;
    data['cost'] = this.cost;
    data['color'] = this.color;
    data['isSalary'] = this.isSalary;
    data['valid'] = this.valid;
    return data;
  }

  Map<String, dynamic> toUpdateAccountJson() {
    Map<String, dynamic> data = <String, dynamic>{};

    data['alias'] = alias;
    data['level'] = level ?? 0;
    data['cost'] = cost ?? 0;
    data['color'] = color ?? '0x00000000';
    data['isSalary'] = isSalary;
    data['valid'] = valid;

    return data;
  }

  @override
  String toString() {
    return 'id: $id\n'
        'alias: $alias\n'
        'level: $level\n'
        'cost: $cost\n'
        'color: $color\n'
        'valid: $valid\n'
        'role: $role\n';
  }
}