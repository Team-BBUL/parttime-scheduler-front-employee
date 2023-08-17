import 'package:flutter/cupertino.dart';
import 'package:sidam_employee/data/repository/store_repository.dart';

import '../model/store.dart';


class StoreViewModel extends ChangeNotifier{
  String _searchText = '';
  late StoreRepository storeRepository;
  List<Store>? _stores;
  Store _store = Store();
  bool expanded = false;
  int? _selectedIndex;

  List<Store>? get stores => _stores;
  Store get storeInfo => _store;
  String get searchText => _searchText;
  int? get selectedIndex => _selectedIndex;

  StoreViewModel(this.storeRepository){
    getStores();
  }

  void setSearchText(String text){
    _searchText = text;
    notifyListeners();
  }

  void getStores() async{
    init();
    print(_searchText);
    _stores = await storeRepository.fetchStores();
    notifyListeners();
  }

  void getStoresWithSearch() async{
    init();
    try {
      _stores = await storeRepository.fetchSearchedStores(_searchText);
      // _stores = _stores?.filterStores(_searchText);
    }catch(e){
      print(e);
    }
    notifyListeners();
  }
  init(){
    _store = Store();
    _stores = null;
    expanded = false;
  }

  void setStore(int idx) async{
    expanded = true;
    _store = _stores![idx];
    notifyListeners();
  }


  Future joinStore() async{
    try {
      await storeRepository.addStore(_store.id!);
    }catch(e){
      print(e);
    }
  }

  Future enter() async{
    await Future.delayed(Duration(seconds: 1));
    try{
      await storeRepository.enterStore(stores![selectedIndex!].id!);
    }catch(e){
      print(e);
      throw e;
    }
  }

  void setSelectedIndex(int idx){
    _selectedIndex = idx;
    notifyListeners();
  }
}