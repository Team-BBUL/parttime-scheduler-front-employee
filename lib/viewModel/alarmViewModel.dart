import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';

import 'package:sidam_worker/api/Session.dart';

class AlarmViewModel {

  var logger = Logger();

  Future<bool> answerAlarm(String category, bool answer, int id) async {

    Session session = Session();

    var res = await session.post('api/alarm/$category/${session.roleId}?accept=$answer&id=$id', null);
    // 변경 요청 알림 승낙/거절 api
    var data = jsonDecode(res.body);

    logger.i(data.toString());

    if (300 > data['status_code'] && data['status_code'] >= 200) {
      return true;
    } else {
      return Future.error('반환 오류: ${data['message']}');
    }
  }

  Future<bool> deleteAlarm(int id) async {

    Session session = Session();

    var res = await session.delete('api/alarm/list/${session.roleId}?id=$id');
    // 알림 삭제 api 전송
    var data = jsonDecode(res.body);

    if (200 == data['status_code']) {
      return true;
    } else {
      return false;
    }
  }
}