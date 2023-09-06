import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:sidam_employee/model/user_model.dart';
import 'package:sidam_employee/repository/user_repository.dart';

class UserProvider with ChangeNotifier {

  User? _user; // 사용자 정보
  User? get user => _user; // 사용자 정보를 반환하는 getter

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  final _logger = Logger();
  late final UserRepository _userRepository;

  UserProvider() {
    _userRepository = UserRepository();
    getUser();
  }

  Future<void> getUser() async {
    _user = await _userRepository.getUserData();
    notifyListeners();
  }
}