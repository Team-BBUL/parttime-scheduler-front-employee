class User {

  User({
    required this.name,
    required this.id,
    required this.color,
    required this.cost
  }) {
    salary = true;
  }

  final String name;
  final int id;
  late final bool salary;
  String color = '0xFFFFFFFF';
  int cost = 0;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['alias'],
        id: json['id'],
        color: json['color'],
        cost: json['cost']
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'color': color,
    'cost': cost,
  };
}
