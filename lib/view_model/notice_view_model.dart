import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import 'package:sidam_employee/data/remote_data_source.dart';
import 'package:sidam_employee/data/repository/store_repository.dart';
import 'package:sidam_employee/model/notice_model.dart';
import 'package:sidam_employee/model/store.dart';
import 'package:sidam_employee/util/sp_helper.dart';

class NoticeViewModel extends ChangeNotifier {
  
  var _logger = Logger();

  late final _storeRepository;
  late Store _store;
  late final Session _session = Session();
  Notice _mainNotice = Notice(title: '공지사항이 없습니다', timeStamp: DateTime.now().toIso8601String(), id: 0, read: true);
  Notice get lastNotice => _mainNotice;
  SPHelper _helper = SPHelper();

  NoticeViewModel() {
    _storeRepository = StoreRepositoryImpl();
    _session.init();
    _helper.init();
    getTitle();
  }

  Future<void> getTitle() async {
    _mainNotice = await _loadMainNotice();
    notifyListeners();
  }

  Future<void> reload() async {
    _mainNotice = await _loadMainNotice();
  }

  Future<Notice> _loadMainNotice() async {

    _store = await _storeRepository.getStoreData();

    var res = await _session.get("/api/notice/${_store.id ?? _helper.getStoreId()}/view/list?last=0&cnt=1&role=${_session.roleId}");

    var data = jsonDecode(utf8.decode(res.bodyBytes));

    if (res.statusCode == 200 && data['data'].isNotEmpty) {
      return Notice.fromJson(data['data'][0]);
    } else {
      _logger.w('공지사항 불러오기 오류: ${data['message'] ?? '데이터가 없습니다.'}');
      return Notice(title: '공지사항이 없습니다', timeStamp: '2023-01-01', id: 0, read: true);
    }
  }
}