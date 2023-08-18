import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sidam_worker/api/remote_data_source.dart';

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

  static Future<User> loadModels() async {
    // JSON 파일 로드
    final jsonString = await rootBundle.loadString('assets/json/userData.json');
    Session session = Session();

    if (jsonString.isEmpty) {
      // api로 서버에 유저 정보를 요청하고 받아온 유저 정보를 저장해야...?
      //dynamic res = session.get('${session.server}/api/employee/${storeId}?id=${id}');
    }

    // JSON 데이터 파싱
    final jsonList = json.decode(jsonString);

    // User 생성
    final userModels = User.fromJson(jsonList);

    return userModels;
  }

  // asset/json/userData.json이 존재하면 삭제하고, 저장
  // 매개변수 Map<String, dynamic> data
  static Future<bool> saveModels(Map<String, dynamic> data) async {

    bool result = false;

    final jsonString = json.encode(data);

    final file = File('assets/json/userData.json');

    if (file.existsSync()) {
      file.writeAsString(jsonString);
      file.delete();
    }

    file.writeAsString(jsonString);

    return result;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['alias'],
        id: json['id'],
        color: json['color'],
        cost: json['cost']
    );
  }
}
