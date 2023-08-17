import 'dart:convert';

import 'package:logger/logger.dart';

import 'package:sidam_worker/api/Session.dart';
import 'package:sidam_worker/model/noticeModel.dart';
import 'package:sidam_worker/model/storeModel.dart';

class NoticeViewModel {
  
  var logger = Logger();

  late Store _store;
  
  Future<Notice> loadTitle() async {
    
    Session session = Session();

    _store = await Store.loadStore();

    var res = await session.get("/api/notice/${_store.id}/view/list?last=0&cnt=1&role=${session.roleId}");
    var data = jsonDecode(res.body);

    logger.i(data);

    if (res.statusCode == 200) {
      return Notice.fromJson(data['data'][0]);
    } else {
      return Future.error('반환 오류: ${data['message']}');
    }
  }
}