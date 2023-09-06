
class AccountRole{
  final int id;
  final String alias;
  final String color;
  final int cost;

  AccountRole({
    required this.id,
    required this.alias,
    required this.color,
    required this.cost
  });

  int getId() { return id; }

  factory AccountRole.fromJson(Map<String, dynamic> json) {
    return AccountRole(
        id: json['id'],
        alias: json['alias'],
        color: json['color'],
        cost: json['cost']
    );
  }
}