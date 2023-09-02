
import 'dart:convert';
import 'dart:developer';

import 'package:sidam_worker/model/account_role.dart';

import '../../model/store.dart';
import '../../util/sp_helper.dart';

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
  static String storeApi = 'http://10.0.2.2:8088/store';

  static SPHelper helper = SPHelper();
  final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
    'Content-Type': 'application/json'};

  @override
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

  @override
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
    // TODO: implement fetchMyStoreList
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
    final String apiUrl = '$storeApi/enter/$storeId';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      log("enterStoreData : $decodedData");
      helper.writeStoreId(storeId);
      Store store = Store.fromJson(decodedData['data']['store']);
      AccountRole accountRole = AccountRole.fromJson(decodedData['data']['accountRole']);
      _saveToSpCurrentStore(store, accountRole);
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw Exception();
    } else{
      log('failed : ${response.body}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

}