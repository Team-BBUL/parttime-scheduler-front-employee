import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import 'package:sidam_worker/api/remote_data_source.dart';
import 'package:sidam_worker/model/notice_model.dart';
import 'package:sidam_worker/model/store_model.dart';

class NoticeViewModel extends ChangeNotifier {
  
  var logger = Logger();

  late Store _store;
  late final Session session;
  Notice _mainNotice = Notice(title: '공지사항이 없습니다', timeStamp: DateTime.now().toIso8601String(), id: 0, read: true);
  Notice get lastNotice => _mainNotice;

  NoticeViewModel() {
    session = Session();
    getTitle();
  }

  Future<void> getTitle() async {
    _mainNotice = await _loadMainNotice();
    notifyListeners();
  }

  Future<Notice> _loadMainNotice() async {

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