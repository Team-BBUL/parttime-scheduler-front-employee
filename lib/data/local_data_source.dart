import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class LocalDataSource {

  final Logger _logger = Logger();
  late String _path;
  get path => _path;

  LocalDataSource() {
    init();
  }

  Future<void> init() async {
    _path = await _localPath;
    await Directory('$_path/data/schedules').create(recursive: true);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Map<String, dynamic>> getSchedule(DateTime now) async {

    var fileName = DateFormat('yyyyMM').format(now);

    return await loadJson('schedules/$fileName');
  }

  // 파일을 확인할 때엔 Device File Explorer에서 앱 데이터 경로를 찾아서 확인하면 됩니다
  // fileName이라는 이름의 Json 파일 불러오기
  // 반환타입 Map<String, dynamic>
  Future<Map<String, dynamic>> loadJson(String fileName) async {

    // JSON 파일 로드
    String jsonString = '';
    try {
      File jsonFile = File('${await _localPath}/data/$fileName.json');
      jsonString = await jsonFile.readAsString();
      _logger.i('${jsonFile.path} 파일 읽어오기 성공');
    } catch (e) {
      _logger.e('[$fileName.json 파일 읽어오기 오류] $e');
      jsonString = '{ "code": "error", "message": "[read fail] $e" }';
    }

    // JSON 데이터 파싱
    return json.decode(jsonString);
  }

  // asset/json/$fileName이 존재하면 "삭제"하고, 저장
  // 매개변수 Map<String, dynamic> data
  // fileName '경로/이름.확장자' 만 전달하면 assets/json/경로/이름.확장자로 저장됨
  Future<void> saveModels(Map<String, dynamic> data, String fileName) async {

    final jsonString = jsonEncode(data);

    File file;
    try {
      file = File('${await _localPath}/data/$fileName');

      if (file.existsSync()) { // 있으면 삭제
        file.delete();
      }

      file.writeAsString(jsonString);
      _logger.i('${file.path} 저장 성공');

    } catch (e) {
      _logger.e('[$fileName 파일 저장하기 오류] $e');
    }
  }
}