class Account {
  String? name;
  bool? onceVerified;

  Account({this.name, this.onceVerified});

  Account.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    onceVerified = json['onceVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['onceVerified'] = this.onceVerified;
    return data;
  }
}