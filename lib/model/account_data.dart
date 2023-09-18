class AccountData {
  String accountId;
  String password;
  String? checkPw;
  String? role;

  AccountData.all({required this.accountId, required this.password, required this.role, required this.checkPw});
  AccountData({required this.accountId, required this.password, required this.role});
  AccountData.update(this.accountId, this.password, this.checkPw) {
    this.role = "EMPLOYEE";
  }

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
        accountId: json['accountId'],
        password: json['password'],
        role: json['role']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['password'] = password;
    data['role'] = role;
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = <String, dynamic> {};
    data['accountId'] = accountId;
    data['password'] = password;
    data['checkPassword'] = checkPw;
    return data;
  }
}