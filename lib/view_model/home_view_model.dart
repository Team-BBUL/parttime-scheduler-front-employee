import 'package:flutter/material.dart';

import 'package:sidam_employee/data/local_data_source.dart';
import 'package:sidam_employee/data/remote_data_source.dart';
import 'package:sidam_employee/data/repository/store_repository.dart';
import 'package:sidam_employee/model/store.dart';
import 'package:sidam_employee/util/sp_helper.dart';

class HomeViewModel extends ChangeNotifier {

  late final LocalDataSource _dataSource;
  late final Session _session;
  late final StoreRepositoryImpl _storeRepository;
  late final SPHelper _helper;

  Store _localData = Store();
  Store _store = Store();
  Store get store => _store;

  // TODO 인센티브 받아다 저장하는 메소드 만들기

  HomeViewModel() {
    _dataSource = LocalDataSource();
    _session = Session();
    _storeRepository = StoreRepositoryImpl();
    _helper = SPHelper();

    getData();
  }

  // 메인 메소드
  Future<void> getData() async {

    await _helper.init();
    if (_store.id == null || _store.id == 0) {
      await _getStoreToServer();
      await _getStoreToLocal();
    }

    if (!_store.compare(_localData)) {
      _dataSource.saveModels(_store.toJson(), 'store.json');
    }

    _helper.writeWeekStartDay(_store.weekStartDay!);
    _helper.writeStoreId(_store.id!);
    _helper.writeStoreName(_store.name!);

    notifyListeners();
  }

  // 서버에서 매장 정보 데이터 가져오기
  Future<void> _getStoreToServer() async {

    await _session.init();
    _store = await _storeRepository.getStoreData();
  }

  // local에서 매장 정보 데이터 가져오기
  Future<void> _getStoreToLocal() async {

    _localData = Store.fromJson(await _dataSource.loadJson('store'));
  }

  // 서버에서 인센티브 정보 가져오기
  Future<void> _getIncentiveToServer() async {

  }
}