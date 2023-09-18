import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sidam_employee/data/remote_data_source.dart';
import 'package:sidam_employee/util/sp_helper.dart';
import '../../model/unworkable_schedule.dart';

class ImpossibleScheduleRepository{

  late final Session _session;
  late final SPHelper _helper;
  final Logger _logger = Logger();

  ImpossibleScheduleRepository() {
    _session = Session();
    _helper = SPHelper();

    _session.init();
    _helper.init();
  }

  Future<void> saveJson(UnWorkableSchedule unWorkableSchedule) async {
    try {
      final jsonData = jsonEncode(unWorkableSchedule.toJson());

      //해당 앱에서만 엑세스 할 수 있는 경로 (/data/user/0/패키지이름/app_flutter)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/impossible_schedule.json');

      await file.writeAsString(jsonData);
    } catch (e) {
      print('Error saving cells to JSON: $e');
    }
  }

  Future<UnWorkableSchedule> loadJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/impossible_schedule.json');

      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final decodedData = json.decode(jsonData);

        return UnWorkableSchedule.fromJson(decodedData);
      }
    } catch (e) {
      print('Error loading cells from JSON: $e');
    }
    return UnWorkableSchedule();
  }

  // 서버에 근무 불가능 시간을 저장하는 메소드
  Future<bool> postData(UnWorkableSchedule data) async {

    try {
      http.Response res = await _session.post(
          '/api/schedule/impossible/${_helper.getStoreId()}?id=${_helper.getRoleId()}',
          data.toJson());

      if (res.statusCode == 200) {
        return true;
      }
      return false;

    } catch (e) {
      _logger.e('근무 불가능 시간 전송 오류\n$e');
      return false;
    }
  }

  // 서버에 근무 불가능 시간을 수정을 전송하는 메소드
  Future<bool> updateData(UnWorkableSchedule data) async {
    try {

      http.Response res = await _session.post(
          '/api/schedule/impossible/update/${_helper.getStoreId()}?id=${_helper.getRoleId()}',
          data.toJson());

      if (res.statusCode == 200) {
        return true;
      }
      return false;

    } catch (e) {
      _logger.e('근무 불가능 시간 전송 오류\n$e');
      return false;
    }
  }
}