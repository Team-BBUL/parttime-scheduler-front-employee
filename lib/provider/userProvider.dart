import 'package:flutter/material.dart';
import 'package:sidam_worker/model/userModel.dart';

class UserProvider with ChangeNotifier {

  UserProvider() {
    User.loadModels().then((value) => _user = value);
  }

  User? _user; // 사용자 정보

  User? get user => _user; // 사용자 정보를 반환하는 getter

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}