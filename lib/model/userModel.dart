import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class User {
  final String name;
  final String id;

  User({
    required this.name,
    required this.id,
  });

  static Future<List<User>> loadModels() async {
    // JSON 파일 로드
    final jsonString = await rootBundle.loadString('asset/json/userData.json');

    if (jsonString.isEmpty) {
      // api로 서버에 유저 정보를 요청하고 받아온 유저 정보를 저장해야
    }

    // JSON 데이터 파싱
    final jsonList = json.decode(jsonString) as List<dynamic>;

    // User 리스트 생성
    final userModels = jsonList
        .map((json) => User(
          name: json['name'] as String,
          id: json['id'] as String,
        )
    ).toList();

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
}
