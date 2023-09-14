
import 'dart:convert';
import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:sidam_employee/data/local_data_source.dart';
import 'package:sidam_employee/model/account_role.dart';
import 'package:sidam_employee/model/store.dart';
import '../../util/sp_helper.dart';
import 'package:sidam_employee/data/remote_data_source.dart';

import 'package:http/http.dart' as http;

abstract class StoreRepository{
  Future<List<Store>> fetchSearchedStores(String search);
  Future<List<Store>> fetchStores();
  Future<List<Store>> fetchMyStoreList();
  Future enterStore(int storeId);
  Future addStore(int storeId);
  _saveToSpCurrentStore(Store store, AccountRole accountRole);
}

class StoreRepositoryImpl implements StoreRepository{

  StoreRepositoryImpl() {
    _dataSource = LocalDataSource();
  }

  final _session = Session();
  final _helper = SPHelper();
  final _logger = Logger();
  late LocalDataSource _dataSource;

  static String storeApi = 'http://10.0.2.2:8088/store';
  static String enterUrl = 'http://10.0.2.2:8088/api';

  static SPHelper helper = SPHelper();
  final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
    'Content-Type': 'application/json'};

  Future<List<Store>> getAllStoreName() async {
    helper.init();
    final String apiUrl = '$storeApi/search/all';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      helper.writeIsRegistered(true);
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      log("fetchStore : $decodedData");
      List<Store> storeList = [];

      for (var item in decodedData["data"]) {
        storeList.add(Store.fromJson(item));
      }
      return storeList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception();
    } else{
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  Future<List<Store>> getAllStores(String search) async {
    helper.init();
    final String apiUrl = '$storeApi/search?input=$search';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      helper.writeIsRegistered(true);
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      log("fetchStore : $decodedData");
      List<Store> storeList = [];
      for (var item in decodedData["data"]) {
        storeList.add(Store.fromJson(item));
      }
      return storeList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception();
    } else{
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future addStore(int storeId) async {
    helper.init();
    final String apiUrl = '$storeApi/add/$storeId';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      helper.writeStoreId(decodedData['store_id']);
      helper.writeRoleId(decodedData['account_role_id']);
      log("fetchStore : $decodedData");
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception();
    } else{
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }


  @override
  Future<List<Store>> fetchSearchedStores(String search) async {
    helper.init();
    final String apiUrl = '$storeApi/search?input=$search';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      helper.writeIsRegistered(true);
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      log("fetchStore : $decodedData");

      List<Store> storeList = [];
      for (var item in decodedData["data"]) {
        storeList.add(Store.fromJson(item));
      }
      return storeList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception();
    } else{
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future<List<Store>> fetchStores() async {
    helper.init();
    final String apiUrl = '$storeApi/my-list?role=EMPLOYEE';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      helper.writeIsRegistered(true);
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      log("fetchStore : $decodedData");

      List<Store> storeList = [];
      for (var item in decodedData["data"]) {
        storeList.add(Store.fromJson(item));
      }
      return storeList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception();
    } else{
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }


  @override
  Future<List<Store>> fetchMyStoreList() {
    throw UnimplementedError();
  }
  @override
  _saveToSpCurrentStore(Store store, AccountRole accountRole){
    helper.writeStoreName(store.name!);
    helper.writeStoreId(store.id!);
    helper.writeRoleId(accountRole.id!);
    helper.writeAlias(accountRole.alias!);
  }

  @override
  Future enterStore(int storeId) async {
    helper.init();
    final String apiUrl = '$enterUrl/enter/$storeId';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    log('$apiUrl로 입장 요청');
    if (response.statusCode == 200) {
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      log("enterStoreData : $decodedData");

      helper.writeStoreId(storeId);
      Store store = Store.fromJson(decodedData['data']['store']);
      AccountRole accountRole = AccountRole.fromJson(decodedData['data']['accountRole']);
      _saveToSpCurrentStore(store, accountRole);
      await _dataSource.saveModels(store.toJson(), 'store.json');

    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception();
    } else{
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  Future<Store> getStoreData() async {

    try {
      Map<String, dynamic>? data = await _dataSource.loadJson('store');

      if (data["code"] != null && data["code"] == "error") {
        // 서버에서 데이터 가져오기
        var res = await _session.get('/store/my-list?role=EMPLOYEE');
        var json = jsonDecode(res.body);

        if (res.statusCode == 200) {
          Store store = Store.fromJson(json['data']);

          _dataSource.saveModels(store.toJson(), 'store.json');
          return store;
        }
        _logger.e('클라이언트 store id 오류. ${_helper.getStoreId()} 매장이 존재하지 않음.');
        return Store.base(
            id: _helper.getStoreId(), name: '매장', location: '', phone: '');
      }

      return Store.fromJson(data);

    } catch (e) {
      _logger.e('[매장 정보 불러오기 오류] $e');
      return Store.setTime(id: 0, name: '매장', location: '', phone: '', open: 10, close: 23);
    }
  }
}