import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sidam_employee/data/local_data_source.dart';
import 'package:sidam_employee/data/remote_data_source.dart';
import 'package:sidam_employee/model/account_data.dart';
import 'package:sidam_employee/model/account_role.dart';

class AccountRepository{

  final LocalDataSource _dataSource = LocalDataSource();
  final Session _session = Session();
  String message = '';

  AccountRepository() {
    _session.init();
  }
  
  // 로그인 메소드
  Future<http.Response> login(AccountData ad) async {
    
    http.Response res = await _session.post('/api/auth/login', {
      'accountId': ad.accountId,
      'password': ad.password
    });

    return res;
  }

  // 회원가입
  Future<String> signup(AccountData ad) async {

    http.Response res = await _session.post('/api/auth/signup', ad.toJson());

    if (res.statusCode == 200) {
      return '회원가입에 성공했습니다';
    } else {
      return jsonDecode(utf8.decode(res.bodyBytes))['data'][0]['defaultMessage'];
    }
  }

  // (점주)회원 정보 등록
  Future<bool> updateAccount(AccountRole role) async {

    await _session.init();
    http.Response res = await _session.put('/api/auth/account/details', role.toUpdateAccountJson());

    if (res.statusCode == 200) {
      return true;
    }
    message = res.body;
    return false;
  }

  // 회원 정보 불러오기
  Future<AccountRole> getAccountRole() async {
    Map<String, dynamic> json = await _dataSource.loadJson('userData');

    return AccountRole.fromJson(json);
  }

  // 회원 정보 저장
  Future<void> saveAccountRole(AccountRole role) async {

    _dataSource.saveModels(role.toJson(), 'userData');
  }
  
  // 직원 id, pw 수정
  Future<String> updateAccountData(AccountData data) async {

    await _session.init();
    log('account_repository.dart 헤더 확인 ${_session.headers}');
    http.Response res = await _session.put('/api/account', data.toUpdateJson());

    if (res.statusCode == 200) {
      return '성공';
    }
    return '${jsonDecode(res.body)['message']}';
  }
}