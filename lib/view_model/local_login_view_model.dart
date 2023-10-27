import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sidam_employee/data/local_data_source.dart';
import 'package:sidam_employee/data/repository/store_repository.dart';

import 'package:sidam_employee/model/account_data.dart';
import 'package:sidam_employee/model/account_role.dart';
import 'package:sidam_employee/util/sp_helper.dart';

import '../data/repository/account_repository.dart';

class LocalLoginViewModel extends ChangeNotifier {

  late final LocalDataSource _dataSource;
  late final AccountRepository _loginRepository;
  late final StoreRepositoryImpl _storeRepository;
  AccountData login = AccountData(accountId: '', password: '', role: 'MANAGER');
  AccountRole account = AccountRole();
  final SPHelper _helper = SPHelper();
  final Logger _logger = Logger();

  bool loading = false; // api를 보내고 기다리는 중인지 확인
  bool success = false; // 로그인 api의 성공/실패 여부
  bool init = false; // 회원 정보 등록 여부
  bool updateLoading = false; // 회원정보 등록 전송 중인지 확인
  bool inStore = false; // 매장이 있는 회원인지 확인
  String message = '';

  LocalLoginViewModel() {
    _helper.init();
    _dataSource = LocalDataSource();
    _loginRepository = AccountRepository();
    _storeRepository = StoreRepositoryImpl();
  }

  Future<void> getAccountRole() async {
    if (account.id == null || account.id == 0){
      account = await _loginRepository.getAccountRole();
    }
  }

  Future<void> saveAccountRole() async {
    _loginRepository.saveAccountRole(account);
  }

  Future<void> fetchLogin(String id, String pw) async {
    if (!loading){

      await _dataSource.init();
      loading = true;

      login.accountId = id;
      login.password = pw;

      http.Response res = await _loginRepository.login(login);
      init = false;

      if (res.statusCode == 200) {
        success = true;
        List<String> token = (res.headers['authorization'] ?? '').split(' ');
        _logger.i('token = ${token[1]}');
        _helper.writeJWT(token[1]); // 토큰 넣기
        _helper.writeIsLoggedIn(true); // 로그인 여부 true

        Map<String, dynamic> data = jsonDecode(res.body);
        log('$data');
        _helper.writeStoreId(data['store']);
        init = data['user']['valid'] ?? false;
        _helper.writeIsRegistered(init);
        _helper.writeRoleId(data['user']['id']);
        _helper.writeAlias(data['user']['alias']);

        account = AccountRole.fromJson(data['user']);
        saveAccountRole();

      } else {
        success = false;
        message = jsonDecode(res.body)['message'];
      }

      Future.delayed(const Duration(milliseconds: 1000), () {
        loading = false;
        notifyListeners();
      });
    }
  }

  // 회원정보 등록 메소드
  Future<void> setAccountData(String id, String pw, String pwCheck) async {
    if (!updateLoading) {
      updateLoading = true;

      message = await _loginRepository.updateAccountData(AccountData.update(id, pw, pwCheck));

      if (message.contains('성공')) {
        log('등록 성공');
        _helper.writeIsRegistered(true);
      }

      Future.delayed(const Duration(milliseconds: 1000), (){
        updateLoading = false;
        _helper.writeIsRegistered(true);
        notifyListeners();
      });
    }
  }

  Future getStoreData() async {
    _storeRepository.getStoreData();
  }
}