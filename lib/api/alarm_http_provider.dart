import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sidam_worker/api/remote_data_source.dart';

import 'package:sidam_worker/model/AlarmModel.dart';

class AlarmHttpProvider extends ChangeNotifier {

  List<Alarm> alarms = [];

  int lastId = 0; // 페이지 번호
  bool done = false; // 과거의 데이터 로딩중인지 확인

  Session session = Session();

  var logger = Logger();

  // 초기에 알림 데이터를 가지고 오는 메소드
  Future<void> started() async {
    await _getAlarm();
  }

  // 스크롤 바의 위치에 따라 데이터를 더 가지고 오는 메소드 (= 무한 스크롤 메소드)
  void scrollListener(ScrollController controller) {

    /*
    if (notification.metrics.maxScrollExtent == notification.metrics.pixels) {
      _moreAlarm();
    }
    둘 다 의도한 움직임은 되는데, maxScrollExtent를 사용하는 쪽은 더 둔감하고, extentAfter를 사용하는 쪽은 더 민감함
    */
    if (controller.position.extentAfter < 50) {
      _moreAlarm();
    }
  }

  // 이후 스크롤을 내리면 추가로 알림 데이터를 가지고 오는 메소드
  Future<void> _moreAlarm() async {
    if (!done) {
      done = true;
      notifyListeners();
      List<Alarm>? data = await _fetchAlarmList(lastId);
      Future.delayed(const Duration(milliseconds: 1500), () {
        alarms.addAll(data);

        // 알림 목록을 추가 후 재정렬
        alarms.sort((a, b) => b.date.compareTo(a.date));

        lastId++;
        done = false;
        notifyListeners();
      });
    }
  }

  // 새로고침 버튼으로 데이터를 아예 새로 가져오는 메소드
  Future<void> renewData() async {
    alarms = [];
    lastId = 0;
    await _getAlarm();
  }

  // 알림을 가지고 오는 메소드
  Future<void> _getAlarm() async {
    List<Alarm>? data = await _fetchAlarmList(lastId);
    alarms = data;
    lastId++; // page 번호 증가

    // 알림 목록 날짜순 정렬
    alarms.sort((a, b) => b.date.compareTo(a.date));

    logger.i(lastId);
    notifyListeners();
  }

  // 서버와 통신하는 메소드
  Future<List<Alarm>> _fetchAlarmList(int last) async {

    var url = "/api/alarm/list/${session.roleId}?page=$last"; // 요청할 곳
    var response = await session.get(url); // 반환

    logger.i('$url로 알림 목록 요청');

      if (response.statusCode == 200) { // 요청이 성공하면

        List<Alarm> result = jsonDecode(response.body)['data'].map<Alarm>((alarm) {
          return Alarm.fromJson(alarm);
        }).toList();
        
        logger.i("${result.length}개의 알림 목록 데이터를 가져오는데 성공");

        return result;

      } else {
        logger.e(response.body);
        return [];
      }

  }
}