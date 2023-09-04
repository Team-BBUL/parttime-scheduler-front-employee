import 'package:flutter/foundation.dart';

import 'sp_helper.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  late SPHelper _helper;

  SharedPreferencesProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _helper = SPHelper();
    await _helper.init();
    notifyListeners();
  }

  SPHelper get helper => _helper;

  Future<void> debugSetup() async {
    await _helper.init();
    await _helper.writeStoreName('배스킨라빈스');
    await _helper.writeRoleId(7);
    await _helper.writeWeekStartDay(1);
    await _helper.writeAlias('홍길동');
    await _helper.writeStoreId(1);
  }

// 여기에 쉐어드 프리퍼런스에 접근하는 메서드나 데이터를 추가할 수 있습니다.
  Future<String> getStoreName() async {
    return _helper.getStoreName() ?? '매장';
  }

  Future<void> setStoreName(String name) async {
    await helper.init();
    await _helper.writeStoreName(name);
  }

  Future<int> getRoleId() async {
    return _helper.getRoleId() ?? 0;
  }

  Future<String> getAlias() async {
    return _helper.getAlias() ?? '사용자';
  }
}
