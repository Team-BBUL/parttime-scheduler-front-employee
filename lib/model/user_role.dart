class UserRole{
  String alias;
  String level;
  String cost;
  String color;
  bool isSalary;
  bool valid;
  UserRole({
    required this.alias,
    required this.level,
    required this.cost,
    required this.color,
    required this.isSalary,
    required this.valid,
  });
  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      alias: json['alias'],
      level: json['level'],
      cost: json['cost'],
      color: json['color'],
      isSalary: json['isSalary'],
      valid: json['valid'],
    );
  }
}

