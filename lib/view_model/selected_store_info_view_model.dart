import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import 'package:sidam_worker/data/repository/store_repository.dart';
import 'package:sidam_worker/model/store.dart';

class SelectedStore extends ChangeNotifier {

  final _logger = Logger();
  late final StoreRepositoryImpl _storeRepository;
  Store _nowStore = Store();
  Store get storeInfo => _nowStore;

  SelectedStore() {
    _storeRepository = StoreRepositoryImpl();
    getStoreOb();
  }

  Future<void> getStoreOb() async {

    _nowStore = await _storeRepository.getStoreData();
    notifyListeners();
  }
}