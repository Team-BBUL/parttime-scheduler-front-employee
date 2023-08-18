import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sidam_worker/model/user_model.dart';

class UserProvider with ChangeNotifier {

  UserProvider() {
    User.loadModels().then((value) => _user = value)
        .catchError((error) {
          Logger logger = Logger();
          logger.e('$error');
          return User(name: '사용자', id: 0, color: '0xFF000000', cost: 0);
    });
  }

  User? _user; // 사용자 정보

  User? get user => _user; // 사용자 정보를 반환하는 getter

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}