import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import 'package:sidam_worker/repository/store_repository.dart';
import 'package:sidam_worker/model/store_model.dart';

class StoreViewModel extends ChangeNotifier {

  final _logger = Logger();
  late final _storeRepository;
  Store _nowStore = Store();
  Store get store => _nowStore;

  StoreViewModel() {
    _storeRepository = StoreRepository();
    getStoreOb();
  }

  Future<void> getStoreOb() async {

    _nowStore = await _storeRepository.getStoreData();
    notifyListeners();
  }
}