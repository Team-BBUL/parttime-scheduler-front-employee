import 'dart:convert';

import 'package:sidam_employee/data/repository/store_repository.dart';
import 'package:sidam_employee/model/account_role.dart';

import '../../model/store.dart';


class MockStoreRepository implements StoreRepository{

  Future<String> getAllStores(String search) async {
    await Future.delayed(Duration(seconds: 1));

    String testData = """
    {
    "data": [
        {
            "id": 1234,
            "name": test매장명",
            "location": "주소",
            "phone": "031-123-4567"
        },
        {
            "id": 1234,
            "name": "mock매장명",
            "location": "주소",
            "phone": "031-123-4567"
        }
    ]
}
""";
    return testData;
  }

  Future<String> getAllStoreName() async{
    await Future.delayed(Duration(seconds: 1));

    String testData = """
    {
    "data": [
        {
            "id": 1234,
            "name": "test매장명",
            "location": "주소",
            "phone": "031-123-4567"
        },
        {
            "id": 1234,
            "name": "mock매장명",
            "location": "주소",
            "phone": "031-123-4567"
        }
    ]
}
""";
    return testData;
  }

  @override
  Future<List<Store>> fetchStores() async {
    final jsonData = await getAllStoreName();
    final decodedData = json.decode(jsonData);
    List<Store> storeList = [];
    for (var item in decodedData['data']) {
      storeList.add(Store.fromJson(item));
    }
    return storeList;
  }

  @override
  Future<List<Store>> fetchSearchedStores(String search) async {
    final jsonData = await getAllStores(search);
    final decodedData = json.decode(jsonData);
    List<Store> storeList = [];
    for (var item in decodedData['data']) {
      storeList.add(Store.fromJson(item));
    }
    return storeList;
  }

  @override
  Future addStore(int storeId) {
    // TODO: implement addStore
    throw UnimplementedError();
  }

  @override
  Future<List<Store>> fetchMyStoreList() {
    // TODO: implement fetchMyStoreList
    throw UnimplementedError();
  }

  @override
  saveToSpCurrentStore(Store store) {
    // TODO: implement saveToSpCurrentStore
    throw UnimplementedError();
  }

  @override
  Future enterStore(int storeId) {
    // TODO: implement enterStore
    throw UnimplementedError();
  }




}