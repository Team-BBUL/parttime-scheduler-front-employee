class User {

  User({
    required this.alias,
    required this.id,
    required this.color,
    required this.cost
  }) {
    salary = true;
  }

  final String alias;
  final int id;
  late final bool salary;
  String color = '0xFFFFFFFF';
  int cost = 0;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        alias: json['alias'] ?? json['name'] ?? '이름',
        id: json['id'],
        color: json['color'],
        cost: json['cost']
    );
  }

  Map<String, dynamic> toJson() => {
    'alias': alias,
    'id': id,
    'color': color,
    'cost': cost,
  };
}
