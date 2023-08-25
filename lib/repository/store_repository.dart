import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:sidam_worker/data/local_data_source.dart';
import 'package:sidam_worker/data/remote_data_source.dart';
import 'package:sidam_worker/model/store_model.dart';
import 'package:sidam_worker/utility/sp_helper.dart';

class StoreRepository {

  final LocalDataSource _localDataSource = LocalDataSource();
  final _session = Session();
  final _helper = SPHelper();
  final _logger = Logger();

  StoreRepository() {
    _helper.init();
  }

  Future<Store> getStoreData() async {

    try {
      Map<String, dynamic>? data = await _localDataSource.loadJson('store');

      if (data == null) {
        // 서버에서 데이터 가져오기

        var res = await _session.get('/store/${_helper.getStoreId()}');
        var json = jsonDecode(res.body);

        if (json['status_code'] == 200) {
          Store store = Store.fromJson(json['data']);

          _localDataSource.saveModels(store.toJson(), 'store');
          return store;
        }
        _logger.e('클라이언트 store id 오류. ${_helper.getStoreId()} 매장이 존재하지 않음.');
        return Store(
            id: _helper.getStoreId(), name: '매장', location: '', phone: '');
      }

      return Store.fromJson(data);

    } catch (e) {
      _logger.e('[매장 정보 불러오기 오류] $e');
      return Store.setTime(id: 0, name: '매장', location: '', phone: '', open: 10, close: 23);
    }
  }
}